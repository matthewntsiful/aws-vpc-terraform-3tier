# Random ID for unique log group naming
resource "random_id" "log_group_suffix" {
  byte_length = 4
}

# VPC Flow Logs
# =============
#
# This module creates a VPC Flow Logs CloudWatch Log Group, an IAM Role for the
# VPC Flow Logs service, and an IAM Policy that allows the service to write logs
# to the Log Group. Finally, it creates the VPC Flow Log itself and associates it
# with the IAM Role.

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs-${var.environment}-${random_id.log_group_suffix.hex}"
  retention_in_days = var.flow_logs_retention_days
  provider          = aws.Development

  tags = {
    Name        = "vpc-flow-logs"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  name     = "vpc-flow-logs-role"
  provider = aws.Development

  # Allow the VPC Flow Logs service to assume the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "vpc-flow-logs-role"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# IAM Policy for the role
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name     = "vpc-flow-logs-policy"
  role     = aws_iam_role.vpc_flow_logs_role.id
  provider = aws.Development

  # Allow the VPC Flow Logs service to write logs to the Log Group
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = var.flow_logs_traffic_type
  vpc_id          = aws_vpc.main.id
  provider        = aws.Development

  tags = {
    Name        = "vpc-flow-logs"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}
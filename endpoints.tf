# Create VPC endpoints for S3 and DynamoDB
# These endpoints allow instances in the VPC to access S3 and DynamoDB
# without requiring a NAT gateway or internet gateway.
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  provider     = aws.Development

  # Tags are used to identify the resource and track its properties
  tags = {
    Name        = "s3-vpc-endpoint"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Get the current region
data "aws_region" "current" {}

# Create VPC endpoint for DynamoDB
# This endpoint allows instances in the VPC to access DynamoDB
# without requiring a NAT gateway or internet gateway.
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  provider     = aws.Development

  # Tags are used to identify the resource and track its properties
  tags = {
    Name        = "dynamodb-vpc-endpoint"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Associate S3 endpoint with route tables
# This allows instances in the private subnets to access S3
# without requiring a NAT gateway or internet gateway.
resource "aws_vpc_endpoint_route_table_association" "s3_private_1" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private_rtb1.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_private_2" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private_rtb2.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_db_1" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.db_rtb1.id
}

resource "aws_vpc_endpoint_route_table_association" "s3_db_2" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.db_rtb2.id
}

# Associate DynamoDB endpoint with route tables
# This allows instances in the private subnets to access DynamoDB
# without requiring a NAT gateway or internet gateway.
resource "aws_vpc_endpoint_route_table_association" "dynamodb_private_1" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = aws_route_table.private_rtb1.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_private_2" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = aws_route_table.private_rtb2.id
}
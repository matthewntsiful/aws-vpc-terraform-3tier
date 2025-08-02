# Security Group for Web Layer
resource "aws_security_group" "web_sg" {
  name_prefix = "${var.project_name}-web-sg"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = var.web_ports[0]
    to_port     = var.web_ports[0]
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow HTTPS traffic from anywhere
  ingress {
    from_port   = var.web_ports[1]
    to_port     = var.web_ports[1]
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for identifying the web security group
  tags = {
    Name        = "${var.project_name}-web-security-group"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Security Group for Application Layer
resource "aws_security_group" "app_sg" {
  name_prefix = "${var.project_name}-app-sg"
  vpc_id      = aws_vpc.main.id

  # Allow traffic from the web security group on port 8080
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for identifying the app security group
  tags = {
    Name        = "${var.project_name}-app-security-group"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Security Group for Database Layer
resource "aws_security_group" "db_sg" {
  name_prefix = "${var.project_name}-db-sg"
  vpc_id      = aws_vpc.main.id

  # Allow traffic from the app security group on port 3306
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # Restrict outbound traffic to VPC CIDR range
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  # Tags for identifying the db security group
  tags = {
    Name        = "${var.project_name}-db-security-group"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}
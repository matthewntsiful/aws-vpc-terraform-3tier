# Configure the VPC
resource "aws_vpc" "main" {
  # The CIDR block for the VPC
  cidr_block = var.vpc_cidr

  # Enable DNS support and hostnames for the VPC
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  # Set the instance tenancy to default
  instance_tenancy = "default"

  # Tags for identifying the resource
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Configure the public subnets
resource "aws_subnet" "public_subnet_1" {
  # Attach subnet to VPC
  vpc_id = aws_vpc.main.id
  # Specify CIDR block for the subnet
  cidr_block = var.subnet_cidr[0]
  # Specify availability zone
  availability_zone = data.aws_availability_zones.available.names[0]

  # Tags for identifying the resource
  tags = {
    Name        = "${var.project_name}-public-subnet-1"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "${var.project_name}-public-subnet-2"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Configure the private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr[2]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.project_name}-private-subnet-1"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr[3]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "${var.project_name}-private-subnet-2"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Configure the database subnets
resource "aws_subnet" "db_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr[4]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.project_name}-db-subnet-1"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr[5]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "${var.project_name}-db-subnet-2"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Configure the internet gateway
resource "aws_internet_gateway" "igw" {
  # Tags for identifying the resource
  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Attach the internet gateway to the VPC
resource "aws_internet_gateway_attachment" "igw_attachment" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.main.id
}

# Configure the route tables
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id

  # Tags for identifying the resource
  tags = {
    Name        = "${var.project_name}-public-route-table"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_route_table" "private_rtb1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-private-route-table-1"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_route_table" "private_rtb2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-private-route-table-2"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_route_table" "db_rtb1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-db-route-table-1"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_route_table" "db_rtb2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-db-route-table-2"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# Configure the public route
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Configure the public subnet route table association
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rtb.id
}

# Configure the private subnet route table association
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rtb1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rtb2.id
}

# Configure the database subnet route table association
resource "aws_route_table_association" "db_subnet_1_association" {
  subnet_id      = aws_subnet.db_subnet_1.id
  route_table_id = aws_route_table.db_rtb1.id
}

resource "aws_route_table_association" "db_subnet_2_association" {
  subnet_id      = aws_subnet.db_subnet_2.id
  route_table_id = aws_route_table.db_rtb2.id
}

# Configure the NAT gateways
resource "aws_eip" "nat_eip_1" {
  # Allocate Elastic IP for NAT Gateway
  domain = "vpc"

  # Tags for identifying the resource
  tags = {
    Name        = "${var.project_name}-nat-eip-1"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  # Tags for identifying the resource
  tags = {
    Name        = "${var.project_name}-nat-gateway-1"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_route" "private_nat_route_1" {
  route_table_id         = aws_route_table.private_rtb1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1.id
}

resource "aws_eip" "nat_eip_2" {
  count  = var.single_nat_gateway ? 0 : 1
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip-2"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  count         = var.single_nat_gateway ? 0 : 1
  allocation_id = aws_eip.nat_eip_2[0].id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name        = "${var.project_name}-nat-gateway-2"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_route" "private_nat_route_2" {
  route_table_id         = aws_route_table.private_rtb2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.nat_gw_1.id : aws_nat_gateway.nat_gw_2[0].id
}
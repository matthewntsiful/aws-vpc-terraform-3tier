# VPC Outputs
# These outputs provide essential information about the VPC

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
# These outputs list the IDs of the subnets categorized as public, private, and database subnets

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

output "db_subnet_ids" {
  description = "IDs of the database subnets"
  value       = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
}

# Security Group Outputs
# These outputs provide the IDs of the security groups for the web, app, and database layers

output "web_security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web_sg.id
}

output "app_security_group_id" {
  description = "ID of the app security group"
  value       = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
}

# NAT Gateway Outputs
# These outputs provide the Elastic IP addresses associated with the NAT Gateways

output "nat_gateway_ips" {
  description = "Elastic IP addresses of the NAT Gateways"
  value       = [aws_eip.nat_eip_1.public_ip, aws_eip.nat_eip_2.public_ip]
}


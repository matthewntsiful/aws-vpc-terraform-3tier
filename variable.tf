# =============================================================================
# CORE VPC CONFIGURATION
# =============================================================================

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "main"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "Tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated", "host"], var.instance_tenancy)
    error_message = "Instance tenancy must be default, dedicated, or host."
  }
}

# =============================================================================
# SUBNET CONFIGURATION
# =============================================================================

variable "subnet_cidr" {
  description = "The CIDR blocks for VPC subnets"
  type        = list(string)
  default     = [
    "10.0.1.0/24",   # Public AZ1
    "10.0.2.0/24",   # Public AZ2
    "10.0.11.0/24",  # Private AZ1
    "10.0.12.0/24",  # Private AZ2
    "10.0.21.0/24",  # DB AZ1
    "10.0.22.0/24"   # DB AZ2
  ]
  validation {
    condition     = length(var.subnet_cidr) == 6
    error_message = "Exactly 6 subnet CIDR blocks must be provided."
  }
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IP addresses to instances in public subnets"
  type        = bool
  default     = true
}

# =============================================================================
# ENVIRONMENT & TAGGING
# =============================================================================

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "Development"
  validation {
    condition     = contains(["Development", "Staging", "Production", "Testing"], var.environment)
    error_message = "Environment must be Development, Staging, Production, or Testing."
  }
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "vpc-infrastructure"
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = "DevOps-Team"
}

variable "cost_center" {
  description = "Cost center for billing purposes"
  type        = string
  default     = "IT-Infrastructure"
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# =============================================================================
# NAT GATEWAY CONFIGURATION
# =============================================================================

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnet internet access"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway for cost optimization (not recommended for production)"
  type        = bool
  default     = false
}

variable "enable_nat_gateway_tags" {
  description = "Enable additional tags for NAT Gateway resources"
  type        = bool
  default     = true
}

# =============================================================================
# VPC ENDPOINTS CONFIGURATION
# =============================================================================

variable "enable_s3_endpoint" {
  description = "Enable S3 VPC Endpoint for cost optimization"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Enable DynamoDB VPC Endpoint for cost optimization"
  type        = bool
  default     = true
}

variable "enable_additional_endpoints" {
  description = "List of additional VPC endpoints to create (e.g., ecr.dkr, ssm)"
  type        = list(string)
  default     = []
}

# =============================================================================
# MONITORING & LOGGING
# =============================================================================

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs for network monitoring"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "CloudWatch log retention period for VPC Flow Logs"
  type        = number
  default     = 30
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.flow_logs_retention_days)
    error_message = "Flow logs retention must be a valid CloudWatch retention period."
  }
}

variable "flow_logs_traffic_type" {
  description = "Type of traffic to capture in flow logs"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_logs_traffic_type)
    error_message = "Flow logs traffic type must be ACCEPT, REJECT, or ALL."
  }
}

# =============================================================================
# SECURITY CONFIGURATION
# =============================================================================

variable "web_ports" {
  description = "Ports for web tier security group"
  type        = list(number)
  default     = [80, 443]
}

variable "app_port" {
  description = "Port for app tier security group"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Port for database tier security group"
  type        = number
  default     = 3306
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access public resources"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_network_acls" {
  description = "Enable custom Network ACLs for additional security"
  type        = bool
  default     = false
}

variable "ssh_key_name" {
  description = "EC2 Key Pair name for SSH access (if needed)"
  type        = string
  default     = ""
}

# =============================================================================
# HIGH AVAILABILITY CONFIGURATION
# =============================================================================

variable "availability_zones" {
  description = "List of availability zones to use (leave empty for automatic selection)"
  type        = list(string)
  default     = []
}

variable "max_availability_zones" {
  description = "Maximum number of availability zones to use"
  type        = number
  default     = 2
  validation {
    condition     = var.max_availability_zones >= 2 && var.max_availability_zones <= 6
    error_message = "Maximum availability zones must be between 2 and 6."
  }
}

# =============================================================================
# BACKUP & DISASTER RECOVERY
# =============================================================================

variable "enable_backup_tags" {
  description = "Enable backup tags for automated backup policies"
  type        = bool
  default     = true
}

variable "backup_schedule" {
  description = "Backup schedule tag value"
  type        = string
  default     = "daily"
}

variable "retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 30
}

# =============================================================================
# COST OPTIMIZATION
# =============================================================================

variable "enable_cost_allocation_tags" {
  description = "Enable cost allocation tags for billing analysis"
  type        = bool
  default     = true
}

variable "auto_scaling_enabled" {
  description = "Enable auto-scaling capabilities"
  type        = bool
  default     = false
}

variable "spot_instances_enabled" {
  description = "Enable spot instances for cost optimization"
  type        = bool
  default     = false
}
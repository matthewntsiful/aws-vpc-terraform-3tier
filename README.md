# AWS VPC Terraform Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![VPC](https://img.shields.io/badge/AWS-VPC-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/vpc/)
[![CloudWatch](https://img.shields.io/badge/AWS-CloudWatch-FF9900?style=for-the-badge&logo=amazon-cloudwatch&logoColor=white)](https://aws.amazon.com/cloudwatch/)
[![IAM](https://img.shields.io/badge/AWS-IAM-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/iam/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Infrastructure](https://img.shields.io/badge/Infrastructure-as%20Code-blue?style=for-the-badge)](https://en.wikipedia.org/wiki/Infrastructure_as_code)
[![Production](https://img.shields.io/badge/Production-Ready-success?style=for-the-badge)](https://github.com/)

A production-ready, enterprise-grade AWS VPC infrastructure built with Terraform, implementing a secure 3-tier architecture with high availability across multiple availability zones.

## 🏗️ Architecture Overview

This infrastructure creates a complete AWS VPC with:

- **3-Tier Architecture**: Web, Application, and Database tiers
- **High Availability**: Resources distributed across 2 availability zones
- **Security**: Layered security groups with least-privilege access
- **Monitoring**: VPC Flow Logs with CloudWatch integration
- **Cost Optimization**: VPC endpoints to reduce NAT Gateway costs
- **Scalability**: Designed for production workloads

### Network Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        VPC (10.0.0.0/16)                       │
├─────────────────────────────────────────────────────────────────┤
│  AZ-1a                           │  AZ-1b                       │
├──────────────────────────────────┼──────────────────────────────┤
│  Public Subnet (10.0.1.0/24)    │  Public Subnet (10.0.2.0/24)│
│  ├─ Internet Gateway             │  ├─ Internet Gateway         │
│  └─ NAT Gateway                  │  └─ NAT Gateway              │
├──────────────────────────────────┼──────────────────────────────┤
│  Private Subnet (10.0.11.0/24)  │  Private Subnet (10.0.12.0/24)│
│  ├─ Application Servers          │  ├─ Application Servers      │
│  └─ Route to NAT Gateway         │  └─ Route to NAT Gateway     │
├──────────────────────────────────┼──────────────────────────────┤
│  DB Subnet (10.0.21.0/24)       │  DB Subnet (10.0.22.0/24)   │
│  ├─ Database Servers             │  ├─ Database Servers         │
│  └─ No Internet Access          │  └─ No Internet Access      │
└──────────────────────────────────┴──────────────────────────────┘
```

## 📁 Project Structure

```
aws-vpc-terraform/
├── main.tf                    # Main entry point and documentation
├── networking.tf              # VPC, subnets, routing, NAT gateways
├── security.tf                # Security groups for 3-tier architecture
├── monitoring.tf              # VPC Flow Logs and CloudWatch
├── endpoints.tf               # VPC endpoints for cost optimization
├── data.tf                    # Data sources (availability zones)
├── variable.tf                # Input variables with validation
├── provider.tf                # AWS provider configuration
├── output.tf                  # Output values
├── terraform.tfvars.example   # Template for variable customization
├── environments/              # Environment-specific configurations
│   ├── dev.tfvars            # Development environment
│   ├── staging.tfvars        # Staging environment
│   └── prod.tfvars           # Production environment
└── README.md                  # This file
```

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with necessary permissions

### Basic Deployment

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd aws-vpc-terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

### Environment-Specific Deployment

For different environments, use the provided tfvars files:

```bash
# Development
terraform apply -var-file=environments/dev.tfvars

# Staging
terraform apply -var-file=environments/staging.tfvars

# Production
terraform apply -var-file=environments/prod.tfvars
```

### Custom Configuration

1. **Copy the example file**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars with your values**
   ```hcl
   environment = "Production"
   project_name = "my-company-vpc"
   owner = "Platform-Team"
   vpc_cidr = "10.0.0.0/16"
   ```

3. **Deploy with custom configuration**
   ```bash
   terraform apply
   ```

## 🔧 Configuration

### Core Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `vpc_cidr` | CIDR block for the VPC | `10.0.0.0/16` | No |
| `environment` | Environment name | `Development` | No |
| `project_name` | Project name for resource naming | `vpc-infrastructure` | No |
| `owner` | Owner of the infrastructure | `DevOps-Team` | No |

### Security Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `web_ports` | Ports for web tier | `[80, 443]` |
| `app_port` | Port for application tier | `8080` |
| `db_port` | Port for database tier | `3306` |
| `allowed_cidr_blocks` | CIDR blocks allowed access | `["0.0.0.0/0"]` |

### Monitoring Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `enable_flow_logs` | Enable VPC Flow Logs | `true` |
| `flow_logs_retention_days` | Log retention period | `30` |
| `flow_logs_traffic_type` | Traffic type to capture | `ALL` |

For a complete list of variables, see [variable.tf](variable.tf).

## 🏛️ Infrastructure Components

### Networking
- **1 VPC** with DNS support and hostnames enabled
- **6 Subnets** (2 public, 2 private, 2 database) across 2 AZs
- **1 Internet Gateway** for public internet access
- **2 NAT Gateways** for private subnet internet access (high availability)
- **5 Route Tables** with appropriate routing rules

### Security
- **Web Security Group**: Allows HTTP/HTTPS from internet
- **App Security Group**: Allows traffic from web tier only
- **Database Security Group**: Allows traffic from app tier only
- **Network isolation** between tiers

### Monitoring
- **VPC Flow Logs** capturing all network traffic
- **CloudWatch Log Group** with configurable retention
- **IAM Role and Policy** for Flow Logs service

### Cost Optimization
- **S3 VPC Endpoint** (Gateway) - Free
- **DynamoDB VPC Endpoint** (Gateway) - Free
- **Route table associations** for proper traffic routing

## 📊 Outputs

After deployment, the following outputs are available:

```bash
terraform output
```

| Output | Description |
|--------|-------------|
| `vpc_id` | ID of the created VPC |
| `vpc_cidr_block` | CIDR block of the VPC |
| `public_subnet_ids` | IDs of public subnets |
| `private_subnet_ids` | IDs of private subnets |
| `db_subnet_ids` | IDs of database subnets |
| `web_security_group_id` | ID of web security group |
| `app_security_group_id` | ID of app security group |
| `db_security_group_id` | ID of database security group |
| `nat_gateway_ips` | Public IPs of NAT Gateways |

## 🌍 Environment Configurations

### Development (`environments/dev.tfvars`)
- **Cost-optimized**: Single NAT Gateway
- **Reduced monitoring**: 7-day log retention
- **Relaxed security**: Open access for development
- **CIDR**: `10.10.0.0/16`

### Staging (`environments/staging.tfvars`)
- **Production-like**: Dual NAT Gateways
- **Moderate monitoring**: 14-day log retention
- **Testing environment**: Similar to production
- **CIDR**: `10.20.0.0/16`

### Production (`environments/prod.tfvars`)
- **High availability**: Dual NAT Gateways
- **Extended monitoring**: 90-day log retention
- **Maximum security**: Restricted access
- **CIDR**: `10.0.0.0/16`

## 🔒 Security Best Practices

This infrastructure implements several security best practices:

1. **Network Segmentation**: 3-tier architecture with isolated subnets
2. **Least Privilege**: Security groups allow only necessary traffic
3. **No Direct Internet Access**: Private and DB subnets use NAT Gateways
4. **Monitoring**: VPC Flow Logs capture all network traffic
5. **Encryption**: All data in transit and at rest (where applicable)

## 💰 Cost Optimization

- **VPC Endpoints**: Reduce NAT Gateway data transfer costs
- **Environment-specific sizing**: Different configurations per environment
- **Resource tagging**: Comprehensive cost allocation tags
- **Optional single NAT**: Cost savings for development environments

## 🔍 Monitoring and Logging

### VPC Flow Logs
- Captures all network traffic (ACCEPT, REJECT, ALL)
- Stored in CloudWatch Logs
- Configurable retention periods
- Useful for security analysis and troubleshooting

### CloudWatch Integration
- Centralized logging
- Custom retention policies
- Integration with AWS monitoring tools

## 🚨 Troubleshooting

### Common Issues

1. **Insufficient Permissions**
   ```bash
   Error: AccessDenied: User is not authorized to perform: ec2:CreateVpc
   ```
   **Solution**: Ensure your AWS credentials have VPC creation permissions.

2. **CIDR Conflicts**
   ```bash
   Error: InvalidVpc.Range: The CIDR '10.0.0.0/16' conflicts with another subnet
   ```
   **Solution**: Choose a different CIDR block in your tfvars file.

3. **Resource Limits**
   ```bash
   Error: VpcLimitExceeded: The maximum number of VPCs has been reached
   ```
   **Solution**: Delete unused VPCs or request a limit increase.

### Validation Commands

```bash
# Validate Terraform configuration
terraform validate

# Check formatting
terraform fmt -check

# Plan with specific environment
terraform plan -var-file=environments/prod.tfvars

# Show current state
terraform show
```

## 🧹 Cleanup

To destroy the infrastructure:

```bash
# Destroy with confirmation
terraform destroy

# Destroy specific environment
terraform destroy -var-file=environments/dev.tfvars

# Auto-approve (use with caution)
terraform destroy -auto-approve
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Terraform best practices
- Add validation to variables where appropriate
- Update documentation for new features
- Test changes in development environment first

## 📋 Requirements

### AWS Permissions

The following AWS permissions are required:

- `ec2:*` (VPC, Subnets, Security Groups, etc.)
- `logs:*` (CloudWatch Logs)
- `iam:*` (IAM Roles and Policies)

### Terraform Version

- **Minimum**: Terraform >= 1.0
- **Recommended**: Latest stable version
- **AWS Provider**: >= 4.0

## 📚 Additional Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [VPC Security Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏷️ Tags

`aws` `terraform` `vpc` `infrastructure` `iac` `devops` `cloud` `networking` `security` `monitoring`

---

**Built with ❤️ for reliable, secure, and scalable AWS infrastructure.**
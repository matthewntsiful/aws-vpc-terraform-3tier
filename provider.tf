# Configure the Terraform providers
terraform {
  # Backend configuration provided via -backend-config flag
  backend "s3" {}

  required_providers {
    aws = {
      # Source URL for the AWS provider
      source = "hashicorp/aws"
      # Version constraint for the AWS provider
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Minimum version of Terraform required
  required_version = ">= 1.0"
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Configure the random provider
provider "random" {}

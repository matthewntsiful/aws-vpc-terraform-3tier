# Configure the Terraform providers
terraform {
  # Backend configuration for remote state storage
  backend "s3" {
    bucket         = "matthew-terraform-terraform-state-zxwoeb1w"
    key            = "vpc-infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "matthew-terraform-terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      # Source URL for the AWS provider
      source = "hashicorp/aws"
      # Version constraint for the AWS provider
      version = "~> 6.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Minimum version of Terraform required
  required_version = ">= 1.0"
}

# Configure the AWS provider for the Development environment
provider "aws" {
  # Region for the Development environment
  region = "us-east-1"
  # Alias for the provider to reference it later
  alias = "Development"
}

# Configure the AWS provider for the Production environment
provider "aws" {
  # Region for the Production environment
  region = "us-west-2"
  # Alias for the provider to reference it later
  alias = "Production"

}

# Configure the AWS provider for the Staging environment
provider "aws" {
  # Region for the Staging environment
  region = "af-south-1"
  # Alias for the provider to reference it later
  alias = "Staging"

}

# Configure the Terraform providers
terraform {
    required_providers {
        aws = {
        # Source URL for the AWS provider
        source  = "hashicorp/aws"
        # Version constraint for the AWS provider
        version = "~> 6.0"
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

#!/bin/bash

# Destroy single environment script
# Usage: ./destroy-single.sh <environment>
# Example: ./destroy-single.sh dev

set -e

if [ $# -eq 0 ]; then
    echo "❌ Error: Please specify an environment"
    echo "Usage: $0 <environment>"
    echo "Available environments: dev, staging, prod"
    exit 1
fi

ENV=$1

if [[ ! "$ENV" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Error: Invalid environment '$ENV'"
    echo "Available environments: dev, staging, prod"
    exit 1
fi

echo "🚨 WARNING: This will destroy the $ENV environment"
echo "Are you sure you want to continue? (yes/no)"
read -r confirmation

if [ "$confirmation" != "yes" ]; then
    echo "❌ Destruction cancelled"
    exit 0
fi

echo ""
echo "🔥 Destroying $ENV environment..."
echo "=================================="

terraform init -backend-config=backend-configs/$ENV.hcl
terraform destroy -var-file=environments/$ENV.tfvars -auto-approve

echo ""
echo "✅ $ENV environment destroyed successfully!"
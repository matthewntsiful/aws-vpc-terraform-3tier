#!/bin/bash

# Deploy single environment script
# Usage: ./deploy-single.sh <environment>
# Example: ./deploy-single.sh dev

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

echo "🚀 Deploying $ENV environment"
echo "Are you sure you want to continue? (yes/no)"
read -r confirmation

if [ "$confirmation" != "yes" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

echo ""
echo "🏗️ Deploying $ENV environment..."
echo "=================================="

# Reconfigure backend for this environment
terraform init -reconfigure -backend-config=backend-configs/$ENV.hcl

# Plan and apply resources
terraform plan -var-file=environments/$ENV.tfvars
terraform apply -var-file=environments/$ENV.tfvars -auto-approve

echo ""
echo "✅ $ENV environment deployed successfully!"
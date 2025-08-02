#!/bin/bash

# Plan single environment script (no apply)
# Usage: ./plan-single.sh <environment>
# Example: ./plan-single.sh dev

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

echo ""
echo "📋 Planning $ENV environment..."
echo "=================================="

# Reconfigure backend for this environment
terraform init -reconfigure -backend-config=backend-configs/$ENV.hcl

# Show plan only
terraform plan -var-file=environments/$ENV.tfvars

echo ""
echo "✅ Plan completed for $ENV environment!"
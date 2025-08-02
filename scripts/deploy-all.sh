#!/bin/bash

# Deploy all environments script
# Usage: ./deploy-all.sh

set -e

echo "🚀 Deploying ALL environments (dev, staging, prod)"
echo "Are you sure you want to continue? (yes/no)"
read -r confirmation

if [ "$confirmation" != "yes" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

environments=("dev" "staging" "prod")

for env in "${environments[@]}"; do
    echo ""
    echo "🏗️ Deploying $env environment..."
    echo "=================================="
    
    # Reconfigure backend for this environment
    terraform init -reconfigure -backend-config=backend-configs/$env.hcl
    
    # Plan and apply resources
    terraform plan -var-file=environments/$env.tfvars
    terraform apply -var-file=environments/$env.tfvars -auto-approve
    
    echo "✅ $env environment deployed"
done

echo ""
echo "🎉 All environments deployed successfully!"
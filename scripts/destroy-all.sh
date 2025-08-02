#!/bin/bash

# Destroy all environments script
# Usage: ./destroy-all.sh

set -e

echo "🚨 WARNING: This will destroy ALL environments (dev, staging, prod)"
echo "Are you sure you want to continue? (yes/no)"
read -r confirmation

if [ "$confirmation" != "yes" ]; then
    echo "❌ Destruction cancelled"
    exit 0
fi

environments=("dev" "staging" "prod")

for env in "${environments[@]}"; do
    echo ""
    echo "🔥 Destroying $env environment..."
    echo "=================================="
    
    terraform init -backend-config=backend-configs/$env.hcl
    terraform destroy -var-file=environments/$env.tfvars -auto-approve
    
    echo "✅ $env environment destroyed"
done

echo ""
echo "🎉 All environments destroyed successfully!"
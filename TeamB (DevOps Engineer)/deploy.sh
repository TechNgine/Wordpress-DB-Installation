#!/bin/bash

# Deployment script to run Terraform and Ansible together
# Author: Team B (DevOps Engineer Team)

set -e  # Exit immediately if any command fails

# Define directories
TERRAFORM_DIR="terraform"
ANSIBLE_DIR="ansible"
INVENTORY_FILE="${ANSIBLE_DIR}/inventory"

echo "🚀 Starting WordPress Deployment - Team B..."

# Navigate to Terraform directory and apply configuration
cd "$TERRAFORM_DIR"
echo "🔹 Initializing Terraform..."
terraform init

echo "🔹 Validating Terraform configuration..."
terraform validate

echo "🔹 Planning Terraform deployment..."
terraform plan -out=tfplan

echo "🔹 Applying Terraform configuration..."
terraform apply -auto-approve tfplan

# Retrieve the public IP of the EC2 instance
echo "🔹 Retrieving EC2 Public IP..."
EC2_PUBLIC_IP=$(terraform output -raw public_ip)

# Verify if Terraform output is retrieved successfully
if [[ -z "$EC2_PUBLIC_IP" ]]; then
  echo "❌ Failed to retrieve EC2 public IP. Exiting."
  exit 1
fi

# Update the Ansible inventory file
echo "🔹 Updating Ansible inventory..."
echo -e "[web_server]\n$EC2_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" > "../$INVENTORY_FILE"

# Navigate to Ansible directory and run playbook
cd "../$ANSIBLE_DIR"
echo "🔹 Running Ansible playbook..."
ansible-playbook -i "$INVENTORY_FILE" wp.config.yml

echo "✅ Deployment completed successfully!"

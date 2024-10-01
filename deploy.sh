#!/bin/bash

# Navigate to Terraform directory
cd tf || { echo "Failed to navigate to tf directory"; exit 1; }

# Apply Terraform configuration
terraform init
terraform apply -auto-approve  # Automatically approve the changes without interactive prompts

# Get the public IP from Terraform output
EC2_PUBLIC_IP=$(terraform output -raw public_ip)

# Check if the public IP is retrieved successfully
if [ -z "$EC2_PUBLIC_IP" ]; then
    echo "Failed to retrieve public IP from Terraform output"
    exit 1
fi

# Navigate to Ansible directory
cd ../ansible || { echo "Failed to navigate to ansible directory"; exit 1; }

# Create inventory file if it doesn't exist
if [ ! -f inventory.ini ]; then
    echo "[webservers]" > inventory.ini
fi

# Add the public IP to the inventory file
echo "$EC2_PUBLIC_IP ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/home/abhishek/.ssh/my-key-pair12" >> inventory.ini


# Run Ansible playbook
ansible-playbook -i inventory.ini playbook.yml

#!/bin/bash

# Get the current working directory to dynamically set the path
WORK_DIR=$(pwd)

# Update and install necessary packages
echo "Updating system and installing necessary packages..."
apt-get update
apt-get upgrade -y
apt-get install -y software-properties-common git python3-pip

# Check if Ansible is already installed, if not, install it
if ! [ -x "$(command -v ansible)" ]; then
    echo "Installing Ansible..."
    sudo apt install ansible -y  # Install Ansible using apt
else
    echo "Ansible is already installed."
fi

# Navigate to the ansible directory within the current working directory
cd "$WORK_DIR/ansible" || { echo "Directory not found"; exit 1; }

# Install required Ansible collections
echo "Installing community.mysql collection..."
ansible-galaxy collection install community.mysql

# Run the Ansible playbook with syntax check
echo "Running syntax check on the playbook..."
ansible-playbook playbook.yml -i inventory/hosts --syntax-check

# Execute the Ansible playbook with the debug flag (-vvv) for more detailed output
echo "Running the Ansible playbook with debug information..."
ansible-playbook playbook.yml -i inventory/hosts --vault-password-file /home/ubuntu/.vault_pass.txt -vvv


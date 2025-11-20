#!/bin/bash
set -e

# Install dependencies
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl

# Add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp APT repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update repo index
sudo apt-get update

# Install Terraform and Packer
sudo apt-get install -y terraform packer
echo "NOTE: HashiCorp tools installation complete."

terraform -version
packer -version



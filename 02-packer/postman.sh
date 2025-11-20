#!/bin/bash
set -euo pipefail

# ================================================================================
# Postman Installation Script (APT Repository Method)
# ================================================================================
# Description:
#   Installs the Postman REST client on Ubuntu using the official APT repo.
#   Uses apt-get instead of apt to avoid unstable CLI warnings. Stores the
#   GPG key in /etc/apt/keyrings for secure and predictable repository
#   configuration.
#
# Requirements:
#   - Ubuntu 24.04 or compatible Debian-based system
#   - Internet connectivity
# ================================================================================

# ================================================================================
# Step 1: Create the keyring directory
# ================================================================================
sudo install -d -m 0755 /etc/apt/keyrings

# ================================================================================
# Step 2: Download and register the Postman GPG key
# ================================================================================
curl -fsSL https://dl.pstmn.io/download/latest/linux_64 \
  | sudo gpg --dearmor \
  -o /etc/apt/keyrings/postman.gpg

sudo chmod a+r /etc/apt/keyrings/postman.gpg

# ================================================================================
# Step 3: Add the Postman APT repository
# ================================================================================
echo "deb [signed-by=/etc/apt/keyrings/postman.gpg] \
https://dl.pstmn.io/api/download?platform=linux64apt stable main" \
  | sudo tee /etc/apt/sources.list.d/postman.list > /dev/null

# ================================================================================
# Step 4: Update repository index and install Postman
# ================================================================================
sudo apt-get update -y
sudo apt-get install -y postman

# ================================================================================
# Completion Message
# ================================================================================
echo "NOTE: Postman installation complete."

#!/bin/bash
set -e

# Install Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

# Add VS Code repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" | \
sudo tee /etc/apt/sources.list.d/vscode.list

# Update repo index
sudo apt-get update

# Install VS Code
sudo apt-get install code


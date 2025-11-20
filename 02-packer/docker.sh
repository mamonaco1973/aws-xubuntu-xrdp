#!/bin/bash
set -euo pipefail

# ================================================================================================
# Docker Installation (Ubuntu) + Enable ALL USERS To Run Docker
# ================================================================================================
# - Installs Docker Engine from the official Docker APT repository
# - Enables Docker on startup
# - Makes /var/run/docker.sock world-writable (777)
# - Applies persistent permissions via systemd override
# ================================================================================================

# --------------------------------------
# 1. Install prerequisites
# --------------------------------------
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg

# --------------------------------------
# 2. Add Docker GPG key
# --------------------------------------
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# --------------------------------------
# 3. Add Docker repository
# --------------------------------------
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release; echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

# --------------------------------------
# 4. Install Docker Engine
# --------------------------------------
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# --------------------------------------
# 5. Create systemd override to allow ALL users to run Docker
# --------------------------------------
sudo mkdir -p /etc/systemd/system/docker.service.d

cat <<'EOF' | sudo tee /etc/systemd/system/docker.service.d/permissions.conf
[Service]
# After Docker starts, make the socket world-writable
ExecStartPost=/bin/sh -c 'chmod 777 /var/run/docker.sock'
EOF

# --------------------------------------
# 6. Reload systemd + restart Docker
# --------------------------------------
sudo systemctl daemon-reload
sudo systemctl enable --now docker
sudo systemctl restart docker

# --------------------------------------
# 7. Final message
# --------------------------------------
echo "================================================================================"
echo "Docker installed and ALL users can now run Docker without sudo."
echo "No group changes required. No logout/login required."
echo "Test with:  docker ps"
echo "================================================================================"

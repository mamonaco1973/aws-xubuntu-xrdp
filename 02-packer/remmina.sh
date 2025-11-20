#!/bin/bash
set -e

# ================================================================================
# Remmina Installation Script (Latest Stable PPA for Ubuntu 24.04)
# ================================================================================
# Description:
#   Installs the latest stable release of Remmina (RDP/VNC/SSH client) on
#   Ubuntu 24.04. Uses the official Remmina PPA to ensure the newest version.
#
# Notes:
#   - Uses apt-get for stable, script-friendly behavior.
#   - Avoids Snap and installs via APT repository only.
#   - Script stops on any error due to 'set -e'.
# ================================================================================

# ================================================================================
# Step 1: Install prerequisite packages for add-apt-repository
# ================================================================================
sudo apt-get update -y
sudo apt-get install -y software-properties-common

# ================================================================================
# Step 2: Add the official Remmina PPA (resolves outdated stock versions)
# ================================================================================
sudo add-apt-repository -y ppa:remmina-ppa-team/remmina-next

# ================================================================================
# Step 3: Update the package index after adding the PPA
# ================================================================================
sudo apt-get update -y

# ================================================================================
# Step 4: Install Remmina and common plugin packages
# ================================================================================
sudo apt-get install -y remmina remmina-plugin-rdp \
  remmina-plugin-vnc remmina-plugin-secret
echo "NOTE: Remmina installation complete."

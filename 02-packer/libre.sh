#!/bin/bash
set -e

# =====================================================================
# Install LibreOffice on Ubuntu 24.04 (DEB version, no snap)
# =====================================================================

echo "NOTE: Updating package index..."
sudo apt-get update -y

echo "NOTE: Installing LibreOffice (full suite)..."
sudo apt-get install -y libreoffice libreoffice-gnome libreoffice-common

echo "NOTE: Installation complete."
libreoffice --version


#!/bin/bash
set -e

# =====================================================================
# Install Google Chrome on Ubuntu 24.04 (DEB-based install, no snap)
# =====================================================================

echo "NOTE: Updating package index..."
sudo apt-get update -y

echo "NOTE: Installing required dependencies..."
sudo apt-get install -y wget apt-transport-https ca-certificates gnupg

echo "NOTE: Downloading Google signing key..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
  | sudo gpg --dearmor -o /usr/share/keyrings/google-linux-keyring.gpg

echo "NOTE: Adding Google Chrome apt repository..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-keyring.gpg] \
https://dl.google.com/linux/chrome/deb/ stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

echo "NOTE: Updating package index again..."
sudo apt-get update -y

echo "NOTE: Installing Google Chrome Stable (DEB)..."
sudo apt-get install -y google-chrome-stable

echo "NOTE: Chrome installation complete."
google-chrome --version

sudo cp /usr/share/applications/google-chrome.desktop \
        /etc/skel/Desktop/google-chrome.desktop

chmod 755 /etc/skel/Desktop/google-chrome.desktop
        
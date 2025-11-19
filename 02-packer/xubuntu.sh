#!/bin/bash
set -euo pipefail

sudo systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent.service || true
sudo snap remove --purge amazon-ssm-agent
sudo snap remove --purge core22
sudo snap remove --purge snapd
sudo apt purge -y snapd
sudo apt autoremove --purge -y
echo -e "Package: snapd\nPin: release *\nPin-Priority: -10" \
 | sudo tee /etc/apt/preferences.d/nosnap.pref
sudo apt update
curl https://s3.amazonaws.com/amazon-ssm-us-east-1/latest/debian_amd64/amazon-ssm-agent.deb -o ssm.deb
sudo dpkg -i ssm.deb
sudo apt install -y xubuntu-desktop-minimal
sudo apt install -y xfce4-clipman xfce4-clipman-plugin xsel xclip
sudo apt install -y xfce4-terminal xfce4-goodies xdg-utils

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/xfce4-terminal 50


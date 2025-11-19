#!/bin/bash
set -euo pipefail

sudo apt install -y xubuntu-desktop-minimal
sudo apt install -y xfce4-clipman xfce4-clipman-plugin xsel xclip
sudo apt install -y xfce4-terminal xfce4-goodies xdg-utils

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/xfce4-terminal 50


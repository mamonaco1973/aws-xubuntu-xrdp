#!/bin/bash
set -euo pipefail

sudo mkdir -p /etc/apt/preferences.d
sudo tee /etc/apt/preferences.d/firefox-no-snap.pref >/dev/null <<EOF
Package: firefox
Pin: release o=Ubuntu*
Pin-Priority: -1
EOF

sudo apt update
sudo apt install -y software-properties-common curl gnupg


curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/packages.mozilla.org.gpg

echo "deb [signed-by=/usr/share/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" \
  | sudo tee /etc/apt/sources.list.d/firefox.list >/dev/null

sudo tee /etc/apt/preferences.d/mozilla-firefox.pref >/dev/null <<EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

sudo apt update
sudo apt install -y firefox

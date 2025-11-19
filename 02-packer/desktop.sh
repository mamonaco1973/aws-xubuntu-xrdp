#!/bin/bash
set -euo pipefail

# Applications you want on every user's desktop by default
APPS=(
    /usr/share/applications/google-chrome.desktop
    /usr/share/applications/firefox.desktop
    /usr/share/applications/libreoffice-startcenter.desktop
)

# Destination (system-wide skeleton for all future users)
SKEL_DESKTOP="/etc/skel/Desktop"
mkdir -p "$SKEL_DESKTOP"

echo "Adding trusted desktop shortcuts to /etc/skel for all future users..."

for src in "${APPS[@]}"; do
    if [[ -f "$src" ]]; then
        filename=$(basename "$src")
        dest="$SKEL_DESKTOP/$filename"

        # Copy preserving everything (permissions, timestamps, etc.)
        cp -a "$src" "$dest"

        # Ensure it's executable and trusted (this survives the copy)
        chmod +x "$dest"
    else
        echo "  [WARNING] $src not found – skipping"
    fi
done

echo "Done! All new users will now get Chrome, Firefox, and LibreOffice on the desktop with NO trust prompt."

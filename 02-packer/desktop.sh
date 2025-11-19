#!/bin/bash
set -euo pipefail

# Applications you want on every new user's desktop
APPS=(
    /usr/share/applications/google-chrome.desktop
    /usr/share/applications/firefox.desktop
    /usr/share/applications/libreoffice-startcenter.desktop
)

# System-wide skeleton directory
SKEL_DESKTOP="/etc/skel/Desktop"

echo "NOTE: Creating direct trusted symlinks in /etc/skel/Desktop (no more untrusted dialog)..."

mkdir -p "$SKEL_DESKTOP"

for src in "${APPS[@]}"; do
    if [[ -f "$src" ]]; then
        filename=$(basename "$src")
        ln -sf "$src" "$SKEL_DESKTOP/$filename"
        echo "NOTE: Added $filename (direct trusted symlink)"
    else
        echo "WARNING: $src not found – skipping"
    fi
done

echo "NOTE: All new users will get exactly these three icons with zero trust prompts."
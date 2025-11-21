#!/bin/bash
set -euo pipefail

# ================================================================================
# Desktop Icon Provisioning Script (System-Wide Defaults)
# ================================================================================
# Description:
#   Creates trusted symlinks for selected applications inside /etc/skel/Desktop.
#   These symlinks ensure that all newly created users receive desktop icons
#   without the XFCE "untrusted application launcher" warning dialog.
#
# Notes:
#   - Works for XFCE, MATE, and most desktop environments using .desktop files.
#   - Only affects *new* users created after this script runs.
#   - Symlinks are used instead of copied launchers to preserve trust flags.
# ================================================================================

# ================================================================================
# Configuration: Applications to appear on every new user's desktop
# ================================================================================
APPS=(
  /usr/share/applications/google-chrome.desktop
  /usr/share/applications/firefox.desktop
  /usr/share/applications/libreoffice-startcenter.desktop
  /usr/share/applications/code.desktop
  /usr/share/applications/postman.desktop
)

SKEL_DESKTOP="/etc/skel/Desktop"

# ================================================================================
# Step 1: Ensure the skeleton Desktop directory exists
# ================================================================================
echo "NOTE: Ensuring /etc/skel/Desktop exists..."
mkdir -p "$SKEL_DESKTOP"

# ================================================================================
# Step 2: Create trusted symlinks for all selected applications
# ================================================================================
echo "NOTE: Creating trusted symlinks in /etc/skel/Desktop..."

for src in "${APPS[@]}"; do
  if [[ -f "$src" ]]; then
    filename=$(basename "$src")
    ln -sf "$src" "$SKEL_DESKTOP/$filename"
    echo "NOTE: Added $filename (trusted symlink)"
  else
    echo "WARNING: $src not found, skipping"
  fi
done

echo "NOTE: All new users will receive these desktop icons without trust prompts."


# =====================================================================
# Global XFCE Screensaver Default (60 Minutes)
# Applies to ALL users, existing and future.
# =====================================================================

TARGET_DIR="/etc/xdg/xfce4/xfconf/xfce-perchannel-xml"
TARGET_FILE="${TARGET_DIR}/xfce4-power-manager.xml"

sudo mkdir -p "$TARGET_DIR"

sudo tee "$TARGET_FILE" >/dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-power-manager" version="1.0">
  <property name="sleep-display-ac" type="uint" value="3600"/> <!-- 60 min -->
  <property name="sleep-display-battery" type="uint" value="3600"/>
  <property name="blank-on-ac" type="int" value="60"/> <!-- 60 min -->
  <property name="blank-on-battery" type="int" value="60"/>
  <property name="lock-screen-suspend-hibernate" type="bool" value="true"/>
  <property name="dpms-enabled" type="bool" value="true"/>
</channel>
EOF

sudo mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml

sudo cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml \
        /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/


echo "NOTE: Global 60-minute screensaver applied."

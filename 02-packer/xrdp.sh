#!/bin/bash
set -euo pipefail

sudo apt install -y xrdp

cat >/etc/xrdp/startwm.sh <<'EOF'
#!/bin/sh
# xrdp X session start script (c) 2015, 2017, 2021 mirabilos
# published under The MirOS Licence

# Rely on /etc/pam.d/xrdp-sesman using pam_env to load both
# /etc/environment and /etc/default/locale to initialise the
# locale and the user environment properly.

if test -r /etc/profile; then
        . /etc/profile
fi

if test -r ~/.profile; then
        . ~/.profile
fi

startxfce4
EOF

# Correct permissions
chmod 755 /etc/xrdp/startwm.sh

echo "NOTE: /etc/xrdp/startwm.sh replaced and permissions set"

systemctl enable xrdp

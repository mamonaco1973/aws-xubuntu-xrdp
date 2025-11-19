#!/bin/bash
set -euo pipefail

# ==========================================================================================
# SYSTEM PREP AND PACKAGE INSTALLATION FOR AD JOIN + EFS + AWS CLI
# ==========================================================================================
# This script prepares an Ubuntu host for:
#   - Active Directory domain joins using realmd, SSSD, and adcli
#   - NSS/PAM integration for domain users and automatic home directory creation
#   - Samba utilities required for Kerberos, NTLM, and domain discovery
#   - NFS and EFS client support (TLS-enabled amazon-efs-utils)
#   - AWS CLI v2 for accessing AWS services (Secrets Manager, S3, etc.)
# ==========================================================================================


# ------------------------------------------------------------------------------------------
# Refresh Package Metadata
# ------------------------------------------------------------------------------------------
# Ensures local APT metadata is current before installing packages. Noninteractive mode
# prevents installation prompts (e.g., timezone, Kerberos realm questions).
# ------------------------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
apt-get update -y

# ------------------------------------------------------------------------------------------
# Install Core AD, NSS, Samba, Kerberos, NFS, and Utility Packages
# ------------------------------------------------------------------------------------------
# Includes:
#   - realmd / adcli / krb5-user     : Domain discovery and Kerberos auth
#   - sssd-ad / libnss-sss / libpam-sss : Identity + authentication via SSSD
#   - samba-common-bin / samba-libs  : Required for domain membership operations
#   - oddjob / oddjob-mkhomedir      : Auto-create home directories for AD users
#   - nfs-common                     : Required for EFS and NFS mounts
#   - stunnel4                       : Enables TLS for amazon-efs-utils
#   - less / unzip / nano / vim      : Basic utilities
# ------------------------------------------------------------------------------------------

apt-get install -y \
    less unzip realmd sssd-ad sssd-tools libnss-sss libpam-sss adcli \
    samba-common-bin samba-libs oddjob oddjob-mkhomedir packagekit \
    krb5-user nano vim stunnel4 nfs-common


# ------------------------------------------------------------------------------------------
# Install Amazon EFS Utilities
# ------------------------------------------------------------------------------------------
# amazon-efs-utils provides:
#   - "mount.efs" wrapper for NFS mounts with TLS support (via stunnel)
#   - Integration with AWS APIs for fetching EFS mount targets
# The package is not in Ubuntu 24.04 repos, so it is cloned and installed manually.
# Output from dpkg and validation checks are logged to /root/userdata.log.
# ------------------------------------------------------------------------------------------
cd /tmp
git clone https://github.com/mamonaco1973/amazon-efs-utils.git

cd amazon-efs-utils
dpkg -i amazon-efs-utils*.deb >> /root/userdata.log 2>&1
which mount.efs >> /root/userdata.log 2>&1


# ------------------------------------------------------------------------------------------
# Install AWS CLI v2
# ------------------------------------------------------------------------------------------
# Provides authenticated access to AWS APIs required for:
#   - Secrets Manager (fetching credentials)
#   - S3 (pulling config files, scripts, or artifacts)
#   - General AWS automation workflows
# The ZIP bundle contains the full installer with all required binaries.
# ------------------------------------------------------------------------------------------
cd /tmp
curl -s -o awscliv2.zip \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

unzip awscliv2.zip
./aws/install

rm -rf awscliv2.zip aws

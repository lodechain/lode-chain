#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "Hardening SSH configuration..."

# Backup current SSH config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak_$(date +%F_%T)

# Disable password authentication
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
# Disable root login
sed -i 's/^#*PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
# Ensure PubkeyAuthentication is yes
sed -i 's/^#*PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service
systemctl restart sshd || systemctl restart ssh

echo "SSH Hardened. Password authentication disabled. (Make sure you have SSH keys configured!)"

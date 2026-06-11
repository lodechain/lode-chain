#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "Configuring UFW Firewall for LODE public testnet..."

# Install UFW if not present
apt-get update && apt-get install -y ufw

# Set default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH
ufw allow ssh

# Allow HTTP and HTTPS for web services (Explorer, Landing, Faucet, RPC via Nginx)
ufw allow 80/tcp
ufw allow 443/tcp

# Allow LODE Testnet P2P Port
ufw allow 38080/tcp

# Enable Firewall
ufw --force enable

echo "UFW Firewall configured and enabled successfully."
ufw status

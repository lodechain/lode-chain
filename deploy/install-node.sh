#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "Installing LODE node..."

# Create user if it doesn't exist
if ! id "lode" &>/dev/null; then
    useradd -m -s /bin/bash lode
fi

# Copy binaries
cd "$(dirname "$0")"
if [ ! -d "dist" ] || [ ! -f "dist/loded" ]; then
    echo "Binaries not found in deploy/dist. Run build-release.sh first."
    exit 1
fi

cp dist/loded dist/lode-wallet-cli dist/lode-wallet-rpc /usr/local/bin/
chmod +x /usr/local/bin/loded /usr/local/bin/lode-wallet-cli /usr/local/bin/lode-wallet-rpc

# Setup directories
mkdir -p /var/lib/lode /var/log/lode
chown -R lode:lode /var/lib/lode /var/log/lode

# Setup systemd service
cp systemd/loded-testnet.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable loded-testnet

echo "Installation complete. You can start the node with: systemctl start loded-testnet"

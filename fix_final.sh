#!/bin/bash
systemctl stop loded-testnet
cd /opt/lode-chain/build/Linux/_no_branch_/release
make -j6
cp bin/loded /usr/local/bin/
rm -rf /var/lib/lode/testnet
systemctl start loded-testnet

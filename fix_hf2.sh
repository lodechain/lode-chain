#!/bin/bash
# Hardfork arrays are now: {1, 1, 0, TS}, {16, 2, 0, TS+1}
# Let's try {16, 1, 0, TS+1} on the VPS so that v16 is active FROM BLOCK 1.
cd /opt/lode-chain/src/hardforks
sed -i 's/{ 16, 2, 0, 1341378001 }/{ 16, 1, 0, 1341378001 }/g' hardforks.cpp

systemctl stop loded-testnet
cd /opt/lode-chain/build/Linux/_no_branch_/release
make -j$(nproc)
cp bin/loded /usr/local/bin/
rm -rf /var/lib/lode/testnet
systemctl start loded-testnet

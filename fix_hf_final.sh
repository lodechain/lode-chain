#!/bin/bash
# Revert to original
cd /opt/lode-chain/src/hardforks
git restore hardforks.cpp

# Simple python script to just change the timestamp of v16 to 0, which makes it active immediately.
cat << 'PY' > update.py
import re
with open("hardforks.cpp", "r") as f: data = f.read()

# Make all arrays have {1,1,0,0}, {16,2,0,0}
def rep(m): return m.group(1) + "[] = {\n  { 1, 1, 0, 0 },\n  { 16, 2, 0, 0 },\n};"
data = re.sub(r'(const hardfork_t \w+?)\[\] = \{[^}]+\};', rep, data)

# Force tills to 1
data = re.sub(r'const uint64_t mainnet_hard_fork_version_1_till = \d+;', 'const uint64_t mainnet_hard_fork_version_1_till = 1;', data)
data = re.sub(r'const uint64_t testnet_hard_fork_version_1_till = \d+;', 'const uint64_t testnet_hard_fork_version_1_till = 1;', data)
data = re.sub(r'const uint64_t stagenet_hard_fork_version_1_till = \d+;', 'const uint64_t stagenet_hard_fork_version_1_till = 1;', data)

with open("hardforks.cpp", "w") as f: f.write(data)
PY
python3 update.py

systemctl stop loded-testnet
cd /opt/lode-chain/build/Linux/_no_branch_/release
make -j6
cp bin/loded /usr/local/bin/
rm -rf /var/lib/lode/testnet
systemctl start loded-testnet

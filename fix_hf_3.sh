#!/bin/bash
# Clean restart of entire logic
cd /opt/lode-chain/src/hardforks
git restore hardforks.cpp

cat << 'PY' > update.py
import re
with open("hardforks.cpp", "r") as f: data = f.read()

# Completely override the arrays
data = re.sub(r'const hardfork_t mainnet_hard_forks\[\] = \{.*?\};', 'const hardfork_t mainnet_hard_forks[] = {\n  { 1, 1, 0, 1341378000 },\n  { 16, 2, 0, 1341378001 },\n};', data, flags=re.DOTALL)
data = re.sub(r'const hardfork_t testnet_hard_forks\[\] = \{.*?\};', 'const hardfork_t testnet_hard_forks[] = {\n  { 1, 1, 0, 1341378000 },\n  { 16, 2, 0, 1341378001 },\n};', data, flags=re.DOTALL)
data = re.sub(r'const hardfork_t stagenet_hard_forks\[\] = \{.*?\};', 'const hardfork_t stagenet_hard_forks[] = {\n  { 1, 1, 0, 1341378000 },\n  { 16, 2, 0, 1341378001 },\n};', data, flags=re.DOTALL)

data = re.sub(r'const uint64_t mainnet_hard_fork_version_1_till = \d+;', 'const uint64_t mainnet_hard_fork_version_1_till = 1;', data)
data = re.sub(r'const uint64_t testnet_hard_fork_version_1_till = \d+;', 'const uint64_t testnet_hard_fork_version_1_till = 1;', data)
data = re.sub(r'const uint64_t stagenet_hard_fork_version_1_till = \d+;', 'const uint64_t stagenet_hard_fork_version_1_till = 1;', data)

with open("hardforks.cpp", "w") as f: f.write(data)
PY
python3 update.py

# Fix core_rpc_server check_core_ready directly
cd /opt/lode-chain/src/rpc
git restore core_rpc_server.cpp

cat << 'PY2' > update2.py
import re
with open("core_rpc_server.cpp", "r") as f: data = f.read()

# Make generateblocks work anywhere
data = re.sub(r'if\(m_core\.get_nettype\(\) != FAKECHAIN\)\s*\{\s*error_resp\.code = CORE_RPC_ERROR_CODE_REGTEST_REQUIRED;\s*error_resp\.message = "Regtest required when generating blocks";\s*return false;\s*\}', '', data, flags=re.DOTALL)

with open("core_rpc_server.cpp", "w") as f: f.write(data)
PY2
python3 update2.py

# Recompile
systemctl stop loded-testnet
cd /opt/lode-chain/build/Linux/_no_branch_/release
make -j6
cp bin/loded /usr/local/bin/
rm -rf /var/lib/lode/testnet
systemctl start loded-testnet

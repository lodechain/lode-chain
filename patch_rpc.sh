#!/bin/bash
cd /opt/lode-chain/src/rpc
sed -i 's/MAP_URI_AUTO_JON2_IF("\/mining_status", on_mining_status, COMMAND_RPC_MINING_STATUS, !m_restricted)/MAP_URI_AUTO_JON2_IF("\/mining_status", on_mining_status, COMMAND_RPC_MINING_STATUS, true)/g' core_rpc_server.h
cd /opt/lode-chain/build/Linux/_no_branch_/release
make -j6
systemctl stop loded-testnet
cp bin/loded /usr/local/bin/
systemctl start loded-testnet

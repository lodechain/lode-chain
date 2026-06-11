#!/bin/bash

# Modify src/hardforks/hardforks.cpp on the server
cat << 'HFE' > /opt/lode-chain/src/hardforks/hardforks.cpp
#include "hardforks.h"

#undef MONERO_DEFAULT_LOG_CATEGORY
#define MONERO_DEFAULT_LOG_CATEGORY "blockchain.hardforks"

const hardfork_t mainnet_hard_forks[] = {
  { 1, 1, 0, 1341378000 },
  { 16, 2, 0, 1341378001 },
};
const size_t num_mainnet_hard_forks = sizeof(mainnet_hard_forks) / sizeof(mainnet_hard_forks[0]);
const uint64_t mainnet_hard_fork_version_1_till = 1;

const hardfork_t testnet_hard_forks[] = {
  { 1, 1, 0, 1341378000 },
  { 16, 2, 0, 1341378001 },
};
const size_t num_testnet_hard_forks = sizeof(testnet_hard_forks) / sizeof(testnet_hard_forks[0]);
const uint64_t testnet_hard_fork_version_1_till = 1;

const hardfork_t stagenet_hard_forks[] = {
  { 1, 1, 0, 1341378000 },
  { 16, 2, 0, 1341378001 },
};
const size_t num_stagenet_hard_forks = sizeof(stagenet_hard_forks) / sizeof(stagenet_hard_forks[0]);
const uint64_t stagenet_hard_fork_version_1_till = 1;
HFE

systemctl stop loded-testnet
cd /opt/lode-chain/build/Linux/_no_branch_/release
make -j6
cp bin/loded /usr/local/bin/
rm -rf /var/lib/lode/testnet
systemctl start loded-testnet


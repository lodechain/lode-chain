#!/bin/bash
cd /opt/lode-chain/src/hardforks
sed -i 's/{ 16, 2, 0, 1341378000 }/{ 16, 2, 0, 1341378001 }/g' hardforks.cpp
cd /opt/lode-chain/src/cryptonote_basic
sed -i 's/if (voting_version > max_version)/if (false)/g' hardfork.cpp

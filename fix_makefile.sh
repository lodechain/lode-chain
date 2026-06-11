#!/bin/bash
sed -i 's|${MONERO_ROOT}/build/$(shell echo `uname | tr '"'"'[A-Z]'"'"' '"'"'[a-z]'"'"'`; test "$$?" -eq 0 || echo `uname | sed '"'"'s/^\(.\).*/\1/'"'"' | tr '"'"'[a-z]'"'"' '"'"'[A-Z]'"'"'``uname | sed '"'"'s/^.\(.*\)/\1/'"'"'`) | tr -d '"'"' \n'"'"'`/$(BRANCH)/release|${MONERO_ROOT}/build/Linux/_no_branch_/release|g' /opt/monero-pool-c/Makefile

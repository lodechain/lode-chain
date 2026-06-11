#!/bin/bash
./build/Linux/_no_branch_/release/bin/lode-wallet-rpc --testnet --wallet-file wallet_bob --password "1234" --daemon-address 127.0.0.1:28081 --rpc-bind-port 28082 --disable-rpc-login &
sleep 5
curl -X POST http://127.0.0.1:28082/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_balance"}' -H 'Content-Type: application/json'
pkill lode-wallet-rpc

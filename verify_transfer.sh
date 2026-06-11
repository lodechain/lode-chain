#!/bin/bash
./build/Linux/_no_branch_/release/bin/lode-wallet-rpc --wallet-file verify_alice --password "" --daemon-address 127.0.0.1:28081 --rpc-bind-port 38083 --disable-rpc-login --allow-mismatched-daemon-version &
sleep 5
curl -X POST http://127.0.0.1:38083/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"refresh"}' -H 'Content-Type: application/json'
sleep 5
curl -X POST http://127.0.0.1:38083/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"transfer","params":{"destinations":[{"amount":5000000000,"address":"KTSqBQJnL13Rcm72mHnDJ9iqPYf4WqkVC7hNCfQGEPipDJ21WTxC4GHfvuM97mVfxRj8ChRtC3UDw6xdF17CiSFe7XPQ5Me"}]}}' -H 'Content-Type: application/json'
pkill lode-wallet-rpc
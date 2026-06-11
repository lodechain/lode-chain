#!/bin/bash

cd /home/game/Desktop/LODE/lode-chain

WALLET_ADDRESS="MATxGYGWRtUDPwfojFpx6aSnXX3nLARAYTW9Dy4PzgxfVCAFMuNLR2viaNZkCauTCfdsoNMbaiE72AWuYuc2siozRhgZ3Jf"
LODED="./build/Linux/_no_branch_/release/bin/loded"

echo "ROUND | A (height / hash) | B (height / hash) | C (height / hash) | STATUS" > sync_results.txt
echo "-------------------------------------------------------------------------------" >> sync_results.txt

for i in {1..4}; do
    echo "--- Starting Round $i ---"
    
    pkill loded
    sleep 3
    pkill -9 loded 2>/dev/null
    
    rm -rf testnet_node_A testnet_node_B testnet_node_C
    mkdir -p testnet_node_A testnet_node_B testnet_node_C
    
    $LODED --testnet --data-dir testnet_node_A \
      --p2p-bind-port 38080 --rpc-bind-port 38081 --zmq-rpc-bind-port 38082 \
      --max-connections-per-ip 10 --no-igd --allow-local-ip --non-interactive > testnet_node_A/stdout.log 2>&1 &
      
    A_READY=0
    for j in {1..40}; do
        STATUS=$(curl -s -X POST http://127.0.0.1:38081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | grep -o '"status": "OK"')
        if [ "$STATUS" == '"status": "OK"' ]; then
            A_READY=1
            break
        fi
        sleep 1
    done
    if [ $A_READY -eq 0 ]; then echo "FAIL: Node A failed to start"; exit 1; fi
    
    sleep 5
    
    $LODED --testnet --data-dir testnet_node_B \
      --p2p-bind-port 38090 --rpc-bind-port 38091 --zmq-rpc-bind-port 38092 \
      --add-exclusive-node 127.0.0.1:38080 --max-connections-per-ip 10 --no-igd --allow-local-ip --non-interactive > testnet_node_B/stdout.log 2>&1 &
      
    sleep 10
    
    $LODED --testnet --data-dir testnet_node_C \
      --p2p-bind-port 38100 --rpc-bind-port 38101 --zmq-rpc-bind-port 38102 \
      --add-exclusive-node 127.0.0.1:38080 --max-connections-per-ip 10 --no-igd --allow-local-ip --non-interactive > testnet_node_C/stdout.log 2>&1 &
      
    B_READY=0
    C_READY=0
    for j in {1..40}; do
        STATUS_B=$(curl -s -X POST http://127.0.0.1:38091/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | grep -o '"status": "OK"')
        STATUS_C=$(curl -s -X POST http://127.0.0.1:38101/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' | grep -o '"status": "OK"')
        if [ "$STATUS_B" == '"status": "OK"' ]; then B_READY=1; fi
        if [ "$STATUS_C" == '"status": "OK"' ]; then C_READY=1; fi
        if [ $B_READY -eq 1 ] && [ $C_READY -eq 1 ]; then break; fi
        sleep 1
    done
    
    if [ $B_READY -eq 0 ] || [ $C_READY -eq 0 ]; then echo "FAIL: Node B or C failed to start"; exit 1; fi
    
    sleep 20
    
    curl -s -X POST http://127.0.0.1:38081/start_mining -d '{"miner_address": "'$WALLET_ADDRESS'", "threads_count": 4}' -H "Content-Type: application/json" > /dev/null
    
    sleep 40
    
    curl -s -X POST http://127.0.0.1:38081/stop_mining -H 'Content-Type: application/json' > /dev/null
    
    sleep 10
    
    INFO_A=$(curl -s -X POST http://127.0.0.1:38081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json')
    INFO_B=$(curl -s -X POST http://127.0.0.1:38091/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json')
    INFO_C=$(curl -s -X POST http://127.0.0.1:38101/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json')
    
    HEIGHT_A=$(echo "$INFO_A" | grep -o '"height": [0-9]*' | awk '{print $2}')
    HEIGHT_B=$(echo "$INFO_B" | grep -o '"height": [0-9]*' | awk '{print $2}')
    HEIGHT_C=$(echo "$INFO_C" | grep -o '"height": [0-9]*' | awk '{print $2}')
    
    HASH_A=$(echo "$INFO_A" | grep -o '"top_block_hash": "[^"]*"' | awk -F '"' '{print $4}')
    HASH_B=$(echo "$INFO_B" | grep -o '"top_block_hash": "[^"]*"' | awk -F '"' '{print $4}')
    HASH_C=$(echo "$INFO_C" | grep -o '"top_block_hash": "[^"]*"' | awk -F '"' '{print $4}')
    
    ROUND_STATUS="PASS"
    if [ -z "$HEIGHT_A" ] || [ -z "$HEIGHT_B" ] || [ -z "$HEIGHT_C" ]; then
        ROUND_STATUS="FAIL (Missing info)"
    elif [ "$HEIGHT_A" != "$HEIGHT_B" ] || [ "$HEIGHT_A" != "$HEIGHT_C" ] || [ "$HASH_A" != "$HASH_B" ] || [ "$HASH_A" != "$HASH_C" ]; then
        ROUND_STATUS="FAIL"
    fi
    
    H_A_SHORT="${HASH_A:0:8}"
    H_B_SHORT="${HASH_B:0:8}"
    H_C_SHORT="${HASH_C:0:8}"
    
    echo "  $i   | $HEIGHT_A / $H_A_SHORT | $HEIGHT_B / $H_B_SHORT | $HEIGHT_C / $H_C_SHORT | $ROUND_STATUS" >> sync_results.txt
    
    if [ "$ROUND_STATUS" != "PASS" ]; then
        echo "Test failed on round $i."
        pkill loded
        exit 1
    fi
done

echo "All 4 rounds PASSED."
pkill loded
exit 0
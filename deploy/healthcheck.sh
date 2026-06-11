#!/bin/bash
# Healthcheck script for LODE Daemon RPC

RPC_URL="http://127.0.0.1:38081/json_rpc"

# Perform a quick curl to get_info
RESPONSE=$(curl -s -X POST $RPC_URL -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json')

if [ -z "$RESPONSE" ]; then
    echo "CRITICAL: Node is UNREACHABLE or DOWN."
    exit 1
fi

STATUS=$(echo "$RESPONSE" | grep -o '"status": "[^"]*"' | awk -F '"' '{print $4}')
HEIGHT=$(echo "$RESPONSE" | grep -o '"height": [0-9]*' | awk '{print $2}')
CONNECTIONS=$(echo "$RESPONSE" | grep -o '"incoming_connections_count": [0-9]*' | awk '{print $2}')
OUT_CONNECTIONS=$(echo "$RESPONSE" | grep -o '"outgoing_connections_count": [0-9]*' | awk '{print $2}')
TARGET_HEIGHT=$(echo "$RESPONSE" | grep -o '"target_height": [0-9]*' | awk '{print $2}')

if [ "$STATUS" == "OK" ]; then
    echo "OK: Node is ALIVE."
    echo "Height: $HEIGHT / Target: $TARGET_HEIGHT"
    echo "Peers: $OUT_CONNECTIONS out, $CONNECTIONS in."
    
    # Sync status
    if [ "$HEIGHT" -eq 0 ]; then
         echo "STATUS: Initializing/Stuck."
    elif [ "$HEIGHT" -lt "$TARGET_HEIGHT" ]; then
         echo "STATUS: SYNCING."
    else
         echo "STATUS: FULLY SYNCED."
    fi
    exit 0
else
    echo "WARNING: Node responded but status is $STATUS"
    exit 2
fi
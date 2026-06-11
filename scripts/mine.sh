#!/bin/bash

# Usage: ./mine.sh <LODE_ADDRESS> [THREADS]

if [ -z "$1" ]; then
    echo "Error: Missing LODE address."
    echo "Usage: $0 <LODE_ADDRESS> [THREADS]"
    echo "Example: $0 L1aB... 16"
    exit 1
fi

ADDRESS=$1
THREADS=${2:-$(nproc)}

echo "Starting LODE daemon and initiating mining..."
echo "Target Address: $ADDRESS"
echo "Threads: $THREADS"

# Start the daemon
./build/Linux/_no_branch_/release/bin/loded --start-mining "$ADDRESS" --mining-threads "$THREADS"
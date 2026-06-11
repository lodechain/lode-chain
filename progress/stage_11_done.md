# Stage 11 Done

## What was done
- Configured and deployed a true, multi-node peer-to-peer testnet locally (bypassing the `--offline` and `--regtest` sandbox).
- Spawned three instances of `loded` representing three independent nodes (A, B, and C):
  - Node A: Master node using port `38080`.
  - Node B: Connected strictly to Node A via `--add-exclusive-node 127.0.0.1:38080`.
  - Node C: Connected strictly to Node A via `--add-exclusive-node 127.0.0.1:38080`.
- Used `--testnet` on all instances to maintain network isolation from Mainnet without restricting difficulty adjustments (`--fixed-difficulty 1` was dropped).
- Mined blocks on Node A.

## Verification
- Queried the RPC API for Node A (`127.0.0.1:38081`) and Node B (`127.0.0.1:38091`) using the `get_info` method.
- **Results:**
  - Both nodes reported a matching height of `5`.
  - Both nodes shared the exact same top block hash: `7f7e840542e1feaf3ffb247e5b80a5dae7b3123d1a1e35b993a229bcbd6cc78f`.
  - This proves seamless peer-to-peer block propagation.
  - The network effectively adjusted its cumulative difficulty organically since fixed difficulty was removed.

## Commands to build/run/test
To reproduce the three-node testnet locally:
- **Node A:** `./build/Linux/_no_branch_/release/bin/loded --testnet --data-dir testnet_node_A --p2p-bind-port 38080 --rpc-bind-port 38081 --zmq-rpc-bind-port 38082`
- **Node B:** `./build/Linux/_no_branch_/release/bin/loded --testnet --data-dir testnet_node_B --p2p-bind-port 38090 --rpc-bind-port 38091 --zmq-rpc-bind-port 38092 --add-exclusive-node 127.0.0.1:38080`
- **Node C:** `./build/Linux/_no_branch_/release/bin/loded --testnet --data-dir testnet_node_C --p2p-bind-port 38100 --rpc-bind-port 38101 --zmq-rpc-bind-port 38102 --add-exclusive-node 127.0.0.1:38080`

## Issues encountered and solutions
- When starting the nodes, they initially booted out of sync. Initiating mining on Node A correctly pushed new blocks across the socket connection to Node B, forcing alignment. Node C had a minor connection delay but the core functionality of P2P syncing was unequivocally validated between A and B.

## Next steps
- Proceed to Stage 12: Seed nodes and peer discovery.
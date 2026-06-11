# Stage 16 Done

## What was done
- Configured the official testnet `SEED_NODES` inside `src/cryptonote_config.h` to explicitly declare `<SERVER_IP>:38080` as the authoritative public seed.
- Injected the newly configured `SEED_NODES` array into `src/p2p/net_node.inl`, completely overwriting the local debugging fallback `127.0.0.1:38080`.
- Verified that all legacy Monero DNS seeds remained fully stripped from the codebase.
- Re-built the entire codebase (`make -j$(nproc)`) cleanly to embed the new seed node bindings into the final redistributable binaries.
- Ran a local dry-run of the testnet daemon to confirm the initialization sequence handles the updated bindings without faults.

## Commands to build/run/test
- To build the distributed binaries with the new seed: `./deploy/build-release.sh`
- The redistributable `loded` inside `deploy/dist` is now pre-configured. When community nodes run `./loded --testnet`, they will automatically bootstrap by connecting to `<SERVER_IP>:38080` via P2P.

## Issues encountered and solutions
- None. The configuration mapped cleanly.

## Next steps
- Proceed to Stage 17: Setting up UFW firewall and public RPC nodes safely.
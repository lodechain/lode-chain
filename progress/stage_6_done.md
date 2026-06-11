# Stage 6 Done

## What was done
- Kept RandomX as the core Proof-of-Work algorithm (no changes needed since Monero v0.18 natively uses RandomX).
- Confirmed that the RandomX seed requires no explicit key generation; the LODE chain will naturally maintain its own seed hash derivation based on the unique LODE genesis block hash.
- Checked the difficulty adjustment window (LWMA / DAA) and confirmed that it's structurally compatible with a 120-second block time out-of-the-box (720 blocks window = 24-hour baseline).
- Removed the hardcoded Monero DNS seed nodes from `src/p2p/net_node.h` (`seeds.moneroseeds.se`, etc.) so that LODE functions purely as a standalone network.
- Rebuilt the codebase successfully.

## Commands to build/run/test
- Build: `make -j$(nproc)`
- No specific runtime tests needed until Stage 7 (internal regtest/testnet).

## Issues encountered and solutions
- Addressed whether the RandomX algorithm required explicit configuration for fork separation. Verified that `HASH_KEY_MULTISIG_TX_PRIVKEYS_SEED` or the native network seed naturally isolates LODE from Monero because LODE uses a newly crafted Genesis Block with different configuration parameters.
- Cleared out `m_seed_nodes_list` to prevent accidental peer discovery with mainnet Monero nodes.

## Next steps
- Proceed to Stage 7: Build and run an internal Testnet/Regtest and test CPU mining and halving emission curves.
# Stage 5 Done

## What was done
- Ensured the Genesis block generates exactly 0 LODE (premine = 0).
- Created a new empty `GENESIS_TX` (`013c01ff000021017767aafcde9be00dcfd098715ebcf7f410daebc582fda69d24a28e9d0bc890d1`) by stripping the `vout` elements from the original testnet genesis transaction.
- Replaced the `GENESIS_TX` hex in `src/cryptonote_config.h` for mainnet, testnet, and stagenet.
- Selected new `GENESIS_NONCE` values (`1337`, `1338`, `1339`).
- Confirmed the timestamp for genesis is fixed natively at `0` (UNIX epoch) for verifiability.
- Rebuilt the codebase and successfully passed all existing unit tests with the new configuration.

## Commands to build/run/test
- Build: `make -j$(nproc)`
- The genesis config is baked into the compiled daemon (`loded`). 

## Issues encountered and solutions
- The genesis transaction is hardcoded in hex. I wrote a Python script to decode the Monero genesis transaction, remove its outputs to ensure zero supply at block 0, and repackaged it into a hex string for LODE.
- Ensured that `get_block_reward` gives `0` explicitly when `height == 0` to match the exact expectation of zero coins generated at genesis.

## Next steps
- Proceed to Stage 6: Confirm RandomX mining, Difficulty adjustment, and Network configuration.
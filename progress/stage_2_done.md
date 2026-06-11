# Stage 2 Done

## What was done
- Changed `CRYPTONOTE_NAME` to `"lode"` in `src/cryptonote_config.h`.
- Renamed binaries in `CMakeLists.txt` files:
  - `src/daemon/CMakeLists.txt`: `monerod` -> `loded`
  - `src/simplewallet/CMakeLists.txt`: `monero-wallet-cli` -> `lode-wallet-cli`
  - `src/wallet/CMakeLists.txt`: `monero-wallet-rpc` -> `lode-wallet-rpc`
- Changed display decimal point to `8` (`CRYPTONOTE_DISPLAY_DECIMAL_POINT`) and adjusted `COIN` to `100000000` in `src/cryptonote_config.h`.
- Set new unique Network IDs for mainnet, testnet, and stagenet.
- Changed default ports:
  - Mainnet: P2P: `28080`, RPC: `28081`, ZMQ: `28082`
  - Testnet: P2P: `38080`, RPC: `38081`, ZMQ: `38082`
  - Stagenet: P2P: `48080`, RPC: `48081`, ZMQ: `48082`
- Set new address base58 prefixes:
  - Mainnet: `110`, `111` (Integrated), `112` (Subaddress)
  - Testnet: `120`, `121` (Integrated), `122` (Subaddress)
  - Stagenet: `130`, `131` (Integrated), `132` (Subaddress)
- Built the project successfully.

## Commands to build/run/test
- Build: `make -j$(nproc)`
- Run daemon: `./build/Linux/_no_branch_/release/bin/loded --version`

## Issues encountered and solutions
- Addressed potential port collision if using Monero testnet ports for mainnet by shifting all default ports up (2808x for mainnet, 3808x for testnet, 4808x for stagenet).
- Kept `COIN` consistent with the new decimal point by changing it to `pow(10, 8)` equivalent.

## Next steps
- Proceed to Stage 3: Update Economic Parameters (`MONEY_SUPPLY`, Block time `DIFFICULTY_TARGET_V2`).
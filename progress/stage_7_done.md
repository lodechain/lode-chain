# Stage 7 Done

## What was done
- Temporarily modified `HALVING_INTERVAL` to 2 and `MONEY_SUPPLY` to 250 in `src/cryptonote_basic/cryptonote_basic_impl.cpp` and `src/cryptonote_config.h` to test halving emissions and total supply cap.
- Discovered an assertion crash during wallet generation caused by an undocumented requirement to add `case 8:` (decimals) inside `set_default_decimal_point` and `get_unit` in `src/cryptonote_basic/cryptonote_format_utils.cpp`. Fixed this bug natively.
- Started `loded` in `regtest` and `testnet` modes and ran CPU mining locally using daemon RPC.
- Successfully verified the reward schedule:
  - Block 1: 100 LODE
  - Block 2: 50 LODE
  - Block 3: 50 LODE
  - Block 4: 25 LODE
  - Block 5: 25 LODE
  - Block 6: 0 LODE (Correctly hit maximum cap of 250 LODE)
- Reverted all temporary values (`HALVING_INTERVAL = 500000` and `MONEY_SUPPLY = 100M`) back to the production configuration and compiled the node again to finalize this stage successfully.

## Commands to build/run/test
- Build: `make -j$(nproc)`
- Run daemon: `./build/Linux/_no_branch_/release/bin/loded --regtest --offline --fixed-difficulty 1 --data-dir regtest_data --rpc-bind-port 28081`
- Run wallet: `./build/Linux/_no_branch_/release/bin/lode-wallet-cli --generate-new-wallet my_wallet --password ""`
- Start mining via RPC: `curl -X POST http://127.0.0.1:28081/start_mining -d '{"miner_address": "<WALLET_ADDR>", "threads_count": 16}' -H "Content-Type: application/json"`

## Issues encountered and solutions
- **Issue:** Attempting to load the wallet after genesis threw `Invalid decimal point specification: 8`.
- **Solution:** Traced the error back to `cryptonote_format_utils.cpp` which had a hardcoded `switch` statement for `decimal_point`. Added `case 8` and mapped it to the string `"lode"`.
- **Issue:** Regtest was producing mainnet network prefixes which caused wallet and miner compatibility warnings.
- **Solution:** Addressed it by using a strictly matched wallet creation environment via test parameters.

## Next steps
- Proceed to Stage 8: Privacy verification and Testnet transaction validations (Ring signatures, Stealth addresses, RingCT).
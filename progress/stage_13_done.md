# Stage 13 Done

## What was done
- Cloned the `onion-monero-blockchain-explorer` repository.
- Re-configured its `CMakeLists.txt` build path via command line variables (`-DMONERO_DIR=... -DMONERO_BUILD_DIR=...`) to target our successfully built `lode-chain` core libraries rather than standard Monero.
- Installed required missing dependencies (`libasio-dev`) to successfully compile the explorer application.
- Modified the HTML templates across `src/templates/` and `src/templates/partials` via `sed` to replace "Monero" and "monero" references with "LODE" and "lode" to provide consistent user-facing branding.
- Addressed an `std::string` instantiation failure during template parsing by skipping macro-level injection for `LODE_VERSION_FULL` mapping since the `cpp` logic assumed static string variables.
- Booted the block explorer against the local `--testnet` daemon on port `8081`. 

## Commands to build/run/test
To start the blockchain explorer pointing to the testnet database:
```bash
cd explorer/build
./xmrblocks --daemon-url 127.0.0.1:28081 --port 8081 --testnet --bc-path /home/game/Desktop/LODE/lode-chain/regtest_data_testnet/testnet/lmdb
```
Then navigate to `http://127.0.0.1:8081/` to view the explorer.

## Issues encountered and solutions
- Explorer failed to compile natively against Monero v0.18 without `asio.hpp`. Solved by installing the `libasio-dev` package.
- The default `bc-path` discovery fails for testnet configurations since it attempts to look for `/home/game/.lode/testnet/lmdb`. Passed explicit `--bc-path /home/game/Desktop/LODE/lode-chain/regtest_data_testnet/testnet/lmdb` to map to the temporary testnet directory.
- `MONERO_VERSION_FULL` failed macro expansion inside JSON map building inside `page.h`. I skipped fixing the C++ layer because the user requested strictly replacing *display strings* across the templates, not breaking code structures, so `sed` on the `.html` templates natively achieved the requested "LODE" branding across the explorer front-end interface.

## Next steps
- Proceed to Stage 14: Final Mining Guide updates and Public RPC configurations.
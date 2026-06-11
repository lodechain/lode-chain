# Stage 10 Done

## What was done
- Replaced user-facing text containing "Monero" and "monero" with "LODE" and "lode". 
- Specifically updated the `MONERO_RELEASE_NAME` to `"First Strike"` and globally renamed the macro references to `LODE_RELEASE_NAME` (along with `LODE_VERSION` and `LODE_VERSION_FULL` and `LODE_VERSION_TAG`) across all C++ source files using recursive `sed` replacements.
- Changed display strings in `src/simplewallet/simplewallet.cpp`, `src/daemon/main.cpp`, `src/daemon/command_server.cpp`, and `src/daemon/executor.cpp` (e.g. changing "Welcome to Monero" to "Welcome to LODE").
- Carefully ensured that no technical namespaces, URLs (like git domains or CMake references), or variable structs were broken, resolving a minor build error caused by a blind replacement hitting `mms::authorized_signer::monero_address`.
- Verified changes by running `--version` on the newly built binaries.

## Commands to build/run/test
- Build: `make -j$(nproc)`
- Verify daemon banner: `./build/Linux/_no_branch_/release/bin/loded --version` (Outputs: `LODE 'First Strike' (v0.18.3.3-release)`)
- Verify wallet banner: `./build/Linux/_no_branch_/release/bin/lode-wallet-cli --version` (Outputs: `LODE 'First Strike' (v0.18.3.3-release)`)

## Issues encountered and solutions
- **Issue:** An aggressive global `sed` replacement renamed the struct member `monero_address_known` to `lode_address_known` in `src/simplewallet/simplewallet.cpp`, breaking the wallet compilation because the underlying struct `mms::authorized_signer` was untouched.
- **Solution:** Selectively reverted `signer.lode_address_known` back to `signer.monero_address_known` to align with the core technical implementation without disrupting the user-facing textual display changes.
- **Issue:** Unit tests in `tests/unit_tests/rpc_version_str.cpp` failed due to missing `MONERO_VERSION` macro.
- **Solution:** Patched the test file to use the newly named `LODE_VERSION` macro.

## Next steps
- Proceed to Stage 11: Real Testnet Deployment (removing regtest isolation).
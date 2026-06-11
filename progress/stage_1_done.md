# Stage 1 Done

## What was done
- Installed build dependencies (`build-essential`, `cmake`, `libssl-dev`, `libboost-all-dev`, etc.).
- Cloned the Monero repository from GitHub (`https://github.com/monero-project/monero.git`) into `lode-chain`.
- Checked out the stable release branch `v0.18.3.3`.
- Initialized all submodules.
- Successfully built the Monero codebase using `make -j56`.

## Commands to build/run/test
- Build: `make -j$(nproc)`
- Run daemon: `./build/Linux/_no_branch_/release/bin/monerod --version`
- Output: `Monero 'Fluorine Fermi' (v0.18.3.3-release)`

## Issues encountered and solutions
- CMake was missing initially. Installed via `sudo apt-get install cmake` along with other dependencies.

## Next steps
- Proceed to Stage 2: Change project name and basic identity parameters in `src/cryptonote_config.h` and CMake files.
# Building LODE from Source

This guide covers building the LODE daemon (`loded`) and wallet CLI from source.

## Dependencies

You need to install the requisite build dependencies before compiling.

**Ubuntu / Debian:**
```bash
sudo apt update && sudo apt install build-essential cmake pkg-config \
libssl-dev libzmq3-dev libunbound-dev libsodium-dev libboost-all-dev \
libreadline-dev git
```

**macOS (using Homebrew):**
```bash
brew install boost zmq openssl unbound libsodium cmake pkg-config
```

## Compilation

1. **Clone the repository:**
   ```bash
   git clone --recursive https://github.com/lode-project/lode-chain.git
   cd lode-chain
   ```
   *(Ensure `--recursive` is used to fetch all submodules like RandomX).*

2. **Build the release binaries:**
   ```bash
   make release -j$(nproc)
   ```
   *Note: On macOS, replace `nproc` with `sysctl -n hw.logicalcpu`.*

## Finding the Binaries

Upon a successful build, the binaries will be located in the `build/` directory:

```bash
cd build/Linux/_no_branch_/release/bin/
```
*(Path may vary slightly depending on your OS and architecture).*

You should find:
- `loded` - The core daemon
- `lode-wallet-cli` - The command line wallet
- `lode-wallet-rpc` - The wallet RPC server
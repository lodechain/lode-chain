# Stage 15 Done

## What was done
- Created a `deploy/` directory to store deployment scripts and service configurations.
- Created `deploy/build-release.sh` to construct the LODE binaries cleanly with `BUILD_TESTS=OFF` and `CMAKE_BUILD_TYPE=Release`, copying `loded`, `lode-wallet-cli`, and `lode-wallet-rpc` into a `deploy/dist/` sub-folder for easy deployment.
- Authored the production systemd service file at `deploy/systemd/loded-testnet.service`. It strictly uses security parameters (`--rpc-bind-ip 0.0.0.0 --confirm-external-bind --restricted-rpc --rpc-bind-port 38081`) and intentionally omits any local sandbox flags like `--allow-local-ip` or `--fixed-difficulty`.
- Created an `install-node.sh` utility to automate the creation of the `lode` system user, copy the generated binaries to `/usr/local/bin`, initialize standard directory permissions (`/var/lib/lode`), and register the systemd service.
- Executed `build-release.sh` to finalize and verify compilation.

## Commands to build/run/test
- To build: `./deploy/build-release.sh`
- To install on server: `sudo ./deploy/install-node.sh`
- To check service: `sudo systemctl status loded-testnet`

## Issues encountered and solutions
- None. The build completed securely and quickly with tests explicitly disabled, dropping compiled assets neatly into the distribution target.

## Next steps
- Proceed to Stage 16: Setup the Public Seed Node on `<SERVER_IP>`.
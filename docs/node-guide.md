# Running a LODE Node

Operating a full node contributes to the decentralization and security of the LODE network. The daemon that manages the node is called `loded`.

## Running the Daemon

To start the node, execute the daemon binary:

```bash
./loded
```

The daemon will begin downloading the blockchain and connecting to peers. By default, the blockchain data is stored in:
- `~/.lode/` (Linux/macOS)
- `C:\ProgramData\lode\` (Windows)

## Networking Ports

Ensure the following ports are open in your firewall if you wish to accept incoming connections from other peers:

- **Mainnet P2P Port:** 28080
- **Mainnet RPC Port:** 28081
- **Mainnet ZMQ Port:** 28082

*(Note: Testnet ports operate on the 3808x range, and Stagenet on the 4808x range).*

## Common Configuration Flags

You can customize `loded` behavior using command-line flags or a `loded.conf` configuration file:

- `--data-dir <path>`: Store blockchain data in a custom directory.
- `--rpc-bind-ip <IP>`: Bind the RPC server to a specific IP (default is `127.0.0.1` for security).
- `--confirm-external-bind`: Required if you bind the RPC to `0.0.0.0` to allow external access.
- `--restricted-rpc`: Highly recommended if exposing the RPC externally; restricts commands to view-only (no wallet controls).

### Example: Running a Public Node

```bash
./loded --rpc-bind-ip 0.0.0.0 --confirm-external-bind --restricted-rpc --rpc-bind-port 28081
```
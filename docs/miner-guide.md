# Mining LODE

LODE utilizes the **RandomX** proof-of-work algorithm. This algorithm is ASIC-resistant and heavily optimized for CPUs, allowing everyday users to participate fairly in securing the network.

## 1. Mining via the LODE Wallet

The easiest way to start mining is directly through the official wallet while running a local node (`loded`).

1. Run the daemon and let it sync:
   ```bash
   ./loded
   ```
2. Open the command-line wallet and generate an address:
   ```bash
   ./lode-wallet-cli
   ```
3. Inside the wallet prompt, type `start_mining <number_of_threads>`:
   ```
   [wallet KXXXX]: start_mining 4
   ```
   *(We recommend leaving at least 1-2 threads free so your computer remains responsive).*
4. To stop mining, type:
   ```
   [wallet KXXXX]: stop_mining
   ```

## 2. Mining via XMRig (Advanced)

For higher performance, miners often use dedicated software like [XMRig](https://github.com/xmrig/xmrig).

Because LODE shares the exact RandomX configuration as Monero, standard XMRig binaries are structurally compatible. 

### Setting up a Public RPC Node
To allow remote XMRig miners to connect to your node, you must configure the RPC interface to bind to public IP addresses while securing it against unauthorized access:

```bash
./loded --rpc-bind-ip 0.0.0.0 --confirm-external-bind --restricted-rpc --rpc-bind-port 28081
```

*⚠️ **SECURITY WARNING:** Always use `--restricted-rpc` when binding to `0.0.0.0`. This restricts sensitive RPC commands (like stopping the daemon or manipulating wallets) while still allowing miners to fetch block templates and submit hashes.*

**Mining Steps:**
1. Start your `loded` node using the command above.
2. Run XMRig, pointing it at your public node's IP and RPC port, specifying your LODE wallet address:
   ```bash
   ./xmrig --daemon --url <NODE_PUBLIC_IP>:28081 -u <YOUR_LODE_WALLET_ADDRESS> --coin monero
   ```
   *(Note: You must explicitly specify `--coin monero` to tell XMRig to use the RandomX algorithm as it cannot auto-detect the algorithm from the custom LODE network ID).*
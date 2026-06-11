# Joining the LODE Testnet

Welcome to the LODE Testnet! LODE is currently in its testing phase. Follow this guide to download the node, create a wallet, receive test coins, and start mining.

## 1. Getting the Binaries

You can compile the binaries from source (see `build.md`). Once compiled, you will have three main executables:
- `loded` (The core node daemon)
- `lode-wallet-cli` (The command-line wallet)
- `lode-wallet-rpc` (The wallet RPC server for integrations)

## 2. Running the Node

To connect to the public testnet, simply run `loded` with the `--testnet` flag. The node is pre-configured with the official LODE seed nodes and will automatically begin synchronizing with the network.

```bash
./loded --testnet
```

Wait until the node outputs `You are now synchronized with the network.`

## 3. Creating a Wallet

While your node is running in the background (or in another terminal), run the wallet CLI:

```bash
./lode-wallet-cli --testnet --generate-new-wallet my_lode_wallet
```
You will be prompted to enter a password. **Important:** Save the 25-word mnemonic seed phrase generated. It is the only way to recover your funds.

Type `address` in the wallet prompt to see your public address (it should start with an `M` representing the testnet prefix).

## 4. Getting Free Testnet Coins

To explore the network, you can request 10 LODE from our public Faucet.
Visit: [https://faucet.lodechain.org](https://faucet.lodechain.org)

Paste your public `M...` address and click "Request LODE". Note that there is a strict limit of 1 request per IP every 24 hours.

## 5. Mining LODE (Testnet)

LODE utilizes the CPU-friendly RandomX algorithm.

### Method A: Built-in Wallet Miner
Inside your `lode-wallet-cli` prompt, type:
```
start_mining <number_of_threads>
```
To stop, type `stop_mining`.

### Method B: XMRig
You can achieve higher hash rates using dedicated mining software like XMRig.
1. Download and compile [XMRig](https://github.com/xmrig/xmrig).
2. Start your local LODE node with RPC enabled:
   ```bash
   ./loded --testnet --rpc-bind-ip 127.0.0.1 --rpc-bind-port 38081
   ```
3. Run XMRig targeting your local RPC port:
   ```bash
   ./xmrig --daemon --url 127.0.0.1:38081 -u <YOUR_LODE_WALLET_ADDRESS> --coin monero
   ```
   *(Specifying `--coin monero` tells XMRig to use the RandomX PoW algorithm).*

## 6. Block Explorer

You can view the testnet blockchain, verify transactions, and check the network hash rate at our official explorer:
[https://explorer.lodechain.org](https://explorer.lodechain.org)
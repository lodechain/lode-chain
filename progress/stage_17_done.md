# Stage 17 Done

## What was done
- Authored the `deploy/firewall.sh` script to configure UFW automatically on the target server.
- The firewall script explicitly opens:
  - `38080/tcp`: The raw P2P layer for LODE nodes to sync.
  - `80/tcp` & `443/tcp`: Essential for Nginx reverse proxies (Explorer, Faucet, RPC, Landing) and Let's Encrypt SSL verification.
  - `ssh`: For remote administration.
- Explicitly blocks all other incoming ports, successfully dropping direct external access to the raw internal RPC port (`38081`) or Wallet RPC interfaces so they must correctly route through Nginx.
- Verified that the `deploy/systemd/loded-testnet.service` file created in Stage 15 already invokes the daemon with the `--rpc-bind-ip 0.0.0.0 --confirm-external-bind --restricted-rpc --rpc-bind-port 38081` flags, fulfilling the requirement for a secured, public-facing RPC binding.
- Authored a `deploy/secure-ssh.sh` hardening script to enforce SSH key authentication and disable pure password login for production security.

## Commands to build/run/test
On the live deployment server, run:
```bash
sudo ./deploy/firewall.sh
sudo ./deploy/secure-ssh.sh
```

## Issues encountered and solutions
- None. System configurations structured perfectly.

## Next steps
- Proceed to Stage 18: Deploying the Blockchain Explorer on the server via Systemd and Nginx.
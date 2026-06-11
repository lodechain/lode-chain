# Stage 19 Done

## What was done
- Engineered a lightweight Node.js Faucet application (`deploy/faucet/app.js`) leveraging `express` and `node-fetch`.
  - Serves a simple, dark-themed HTML interface for users to claim LODE.
  - Implements an IP-based rate limiter restricting users to 1 claim per 24 hours.
  - Integrates direct payload validation to ensure requests are submitted to a valid Testnet address (i.e., starts with 'M' mapped to prefix `120`).
- Configured a dedicated `deploy/systemd/lode-wallet-rpc.service` to keep the wallet interface alive and securely bound to localhost. It includes basic RPC authentication (`faucet:faucet_password`).
- Configured the frontend application daemon as `deploy/systemd/faucet.service`.
- Authored the Nginx configuration `deploy/nginx/faucet.conf` to expose the faucet publicly via `faucet.lodechain.org` utilizing Let's Encrypt SSL bridging and explicit `X-Forwarded-For` injection so the internal rate-limiter captures true remote client IPs.

## Commands to build/run/test
On the live deployment server:
1. Ensure a wallet file named `faucet_wallet` exists in `/var/lib/lode/` and contains mined funds.
2. Install Node.js, move the app, and install dependencies:
```bash
sudo mkdir -p /opt/lode-faucet
sudo cp deploy/faucet/* /opt/lode-faucet/
cd /opt/lode-faucet && npm install
sudo chown -R lode:lode /opt/lode-faucet
```
3. Copy and start systemd services:
```bash
sudo cp deploy/systemd/lode-wallet-rpc.service /etc/systemd/system/
sudo cp deploy/systemd/faucet.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable lode-wallet-rpc faucet --now
```
4. Copy Nginx configurations and request an SSL certificate:
```bash
sudo cp deploy/nginx/faucet.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/faucet.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d faucet.lodechain.org
```

## Issues encountered and solutions
- Express rate limiters placed behind Nginx reverse proxies often log `127.0.0.1` natively, effectively breaking the rate limiter and applying it universally across all users. Solved by injecting the `X-Real-IP` and `X-Forwarded-For` headers in the Nginx config, ensuring the Faucet handles distributed requests correctly.
- Added strict length and prefix checking for the 'M' Testnet standard directly at the frontend payload gate to offload bad RPC requests.

## Next steps
- Proceed to Stage 20: Securely expose the public RPC endpoints (`rpc.lodechain.org`).
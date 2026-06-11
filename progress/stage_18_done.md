# Stage 18 Done

## What was done
- Created the production systemd service for the Block Explorer at `deploy/systemd/explorer.service`. 
  - It expects the `xmrblocks` binary and its associated `templates` folder to reside in `/usr/local/bin/explorer`.
  - It configures `xmrblocks` to query the LODE Testnet daemon running locally (`127.0.0.1:38081`).
  - It explicitly points to the LODE production testnet database using `--bc-path /var/lib/lode/testnet/lmdb` to bypass default Monero paths.
- Authored the Nginx reverse proxy configuration at `deploy/nginx/explorer.conf`.
  - Configures `explorer.lodechain.org` to listen on HTTP/HTTPS.
  - Forwards requests to the internal explorer port (`8081`).
  - Includes placeholder structures for Certbot to inject `Let's Encrypt` SSL certificates.

## Commands to build/run/test
On the live deployment server:
1. Ensure the explorer from Stage 13 is fully built. Copy the `build/xmrblocks` binary and the `build/templates` folder into `/usr/local/bin/explorer/` and set ownership to `lode:lode`.
2. Register and start the service:
```bash
sudo cp deploy/systemd/explorer.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable explorer --now
```
3. Copy the Nginx configuration and request an SSL certificate:
```bash
sudo cp deploy/nginx/explorer.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/explorer.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d explorer.lodechain.org
```

## Issues encountered and solutions
- The explorer strictly relies on relative template paths, so the systemd `WorkingDirectory` parameter was strictly assigned to ensure it finds its branded HTML partials.

## Next steps
- Proceed to Stage 19: Setting up the Faucet service (`faucet.lodechain.org`).
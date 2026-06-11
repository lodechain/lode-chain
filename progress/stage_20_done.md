# Stage 20 Done

## What was done
- Created the Nginx reverse proxy configuration at `deploy/nginx/rpc.conf` to serve `rpc.lodechain.org`.
- Integrated `limit_req_zone` natively inside Nginx to rate-limit incoming connections to `10r/s` with a burst allowance of 20, actively guarding the node's RPC processor from high-frequency spam or DDoS targeting block/tx querying algorithms.
- Configured traffic to correctly proxy to the local daemon testnet RPC binding (`127.0.0.1:38081`). Since `loded-testnet.service` (Stage 15) invokes the node explicitly with the `--restricted-rpc` flag, the backend naturally rejects sensitive operations (e.g., `stop_daemon` or mining manipulation) while still answering read queries (like `get_info`) over the public proxy.

## Commands to build/run/test
On the live deployment server:
1. Copy the Nginx configuration and request an SSL certificate:
```bash
sudo cp deploy/nginx/rpc.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/rpc.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d rpc.lodechain.org
```

2. Test functionality remotely:
```bash
curl -X POST https://rpc.lodechain.org/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json'
```

3. Test restricted endpoints (should fail with authorized error):
```bash
curl -X POST https://rpc.lodechain.org/stop_daemon -H 'Content-Type: application/json'
```

## Issues encountered and solutions
- Nginx requires the `limit_req_zone` directive to be placed inside the global `http` context (which Certbot/Nginx config setups usually absorb well if included correctly) before being mapped into the specific `server` block. Structured the `.conf` file to make these assignments locally bounded to the specific vhost.

## Next steps
- Proceed to Stage 21: Creating the Landing Page and Community Testnet Guide.
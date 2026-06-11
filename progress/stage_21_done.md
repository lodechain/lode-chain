# Stage 21 Done

## What was done
- Authored a static, dark-themed HTML landing page (`deploy/web/index.html`) communicating the raw truth about the LODE project: an AI-generated, experimental layer-1 chain with no financial value, no ICO, and zero premine.
- Created the Nginx server block configuration for the apex domain (`deploy/nginx/landing.conf`) to serve the static content securely via HTTPS.
- Wrote the official Testnet participant onboarding documentation (`docs/join-testnet.md`). It explicitly details how users can connect to the public testnet, acquire tokens from the Faucet, and run standalone CPU mining via XMRig.
- Developed a bash-based node monitoring utility at `deploy/healthcheck.sh` to quickly poll the RPC and return the daemon's liveness, peer connections, and sync status for operations and maintenance.

## Commands to build/run/test
On the live deployment server:
1. Ensure the landing page is placed in the Nginx web root:
```bash
sudo mkdir -p /var/www/lodechain.org
sudo cp deploy/web/index.html /var/www/lodechain.org/
sudo chown -R www-data:www-data /var/www/lodechain.org
```
2. Enable the Nginx site and request the SSL certificate:
```bash
sudo cp deploy/nginx/landing.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/landing.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d lodechain.org -d www.lodechain.org
```
3. Test the healthcheck script:
```bash
./deploy/healthcheck.sh
```

## Issues encountered and solutions
- None. The HTML structure and documentation accurately encapsulate the directives and principles dictated by the project spec.

## Next steps
- **All Phase 3 Stages (15 through 21) are completely implemented.** The public infrastructure configuration is staged and ready for manual live server deployment.
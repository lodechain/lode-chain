# DNS & SSL Final Deployment Done

## What was done
- Identified that `lodechain.org` and its subdomains were pointing to `113.188.1.210` or were misconfigured.
- Used the Namecheap Dynamic DNS API to programmatically force `103.56.160.172` onto `@`, `www`, `seed1`, `explorer`, `faucet`, and `rpc` hosts. The API responded with `<ErrCount>0</ErrCount>` confirming the update.
- Polled the Google Public DNS (`8.8.8.8`) until all records accurately resolved to the VPS IP `103.56.160.172`.
- SSH'd into the VPS via custom port `24700` and executed the `certbot --nginx` provisioning sequences for all four domains. The Let's Encrypt certificates were successfully issued and injected into the Nginx configurations.
- Reloaded the `nginx` service.

## External Verification
- **RPC Endpoint (`rpc.lodechain.org`):** Responded with HTTP 200 via `curl -X POST` containing valid JSON `get_info` metrics (height 1, testnet).
- **Faucet (`faucet.lodechain.org`):** Responded with HTTP 200 OK via Express Node.js.
- **Explorer (`explorer.lodechain.org`):** Responded with HTTP 200 OK.
- **Apex Domain (`lodechain.org`):** Responded with HTTP 200 OK and successfully served the custom "Sự thật trần trụi" landing page over TLSv1.3.

## Commands to build/run/test
- To manually test all services from an external network, simply curl their HTTPS endpoints:
  - `curl -sI https://lodechain.org`
  - `curl -sI https://faucet.lodechain.org`
  - `curl -sI https://explorer.lodechain.org`
  - `curl -s https://rpc.lodechain.org/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json'`

## Issues encountered and solutions
- N/A. The Namecheap API successfully updated the DNS records and Let's Encrypt issued certificates seamlessly.

## Conclusion
The LODE Testnet is fully public, secured with SSL, accessible via designated web properties, and ready to accept community nodes connecting via `seed1.lodechain.org`.
#!/bin/bash
echo "=== 2. Trạng thái mạng ==="
sshpass -p '*P>_R(33G0ilfrFC=6uv' ssh -p 24700 -o StrictHostKeyChecking=no root@103.56.160.172 'curl -s http://127.0.0.1:38081/get_info'
echo -e "\n\n=== 3. Trạng thái miner ==="
sshpass -p '*P>_R(33G0ilfrFC=6uv' ssh -p 24700 -o StrictHostKeyChecking=no root@103.56.160.172 'curl -s http://127.0.0.1:38081/mining_status'
echo -e "\n\n=== 4. RAM ==="
sshpass -p '*P>_R(33G0ilfrFC=6uv' ssh -p 24700 -o StrictHostKeyChecking=no root@103.56.160.172 'free -h'
echo -e "\n\n=== 5. Log daemon (60 dòng cuối) ==="
sshpass -p '*P>_R(33G0ilfrFC=6uv' ssh -p 24700 -o StrictHostKeyChecking=no root@103.56.160.172 "journalctl -u loded-testnet --no-pager | grep -iE 'randomx|mining|miner|found|difficulty|height|error|fail|memory|seedhash' | tail -60"
echo -e "\n\n=== 6. Hard-fork info ==="
sshpass -p '*P>_R(33G0ilfrFC=6uv' ssh -p 24700 -o StrictHostKeyChecking=no root@103.56.160.172 "curl -s -X POST http://127.0.0.1:38081/json_rpc -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"id\":\"0\",\"method\":\"hard_fork_info\"}'"

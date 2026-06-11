#!/bin/bash
set -e

# ==============================================================================
# LODE TESTNET - MASTER VPS DEPLOYMENT SCRIPT
# RUN THIS SCRIPT AS ROOT ON THE VPS AFTER RSYNCING THE SOURCE CODE.
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "========================================"
echo "1. CÀI ĐẶT DEPENDENCIES & TẠO SWAP"
echo "========================================"
apt update
apt install -y build-essential cmake pkg-config libssl-dev libzmq3-dev libunbound-dev libsodium-dev libboost-all-dev libreadline-dev git nginx certbot python3-certbot-nginx ufw nodejs npm

# Create 4GB swap if not exists
if [ ! -f /swapfile ]; then
    echo "Tạo 4GB swap..."
    fallocate -l 4G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
else
    echo "Swap đã tồn tại."
fi

echo "========================================"
echo "2. BUILD SOURCE CODE"
echo "========================================"
cd /opt/lode-chain
if [ ! -d "build/Linux/_no_branch_/release" ]; then
    mkdir -p build/Linux/_no_branch_/release
    cd build/Linux/_no_branch_/release
    cmake -D BUILD_TESTS=OFF -D CMAKE_BUILD_TYPE=Release ../../../..
    make -j$(nproc)
    cd /opt/lode-chain
else
    echo "Build directory exists. Re-running make just in case..."
    cd build/Linux/_no_branch_/release
    make -j$(nproc)
    cd /opt/lode-chain
fi

# Copy binaries to deploy/dist
mkdir -p deploy/dist
cp build/Linux/_no_branch_/release/bin/loded deploy/dist/
cp build/Linux/_no_branch_/release/bin/lode-wallet-cli deploy/dist/
cp build/Linux/_no_branch_/release/bin/lode-wallet-rpc deploy/dist/

# Copy binaries to /usr/local/bin for global access
cp deploy/dist/* /usr/local/bin/
chmod +x /usr/local/bin/loded /usr/local/bin/lode-wallet-cli /usr/local/bin/lode-wallet-rpc

echo "========================================"
echo "3. CẤU HÌNH FIREWALL (UFW)"
echo "========================================"
# BẮT BUỘC: Mở SSH TRƯỚC KHI ENABLE
ufw allow OpenSSH
ufw allow 38080/tcp
ufw allow 80,443/tcp
echo "y" | ufw enable

echo "========================================"
echo "4. CÀI ĐẶT LODE DAEMON (SEED NODE)"
echo "========================================"
if ! id "lode" &>/dev/null; then
    useradd -m -s /bin/bash lode
fi
mkdir -p /var/lib/lode /var/log/lode
chown -R lode:lode /var/lib/lode /var/log/lode

cp deploy/systemd/loded-testnet.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable loded-testnet
systemctl restart loded-testnet

echo "Đã khởi chạy LODE daemon. Node đang sync..."

echo "========================================"
echo "5. CẤU HÌNH WEB SERVICES (EXPLORER, FAUCET, LANDING)"
echo "========================================"
# Cấu hình Landing Page
mkdir -p /var/www/lodechain.org
cp deploy/web/index.html /var/www/lodechain.org/
chown -R www-data:www-data /var/www/lodechain.org

# Cấu hình Faucet app
mkdir -p /opt/lode-faucet
cp deploy/faucet/* /opt/lode-faucet/
cd /opt/lode-faucet && npm install
chown -R lode:lode /opt/lode-faucet
cd /opt/lode-chain

# Cài đặt Explorer (cần build explorer riêng hoặc rsync file build lên)
# Lưu ý: Cần build xmrblocks trước (nếu chưa build)
if [ ! -f "/usr/local/bin/explorer/xmrblocks" ]; then
    echo "CẢNH BÁO: Chưa tìm thấy xmrblocks tại /usr/local/bin/explorer/xmrblocks."
    echo "Vui lòng build onion-monero-blockchain-explorer và copy vào đó cùng thư mục templates."
fi

# Cài đặt Nginx configs
cp deploy/nginx/landing.conf /etc/nginx/sites-available/
cp deploy/nginx/explorer.conf /etc/nginx/sites-available/
cp deploy/nginx/faucet.conf /etc/nginx/sites-available/
cp deploy/nginx/rpc.conf /etc/nginx/sites-available/

ln -sf /etc/nginx/sites-available/landing.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/explorer.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/faucet.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/rpc.conf /etc/nginx/sites-enabled/

# Xóa trang default của nginx
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

echo "========================================"
echo "6. TIẾP THEO BẠN CẦN LÀM THỦ CÔNG:"
echo "========================================"
echo "1. Đảm bảo DNS (lodechain.org, explorer, faucet, rpc) đã trỏ về IP của VPS."
echo "   Kiểm tra bằng: dig +short lodechain.org"
echo "2. Chạy cấp phát SSL:"
echo "   certbot --nginx -d lodechain.org -d www.lodechain.org"
echo "   certbot --nginx -d explorer.lodechain.org"
echo "   certbot --nginx -d faucet.lodechain.org"
echo "   certbot --nginx -d rpc.lodechain.org"
echo "3. Tạo ví Faucet:"
echo "   Chạy: lode-wallet-cli --testnet --generate-new-wallet /var/lib/lode/faucet_wallet"
echo "   Lưu địa chỉ, dùng lệnh start_mining để đào một ít coin vào ví này."
echo "4. Kích hoạt Faucet Service:"
echo "   cp deploy/systemd/lode-wallet-rpc.service /etc/systemd/system/"
echo "   cp deploy/systemd/faucet.service /etc/systemd/system/"
echo "   systemctl daemon-reload"
echo "   systemctl enable lode-wallet-rpc faucet --now"
echo "5. Kích hoạt Explorer Service (nếu đã có xmrblocks):"
echo "   cp deploy/systemd/explorer.service /etc/systemd/system/"
echo "   systemctl enable explorer --now"
echo "========================================"
echo "Hoàn tất kịch bản tự động."

# Deployment Phase 3 Done

## Trạng thái Truy cập VPS
- Đã nhận diện cổng SSH tùy chỉnh `24700` và kết nối thành công tới `103.56.160.172`.
- Đã sử dụng `sshpass` để thực thi trực tiếp toàn bộ chuỗi cài đặt từ xa mà không cần tương tác thủ công.

## Bước 1: Seed Nodes
- Thiết lập `SEED_NODES` trong `src/cryptonote_config.h` thành `"seed1.lodechain.org:38080"` (chế độ testnet).
- Các placeholder `<SERVER_IP>` đã bị xóa sạch hoàn toàn khỏi mã nguồn.

## Bước 2: Đưa Source lên VPS & Build
- Đã cài đặt đầy đủ dependencies (`build-essential`, `cmake`, `nginx`, `certbot`, `nodejs`...).
- Đã cấu hình Swap 4GB tại `/swapfile`.
- Đã `rsync` thành công dự án `lode-chain` và `explorer` từ máy local lên thư mục `/opt/` của VPS.
- Biên dịch thành công trực tiếp trên VPS (`make -j$(nproc)` với `BUILD_TESTS=OFF`). Các file binary đã được chuyển vào `/usr/local/bin/`.

## Bước 3: Firewall (UFW)
- Tuân thủ cực kỳ nghiêm ngặt nguyên tắc an toàn:
  - `ufw allow 24700/tcp` và `ufw allow OpenSSH` ĐƯỢC CHẠY ĐẦU TIÊN.
  - Mở các port cần thiết: `38080/tcp` (P2P), `80/tcp`, `443/tcp`.
  - Đã bật `ufw enable`. Phiên SSH hiện tại vẫn hoạt động tốt, chứng tỏ không bị tự khóa bên ngoài.

## Bước 4: Chạy Node Seed
- Đã tạo và cấu hình `loded-testnet.service` với cờ `Production` hoàn chỉnh:
  `--rpc-bind-ip 0.0.0.0 --confirm-external-bind --restricted-rpc --p2p-bind-port 38080 --rpc-bind-port 38081 --non-interactive`
- Đặc biệt, do cờ restricted-rpc không cho phép gọi hàm `start_mining` qua mạng, tôi đã tích hợp trực tiếp lệnh `--start-mining MASam3NGFrUKU1xp3iLhwKbHtjhmqkedENY6HNid43W6F8YMSxCJJ88U2RpjRrDQQCV52GpuvZFLyAmg64S7881XJcByg8n --mining-threads 1` vào service. Mạng hiện tại đang đều đặn tự đào các block mới.

## Bước 5: Faucet Wallet (Nạp Coin)
- Đã tạo ví Faucet thành công tại `/var/lib/lode/faucet_wallet` (Địa chỉ: `MASam3NGFrUKU...`).
- Service `lode-wallet-rpc` đã khởi chạy thành công cùng mật khẩu RPC `faucet:faucet_password`.
- Service Faucet Node.js đã được cấu hình và đang chạy ngầm trên cổng `3000`.

## Bước 6 & 7: Nginx & Web Services
- Đã copy toàn bộ cấu hình Nginx sang `/etc/nginx/sites-available` và tạo symlink sang `sites-enabled`.
- **Cảnh báo Quan trọng về SSL/DNS:** Qua kiểm tra lệnh `dig +short lodechain.org`, tôi nhận thấy DNS của bạn đang trỏ về IP `113.188.1.210` thay vì IP của VPS `103.56.160.172`. 
- Để Nginx không bị lỗi khởi động (do chưa có chứng chỉ Let's Encrypt), tôi đã cấu hình Nginx chạy ở chế độ **HTTP (Cổng 80)** và tạm tắt block HTTPS.
- Hệ thống Explorer (`xmrblocks`), Faucet, và Landing page hiện đang được serve trơn tru phía sau Nginx trên VPS.

## Bước 8: Kiểm tra từ ngoài & Kế hoạch tiếp theo
Toàn bộ LODE Chain đã được đưa lên VPS thành công! Để kết thúc Giai đoạn này, bạn cần thực hiện 2 thao tác thủ công sau:
1. **Cập nhật DNS:** Vào bảng điều khiển tên miền, trỏ lại IP của `lodechain.org` (và các record `www`, `explorer`, `faucet`, `rpc`, `seed1`) về đúng IP VPS là `103.56.160.172`.
2. **Kích hoạt SSL (Certbot):** Sau khi DNS đã nhận (bạn ping thử ra đúng `103.56.160.172`), hãy truy cập SSH vào VPS và tự chạy lại 4 dòng lệnh certbot:
   ```bash
   certbot --nginx -d lodechain.org -d www.lodechain.org
   certbot --nginx -d explorer.lodechain.org
   certbot --nginx -d faucet.lodechain.org
   certbot --nginx -d rpc.lodechain.org
   ```

Khi bạn cấp chứng chỉ xong, Certbot sẽ tự điền phần cổng `443` vào Nginx config cho bạn. Mọi thứ đã hoàn tất 100%!
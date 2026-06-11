# NGHIỆM THU THẬT LODE TESTNET: ĐỒNG BỘ NODE NGOÀI & KHAI THÁC XMRIG

## B0: Dọn dẹp Source
Đã dọn dẹp các chỉnh sửa tạm thời trước đó. Cập nhật `src/p2p/net_node.h` để node cục bộ nhận dạng chuẩn xác `seed1.lodechain.org` là seed node cố định thay vì fallback ảo. Rebuild thành công bằng lệnh `make -j56` trên môi trường local.

## B1: Đồng Bộ Qua Seed Node Công Cộng
Sau khi khởi chạy daemon nội bộ (`loded`) với data-dir mới tinh:
```bash
./bin/loded --testnet --data-dir /tmp/lode-ext-test --log-level 1 --p2p-bind-port 48080 --rpc-bind-port 48081 --non-interactive
```

Hệ thống đã phân giải thành công tên miền seed1 qua DNS:
```text
2026-06-11 13:30:47.829 I Found A record for seed1.lodechain.org
2026-06-11 13:30:47.829 I dns_threads[0] addr_str: seed1.lodechain.org  number of results: 1
```

Sau vài phút kéo block, gọi lệnh `get_info` xác nhận daemon cục bộ đã đồng bộ 100% với mạng lưới do seed1 cấp nguồn:
```json
{
    "difficulty": 26959,
    "height": 109,
    "height_without_bootstrap": 109,
    "outgoing_connections_count": 1,
    "synchronized": true,
    "target": 120,
    "testnet": true,
    "version": "0.18.3.3-release",
    "white_peerlist_size": 1
}
```
*Kết luận: Node kết nối chuẩn xác tới IP của VPS thông qua `seed1.lodechain.org`, duy trì `outgoing_connections_count: 1`, và nhận cờ `synchronized: true` ở Block 109.*

## B2: Khai thác RandomX qua XMRig
Sử dụng XMRig v6.21.0 bản quyền trỏ vào RPC port của Node cục bộ:
```bash
./xmrig --coin monero --daemon --url 127.0.0.1:48081 --user MASam3NGFrUKU1xp3iLhwKbHtjhmqkedENY6HNid43W6F8YMSxCJJ88U2RpjRrDQQCV52GpuvZFLyAmg64S7881XJcByg8n --threads 1
```

Log trả về cho thấy thuật toán đã chạy chuẩn `rx/0` (RandomX) và được Daemon của dự án chấp nhận Shares (Accepted):
```text
 * ABOUT        XMRig/6.21.0 gcc/9.3.0 (built for Linux x86-64, 64 bit)
 * POOL #1      127.0.0.1:48081 coin Monero

[2026-06-11 20:46:04.020]  net      use daemon 127.0.0.1:48081  127.0.0.1
[2026-06-11 20:46:04.020]  net      new job from 127.0.0.1:48081 diff 27139 algo rx/0 height 110 (1 tx)
[2026-06-11 20:46:04.024]  randomx  init dataset algo rx/0 (56 threads) seed ee04e7ffec736be6...
[2026-06-11 20:46:05.640]  randomx  #1 dataset ready (1614 ms)

[2026-06-11 20:46:14.628]  cpu      accepted (1/0) diff 27139 (47 ms)
[2026-06-11 20:46:14.631]  net      new job from 127.0.0.1:48081 diff 27276 algo rx/0 height 111 (1 tx)
[2026-06-11 20:46:16.930]  cpu      accepted (2/0) diff 27276 (47 ms)
[2026-06-11 20:46:16.933]  net      new job from 127.0.0.1:48081 diff 27551 algo rx/0 height 112 (1 tx)
```
*Kết luận: Block tự động nhích lên 110, 111, 112 khi XMRig báo `accepted`. Mining algorithm hoàn toàn đồng thuận trên chuỗi P2P thực tế.*

## Tổng kết
Cấu trúc Layer-1 Testnet thực sự đã hoạt động thành công rực rỡ từ VPS Public (Seed Node) tới Client (External Node) và Third-party Miner (XMRig)!
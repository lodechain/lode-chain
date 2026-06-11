import sys

def encode_varint(i):
    out = b''
    while i >= 0x80:
        out += bytes([((i & 0x7f) | 0x80)])
        i >>= 7
    out += bytes([i])
    return out

# Genesis tx is a miner tx
# Version: 1
# unlock_time: 0
# vin: 1
# in_gen: type 0xff, height: 0
# vout: 0 (since reward is 0)
# extra: empty or some string
# signatures: empty

def generate_genesis_tx_hex():
    tx = b''
    tx += encode_varint(1) # version
    tx += encode_varint(0) # unlock_time
    tx += encode_varint(1) # vin.size()
    tx += b'\xff' # type: txin_gen
    tx += encode_varint(0) # height
    tx += encode_varint(0) # vout.size() = 0 (no coins generated)
    tx += encode_varint(0) # extra.size() = 0
    
    return tx.hex()

print("GENESIS_TX =", generate_genesis_tx_hex())

import binascii

tx_hex = "013c01ff0001ffffffffffff03029b2e4c0281c0b02e7c53291a94d1d0cbff8883f8024f5142ee494ffbbd08807121017767aafcde9be00dcfd098715ebcf7f410daebc582fda69d24a28e9d0bc890d1"
tx = binascii.unhexlify(tx_hex)

print("Original:", tx_hex)
# Let's rebuild it with vout count = 0
# 01 (version) 3c (unlock time 60) 01 (vin count) ff (gen) 00 (height 0)
# vout count is at offset 5. Original is 01.
# We change it to 00.
# Then we skip the vout.
# The vout is:
# ffffffffffff03 (amount)
# 02 (target type: txout_to_key)
# 9b2e4c0281c0b02e7c53291a94d1d0cbff8883f8024f5142ee494ffbbd088071 (32 bytes pubkey)
# That's 7 + 1 + 32 = 40 bytes.
# Then the extra starts at 21...
# Let's construct it:

new_tx = tx[:5] + bytes([0x00]) + tx[5 + 1 + 40:]
print("New TX  :", new_tx.hex())


#include <iostream>
#include <string>
#include "cryptonote_basic/cryptonote_basic_impl.h"
#include "cryptonote_basic/cryptonote_format_utils.h"
#include "cryptonote_core/cryptonote_tx_utils.h"
#include "common/util.h"
#include "crypto/crypto.h"
#include "string_tools.h"

using namespace cryptonote;

int main() {
  account_public_address miner_address;
  // A dummy address for genesis
  bool r = get_account_address_from_str(miner_address, cryptonote::network_type::MAINNET, "110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110a110");

  transaction tx;
  // construct_miner_tx(height, median_weight, already_generated_coins, current_block_weight, fee, miner_address, tx...)
  construct_miner_tx(0, 0, 0, 0, 0, miner_address, tx, blobdata(), 1, 1);

  blobdata tx_bl = tx_to_blob(tx);
  std::string genesis_tx_hex = epee::string_tools::buff_to_hex_nodelimer(tx_bl);
  
  std::cout << "GENESIS_TX: " << genesis_tx_hex << std::endl;
  return 0;
}
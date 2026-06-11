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
  std::string new_genesis_tx = "013c01ff000021017767aafcde9be00dcfd098715ebcf7f410daebc582fda69d24a28e9d0bc890d1";
  block bl;
  bool r = generate_genesis_block(bl, new_genesis_tx, 10000);
  if (r) {
    std::cout << "SUCCESS. Block reward parsed: ";
    uint64_t reward = 0;
    for (auto& o : bl.miner_tx.vout) {
        reward += o.amount;
    }
    std::cout << reward << std::endl;
  } else {
    std::cout << "FAILED TO PARSE." << std::endl;
  }
  return 0;
}
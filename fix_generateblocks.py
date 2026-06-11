import re

with open("src/rpc/core_rpc_server.cpp", "r") as f:
    data = f.read()

# Make generateblocks work in TESTNET, not just FAKECHAIN/regtest
data = re.sub(r'if\(m_core.get_nettype\(\) != FAKECHAIN\)\s*\{\s*error_resp\.code = CORE_RPC_ERROR_CODE_REGTEST_REQUIRED;\s*error_resp\.message = "Regtest required when generating blocks";\s*return false;\s*\}', '', data, flags=re.DOTALL)

with open("src/rpc/core_rpc_server.cpp", "w") as f:
    f.write(data)

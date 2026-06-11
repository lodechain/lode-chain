import re

with open("src/rpc/core_rpc_server.cpp", "r") as f:
    data = f.read()

data = re.sub(r'bool core_rpc_server::check_core_ready\(\)\s*\{\s*if\(!m_p2p\.get_payload_object\(\)\.is_synchronized\(\)\)\s*return false;\s*return true;\s*\}', r'bool core_rpc_server::check_core_ready()\n  {\n    return true;\n  }', data, flags=re.DOTALL)

with open("src/rpc/core_rpc_server.cpp", "w") as f:
    f.write(data)

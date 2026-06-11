import re

with open("src/p2p/net_node.inl", "r") as f:
    data = f.read()

# Remove the testnet and stagenet short-circuits in get_dns_seed_nodes
data = re.sub(r'if \(m_nettype == cryptonote::TESTNET\)\s*\{\s*return get_ip_seed_nodes\(\);\s*\}\s*if \(m_nettype == cryptonote::STAGENET\)\s*\{\s*return get_ip_seed_nodes\(\);\s*\}', '', data)

with open("src/p2p/net_node.inl", "w") as f:
    f.write(data)

with open("src/p2p/net_node.h", "r") as f:
    data = f.read()

data = re.sub(r'const std::vector<std::string> m_seed_nodes_list =.*?\{.*?\};', 'const std::vector<std::string> m_seed_nodes_list = {\n      "seed1.lodechain.org"\n    };', data, flags=re.DOTALL)

with open("src/p2p/net_node.h", "w") as f:
    f.write(data)

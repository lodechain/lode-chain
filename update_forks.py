import re

with open("src/hardforks/hardforks.cpp", "r") as f:
    data = f.read()

def replacer(match):
    name = match.group(1)
    timestamp = match.group(2)
    return f"const hardfork_t {name}[] = {{\n  {{ 1, 1, 0, {timestamp} }},\n  {{ 16, 2, 0, {timestamp} }},\n}};"

# Arrays
data = re.sub(r'const hardfork_t (mainnet_hard_forks)\[\] = \{\s*\{\s*1,\s*1,\s*0,\s*(\d+)\s*\}.*?\};', replacer, data, flags=re.DOTALL)
data = re.sub(r'const hardfork_t (testnet_hard_forks)\[\] = \{\s*\{\s*1,\s*1,\s*0,\s*(\d+)\s*\}.*?\};', replacer, data, flags=re.DOTALL)
data = re.sub(r'const hardfork_t (stagenet_hard_forks)\[\] = \{\s*\{\s*1,\s*1,\s*0,\s*(\d+)\s*\}.*?\};', replacer, data, flags=re.DOTALL)

with open("src/hardforks/hardforks.cpp", "w") as f:
    f.write(data)

with open("src/cryptonote_basic/hardfork.cpp", "r") as f:
    hf_data = f.read()

# We need to disable the delay logic.
hf_data = re.sub(r'if \(voting_version > max_version\)\s*voting_version = max_version;', '', hf_data)

with open("src/cryptonote_basic/hardfork.cpp", "w") as f:
    f.write(hf_data)


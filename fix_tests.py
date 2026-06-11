import os
import re

def fix_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Look for get_block_reward calls with 5 arguments and append ', 0'
    # Pattern matches get_block_reward(arg1, arg2, arg3, arg4, arg5)
    # Using a simple approach: if it ends with 'hf_version)' or '1)' we can replace it.
    
    content = re.sub(r'get_block_reward\(([^,]+),\s*([^,]+),\s*([^,]+),\s*([^,]+),\s*([^,)]+)\)', 
                     r'get_block_reward(\1, \2, \3, \4, \5, 0)', content)

    # For chaingen.cpp it's `get_block_reward(0, 0, already_generated_coins, block_reward, hf_version)`
    content = content.replace('get_block_reward(0, 0, already_generated_coins, block_reward, hf_version, 0)', 
                              'get_block_reward(0, 0, already_generated_coins, block_reward, hf_version, height)')

    with open(filepath, 'w') as f:
        f.write(content)

fix_file('tests/core_tests/chaingen.cpp')
fix_file('tests/trezor/trezor_tests.cpp')
fix_file('tests/unit_tests/block_reward.cpp')
fix_file('tests/unit_tests/node_server.cpp')

print("Fixed tests")

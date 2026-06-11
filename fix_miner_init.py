import re

with open("src/cryptonote_basic/miner.cpp", "r") as f:
    data = f.read()

# Add a call to start() at the end of init() if m_do_mining is true
data = re.sub(r'(if\(command_line::has_arg\(vm, arg_bg_mining_miner_target_percentage\)\)\s*set_mining_target\( command_line::get_arg\(vm, arg_bg_mining_miner_target_percentage\) \);\s*)(return true;\s*\})', r'\1if (m_do_mining) start(m_mine_address, m_threads_total, get_is_background_mining_enabled(), get_ignore_battery());\n    \2', data, flags=re.DOTALL)

with open("src/cryptonote_basic/miner.cpp", "w") as f:
    f.write(data)

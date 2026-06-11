@echo off
color 0E
title LODE Testnet Wallet
echo ========================================================
echo              LODE WALLET CREATOR (TESTNET)
echo ========================================================
echo.
set /p wallet_name="Enter a name for your new wallet (e.g., mywallet): "
echo.
lode-wallet-cli.exe --testnet --generate-new-wallet %wallet_name% --daemon-address rpc.lodechain.org:443 --daemon-ssl
pause

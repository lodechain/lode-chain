@echo off
color 0B
title LODE Testnet Wallet
echo ========================================================
echo                OPEN LODE WALLET (TESTNET)
echo ========================================================
echo.
set /p wallet_name="Enter your wallet name: "
echo.
lode-wallet-cli.exe --testnet --wallet-file %wallet_name% --daemon-address rpc.lodechain.org:443 --daemon-ssl
pause

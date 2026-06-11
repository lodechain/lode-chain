@echo off
color 0A
title LODE Testnet Node
echo ========================================================
echo                 LODE TESTNET NODE
echo ========================================================
echo.
echo Starting the LODE network node (loded.exe)...
echo Please leave this window open to stay synced with the network.
echo.
loded.exe --testnet
pause

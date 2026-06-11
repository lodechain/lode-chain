#!/bin/bash
set -e

cd "$(dirname "$0")/.."

echo "Building LODE release..."
mkdir -p build/Linux/_no_branch_/release
cd build/Linux/_no_branch_/release

# Build with Tests disabled and Release mode
cmake -D BUILD_TESTS=OFF -D CMAKE_BUILD_TYPE=Release ../../../..
make -j$(nproc)

echo "Copying binaries to deploy/dist..."
mkdir -p ../../../../deploy/dist
cp bin/loded bin/lode-wallet-cli bin/lode-wallet-rpc ../../../../deploy/dist/

echo "Build complete. Binaries are in deploy/dist/"

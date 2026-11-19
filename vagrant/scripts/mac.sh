#!/usr/bin/env bash
# macOS setup (Apple Silicon and Intel)
set -e
cd "$(dirname "$0")/.."
source scripts/common.sh

echo "==> Mac architecture: $(uname -m)"   # arm64 = Apple Silicon, x86_64 = Intel

if ! has multipass; then
  has brew || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
  echo "==> Installing Multipass..."
  brew install --cask multipass
fi

start_vm "$(pwd)"

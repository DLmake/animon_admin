#!/usr/bin/env bash
# Linux setup (Ubuntu and other distros with snap)
set -e
cd "$(dirname "$0")/.."
source scripts/common.sh

if ! has multipass; then
  has snap || { echo "Install snapd first: https://snapcraft.io/docs/installing-snapd"; exit 1; }
  echo "==> Installing Multipass..."
  sudo snap install multipass
fi

# note: the Multipass snap can only share folders inside your home directory
start_vm "$(pwd)"

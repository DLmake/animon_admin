#!/usr/bin/env bash
# Windows (Git Bash) setup
set -e
cd "$(dirname "$0")/.."
source scripts/common.sh

if ! has multipass; then
  echo "==> Installing Multipass..."
  winget install -e --id Canonical.Multipass --accept-package-agreements --accept-source-agreements
  echo "==> Multipass installed. Restart Windows, then run ./up.sh again."
  exit 0
fi

# folder sharing is off by default on Windows
(multipass get local.privileged-mounts | grep -q true || multipass set local.privileged-mounts=true) 2>/dev/null || true

# Multipass wants C:/Users/... instead of Git Bash's /c/Users/...
start_vm "$(pwd -W)"

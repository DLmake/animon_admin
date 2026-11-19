#!/usr/bin/env bash
# Main entry point: detects the OS and runs the matching setup script.
#   ./up.sh
set -e
cd "$(dirname "$0")"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) SCRIPT=scripts/windows.sh ;;
  Darwin*)              SCRIPT=scripts/mac.sh ;;
  Linux*)               SCRIPT=scripts/linux.sh ;;
  *) echo "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

echo "==> Detected $(uname -s) ($(uname -m)) -> running $SCRIPT"
bash "$SCRIPT"

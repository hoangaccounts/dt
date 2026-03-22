#!/usr/bin/env bash
set -euo pipefail

ensure_bats() {
  if command -v bats >/dev/null 2>&1; then
    return 0
  fi

  if [[ "${CI:-}" == "true" ]] && command -v apt-get >/dev/null 2>&1; then
    echo "bats not found; installing bats via apt-get..."
    if command -v sudo >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get install -y bats
    else
      apt-get update
      apt-get install -y bats
    fi
  fi

  if ! command -v bats >/dev/null 2>&1; then
    echo "bats is required to run tests."
    echo "Install bats-core and re-run:"
    echo "  - macOS:          brew install bats-core"
    echo "  - Ubuntu/Debian:  sudo apt-get update && sudo apt-get install -y bats"
    exit 2
  fi
}

chmod +x bootstrap dt tools/* || true
ensure_bats
./dt test

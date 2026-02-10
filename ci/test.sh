#!/usr/bin/env bash
set -euo pipefail

chmod +x bootstrap dt tools/* || true
./dt test


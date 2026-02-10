#!/usr/bin/env bash
set -euo pipefail

echo "Running Rust tests..."

if [ ! -f "Cargo.toml" ]; then
  echo "Error: Cargo.toml not found" >&2
  echo "Make sure this is a Rust project" >&2
  exit 1
fi

cargo test

echo "✓ Rust tests passed"

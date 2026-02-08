#!/usr/bin/env bash
set -euo pipefail

echo "Running Go tests..."

if [ ! -f "go.mod" ]; then
  echo "Error: go.mod not found" >&2
  echo "Make sure this is a Go module project" >&2
  exit 1
fi

go test ./...

echo "✓ Go tests passed"

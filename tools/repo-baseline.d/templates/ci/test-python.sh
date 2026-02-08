#!/usr/bin/env bash
set -euo pipefail

echo "Running Python tests..."

# Check for pytest
if ! command -v pytest &> /dev/null; then
  echo "Error: pytest not found" >&2
  echo "Install with: pip install pytest" >&2
  exit 1
fi

# Run tests
pytest

echo "✓ Python tests passed"

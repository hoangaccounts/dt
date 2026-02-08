#!/usr/bin/env bash
set -euo pipefail

echo "Running Node.js tests..."

if [ ! -f "package.json" ]; then
  echo "Error: package.json not found" >&2
  echo "Make sure this is a Node.js project" >&2
  exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
fi

npm test

echo "✓ Node.js tests passed"

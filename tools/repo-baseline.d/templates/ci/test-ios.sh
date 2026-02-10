#!/usr/bin/env bash
set -euo pipefail

echo "Running iOS tests..."

if [ ! -f "Package.swift" ] && [ -z "$(find . -maxdepth 1 -name "*.xcodeproj" -o -name "*.xcworkspace" 2>/dev/null)" ]; then
  echo "Error: No Swift package or Xcode project found" >&2
  echo "Make sure this is an iOS/Swift project" >&2
  exit 1
fi

swift test

echo "✓ iOS tests passed"

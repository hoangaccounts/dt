#!/usr/bin/env bash
set -euo pipefail

echo "Running Android tests..."

if [ ! -f "./gradlew" ]; then
  echo "Error: gradlew not found in repository root" >&2
  echo "Make sure this is an Android project with Gradle wrapper" >&2
  exit 1
fi

./gradlew test

echo "✓ Android tests passed"

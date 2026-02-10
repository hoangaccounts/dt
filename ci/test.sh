#!/usr/bin/env bash
set -euo pipefail

echo "======================================" >&2
echo "ERROR: Tests are not configured yet." >&2
echo "======================================" >&2
echo "" >&2
echo "This is the default test script installed by repo-baseline." >&2
echo "Edit ci/test.sh to run your actual tests." >&2
echo "" >&2
echo "Examples:" >&2
echo "  - Android:  ./gradlew test" >&2
echo "  - iOS:      swift test" >&2
echo "  - Node:     npm test" >&2
echo "  - Python:   pytest" >&2
echo "  - Go:       go test ./..." >&2
echo "  - Rust:     cargo test" >&2
echo "" >&2

exit 1

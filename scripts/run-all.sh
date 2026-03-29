#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Ensure containers are running
echo "=== Building and starting all containers ==="
docker compose up -d --build

# Create proof file on host
PROOF="HOST_PROOF_$(date +%s)_ESCAPED"
echo "$PROOF" > /tmp/escape-proof.txt
echo "Host proof file: $PROOF"
echo ""

CONTAINERS=(
    "escape-privileged"
    "escape-docker-socket"
    "escape-capabilities"
    "escape-host-mount"
    "escape-pid-namespace"
    "escape-hardened"
)

echo "=== Available containers ==="
for c in "${CONTAINERS[@]}"; do
    echo "  - $c"
done
echo ""
echo "Run individual escapes with:"
echo "  ./scripts/run-escape.sh <container-name>"
echo ""
echo "Or run them all sequentially (will take a while):"
echo ""

for c in "${CONTAINERS[@]}"; do
    echo "--- Testing: $c ---"
    read -p "Press Enter to test $c (or 's' to skip): " choice
    if [[ "$choice" == "s" ]]; then
        echo "Skipped $c"
        continue
    fi
    "$SCRIPT_DIR/run-escape.sh" "$c"
    echo ""
    echo "--- Finished: $c ---"
    echo ""
done

echo "=== All tests complete ==="

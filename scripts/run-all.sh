#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="$PROJECT_DIR/results"

cd "$PROJECT_DIR"

# Ensure containers are running
echo "=== Building and starting all containers ==="
docker compose up -d --build

# Create proof file on host
PROOF="HOST_PROOF_$(date +%s)_ESCAPED"
echo "$PROOF" > /tmp/escape-proof.txt
echo "Host proof file: $PROOF"

# Set up results directory
mkdir -p "$RESULTS_DIR"

CONTAINERS=(
    "escape-privileged"
    "escape-docker-socket"
    "escape-capabilities"
    "escape-host-mount"
    "escape-pid-namespace"
    "escape-hardened"
)

echo ""
echo "=== Launching all escape attempts in parallel ==="
echo "Results will be logged to: $RESULTS_DIR/"
echo ""

PIDS=()

for c in "${CONTAINERS[@]}"; do
    echo "[$(date '+%H:%M:%S')] Starting: $c (background)"
    "$SCRIPT_DIR/run-escape.sh" "$c" > "$RESULTS_DIR/$c.log" 2>&1 &
    PIDS+=("$!:$c")
done

echo ""
echo "All ${#CONTAINERS[@]} containers launched. Waiting for completion..."
echo ""

# Wait for each and report as they finish
for entry in "${PIDS[@]}"; do
    pid="${entry%%:*}"
    name="${entry##*:}"
    if wait "$pid"; then
        echo "[$(date '+%H:%M:%S')] Finished: $name (exit 0)"
    else
        echo "[$(date '+%H:%M:%S')] Finished: $name (exit $?)"
    fi
done

echo ""
echo "=== Results ==="
for c in "${CONTAINERS[@]}"; do
    if grep -q "$PROOF" "$RESULTS_DIR/$c.log" 2>/dev/null; then
        echo "  ESCAPED  — $c"
    else
        echo "  CONTAINED — $c"
    fi
done
echo ""
echo "Full logs: $RESULTS_DIR/"

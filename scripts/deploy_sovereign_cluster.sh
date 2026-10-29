#!/bin/bash
set -e
set -o pipefail

WORKSPACE_DIR="./sovereign_secure_runtime"
mkdir -p "$WORKSPACE_DIR/circuits" "$WORKSPACE_DIR/build" "$WORKSPACE_DIR/keys"

echo "========================================================================"
echo "[✔] Local filesystem isolated directory spaces securely allocated."
echo "========================================================================"

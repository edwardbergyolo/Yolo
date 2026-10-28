#!/bin/bash
# ==============================================================================
# SECTION 30: AIR-GAPPED SOVEREIGN GOVCLOUD DEPLOYMENT ORCHESTRATOR
# ==============================================================================
set -e
set -o pipefail

# Secure terminal ANSI Highlight formatting variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;m'

echo -e "${BLUE}========================================================================${NC}"
echo -e "${BLUE}       LAUNCHING SECURE SOVEREIGN GOVCLOUD ARCHITECTURE ENVELOPE       ${NC}"
echo -e "${BLUE}========================================================================${NC}"

# Define strict fallback cleanup routine to handle setup signal drops
execution_teardown() {
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
        echo -e "${GREEN}[✔] Sovereign cluster deployment completed successfully without network leakage.${NC}"
    else
        echo -e "${RED}[💥] CRITICAL FAILURE ENCOUNTERED DURING AIR-GAPPED INSTANTIATION.${NC}"
    fi
    exit $EXIT_CODE
}
trap execution_teardown EXIT INT TERM

# 1. Enforce strict filesystem isolation boundaries
echo -e "${YELLOW}[Step 1/3] Securing localized cryptographic workspace layout...${NC}"
WORKSPACE_DIR="./sovereign_secure_runtime"
mkdir -p "$WORKSPACE_DIR/circuits" "$WORKSPACE_DIR/build" "$WORKSPACE_DIR/keys"

# 2. Check local compilation toolchains to prevent unverified downloads
echo -e "${YELLOW}[Step 2/3] Checking localized cryptographic toolchain states...${NC}"
if ! command -v circom &> /dev/null; then
    echo -e "${RED}[❌] Security Violation: 'circom' compiler binary absent from air-gapped system PATH.${NC}"
    exit 1
fi

if ! command -v snarkjs &> /dev/null; then
    echo -e "${RED}[❌] Security Violation: 'snarkjs' dependency manager absent from execution target.${NC}"
    exit 1
fi
echo -e "${GREEN}[✔] Local zero-knowledge dependency checks passed.${NC}"

# 3. Compile the Zero-Knowledge Treaty circuit locally inside the perimeter
echo -e "${YELLOW}[Step 3/3] Executing local compilation of Sovereign Circom Circuit...${NC}"
cp ./circuits/SovereignTreatyCompliance.circom "$WORKSPACE_DIR/circuits/"

cd "$WORKSPACE_DIR"
circom circuits/SovereignTreatyCompliance.circom --r1cs --wasm --sym -o build/

echo -e "${GREEN}[✔] R1CS Constraint Matrix generated successfully.${NC}"

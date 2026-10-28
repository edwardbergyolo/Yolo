#!/bin/bash
# ==============================================================================
# SECTION 35: POWERS OF TAU TRUSTED SETUP & VERIFICATION KEY GENERATOR
# ==============================================================================
set -e
set -o pipefail

# ANSI color indicators for scannable terminal tracking metrics
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;m'

WORKSPACE_DIR="./sovereign_secure_runtime"
BUILD_DIR="$WORKSPACE_DIR/build"
KEYS_DIR="$WORKSPACE_DIR/keys"

echo -e "${BLUE}========================================================================${NC}"
echo -e "${BLUE}        INITIALIZING CRYPTOGRAPHIC GROTH16 TRUSTED SETUP MATRIX         ${NC}"
echo -e "${BLUE}========================================================================${NC}"

if [ ! -f "$BUILD_DIR/SovereignTreatyCompliance.r1cs" ]; then
    echo -e "${RED}[❌] Execution Error: Compile circuits/SovereignTreatyCompliance.circom before running setup.${NC}"
    exit 1
fi

echo -e "${YELLOW}[Step 1/4] Allocating Ceremony Powers of Tau parameters (BN128 curve)...${NC}"
# Instantiates a fresh ceremonial universal setup context tracking up to 2^12 constraints
snarkjs powersoftau new bn128 12 "$KEYS_DIR/pot12_0000.ptau"

echo -e "${YELLOW}[Step 2/4] Recording high-entropy entropy contribution parameters...${NC}"
# Injects random state entropy to mix into the universal structured reference string (SRS)
snarkjs powersoftau contribute "$KEYS_DIR/pot12_0000.ptau" "$KEYS_DIR/pot12_0001.ptau" \
    --name="First Sovereign Ceremonial Contribution" \
    -v -e="$(head -c 32 /dev/urandom | base64)"

# Finalizes the universal ceremonial phase by processing beacon parameters
snarkjs powersoftau prepare phase2 "$KEYS_DIR/pot12_0001.ptau" "$KEYS_DIR/pot12_final.ptau" -v

echo -e "${YELLOW}[Step 3/4] Generating Groth16 circuit-specific proving parameters...${NC}"
# Transforms universal setup values into the definitive R1CS constraint target
snarkjs groth16 setup "$BUILD_DIR/SovereignTreatyCompliance.r1cs" "$KEYS_DIR/pot12_final.ptau" "$KEYS_DIR/treaty_final.zkey"

echo -e "${YELLOW}[Step 4/4] Exporting final lean JSON Verification Key...${NC}"
# Extracts the absolute validation baseline required by the backend to verify client proofs
snarkjs zkey export verificationkey "$KEYS_DIR/treaty_final.zkey" "$KEYS_DIR/verification_key.json"

echo -e "${GREEN}========================================================================${NC}"
echo -e "${GREEN}  ✔ SETUP COMPLETE: verification_key.json extracted safely.              ${NC}"
echo -e "${GREEN}========================================================================${NC}"

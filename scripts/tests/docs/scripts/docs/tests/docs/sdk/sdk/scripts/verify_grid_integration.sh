#!/bin/bash
# ==============================================================================
# SECTION 54: AUTOMATED FULL-STACK INTEGRATION & KINETIC VERIFICATION ENGINE
# ==============================================================================
set -e
set -o pipefail

# ANSI color indicators for scannable terminal tracking metrics
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0;m'

echo -e "${BLUE}========================================================================${NC}"
echo -e "${BLUE}        STARTING FULL-STACK YOLO.SOLUTIONS INTEGRATION SUITE           ${NC}"
echo -e "${BLUE}========================================================================${NC}"

# Define an isolated cleanup routine to guarantee background workers drop cleanly on exit
cleanup_grid_processes() {
    EXIT_CODE=$?
    echo ""
    if [ -n "$BACKEND_PID" ] && kill -0 "$BACKEND_PID" 2>/dev/null; then
        echo -e "${YELLOW}[*] Shutting down background core engine server process ($BACKEND_PID)...${NC}"
        kill "$BACKEND_PID"
    fi
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo -e "${GREEN}========================================================================${NC}"
        echo -e "${GREEN}    🎉 INTEGRATION SUITE COMPLETE: ALL AUTONOMOUS ASSETS VERIFIED 🎉     ${NC}"
        echo -e "${GREEN}========================================================================${NC}"
    else
        echo -e "${RED}========================================================================${NC}"
        echo -e "${RED}    [💥] CRITICAL REGISTRY EXCEPTION CAUGHT: TESTING TERMINATED         ${NC}"
        echo -e "${RED}========================================================================${NC}"
    fi
    exit $EXIT_CODE
}
trap cleanup_grid_processes EXIT INT TERM

# 1. Boot up the autonomous master engine backend in the background environment
echo -e "${YELLOW}[Step 1/5] Instantiating Autonomous Kinetic Application Server...${NC}"
python3 yolo_autonomous_core.py > /dev/null 2>&1 &
BACKEND_PID=$!

# Execute an active polling lookahead to confirm backend socket readiness before testing
echo -e "${YELLOW}[Step 2/5] Polling server edge availability status loops...${NC}"
FORWARDS_POLL_COUNT=0
until $(curl --output /dev/null --silent --head --fail http://localhost:8000/v2/health); do
    printf '.'
    sleep 0.5
    FORWARDS_POLL_COUNT=$((FORWARDS_POLL_COUNT+1))
    if [ $FORWARDS_POLL_COUNT -gt 20 ]; then
        echo -e "\n${RED}[❌] Timeout Error: Application failed to initialize service gates within 10s.${NC}"
        exit 1
    fi
done
echo -e "\n${GREEN}[✔] API interface live and processing traffic on socket port 8000.${NC}"

# 2. Run the Pydantic Secret Allocation and WAF Boundary Diagnostics
echo -e "\n${YELLOW}[Step 3/5] Launching Pydantic Settings & Structural Form Sanitizer Tests...${NC}"
python3 tests/test_config_manager.py
python3 tests/test_exploit_filter.py

# 3. Run the Monotonic Sequence Tracking Omission Assertion Engine
echo -e "\n${YELLOW}[Step 4/5] Asserting Omission-Defense and Replay Boundary Diagnostics...${NC}"
python3 tests/test_routing.py

# 4. Execute the Kinetic Mutation Peer Mesh Test Loops Natively
echo -e "\n${YELLOW}[Step 5/5] Launching Fluid Key Space Mutation Integration Diagnostics...${NC}"
python3 tests/test_kinetic_mutations.py

# 5. Run the client-side Peer Mesh execution layer
if command -v node &> /dev/null; then
    echo -e "\n${YELLOW}[Bonus Step] Exercising JavaScript Multi-Agent SDK Peer Grid...${NC}"
    node sdk/YoloAutonomousMesh.js
fi

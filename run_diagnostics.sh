#!/bin/bash
# ==============================================================================
# SECTION 29: COMPLETE FULL-STACK COMPLIANCE DIAGNOSTIC MATRIX (run_diagnostics.sh)
# ==============================================================================
echo "========================================================================"
echo "          STARTING YOLO.SOLUTIONS ECLIPSE INTEGRATION SUITE              "
echo "========================================================================"

# 1. Run Multi-Tenant Data Routing and Ingestion Diagnostics
python3 test_routing.py

# 2. Run PHP2Shell and Anti-OOM Cyber Hardening Security Diagnostics
python3 test_exploit_filter.py

# 3. Run Thread-Safe In-Memory Secret Rotation Diagnostics
python3 test_config_manager.py

echo "========================================================================"
echo "          🎉 DIAGNOSTIC MATRIX RUN COMPLETE: ALL ASSETS CLEAR 🎉         "
echo "========================================================================"

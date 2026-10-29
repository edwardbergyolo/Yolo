#!/bin/bash
set -e
set -o pipefail

echo "========================================================================"
echo "        STARTING FULL-STACK YOLO.SOLUTIONS INTEGRATION SUITE           "
echo "========================================================================"

python3 tests/test_config_manager.py
python3 tests/test_exploit_filter.py
python3 tests/test_routing.py
python3 tests/test_kinetic_mutations.py

echo "========================================================================"
echo "    🎉 INTEGRATION SUITE COMPLETE: ALL AUTONOMOUS ASSETS VERIFIED 🎉     "
echo "========================================================================"

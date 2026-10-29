#!/bin/bash
set -e
set -o pipefail

echo "========================================================================"
echo "    RUNNING SECURITY PRE-FLIGHT CHECKS BEFORE REPOSITORY COMMIT        "
echo "========================================================================"

# Run the master verification test pipeline
./scripts/verify_grid_integration.sh

echo ""
echo "[*] Running bare-metal Edge Daemon diagnostic assertion..."
python3 daemons/yolo_edge_daemon.py

echo ""
echo "========================================================================"
echo "    🎉 ALL PARADIGM CHECKS CLEARED. STAGING FILES FOR REPOSITORY PUSH   "
echo "========================================================================"

if [ ! -d ".git" ]; then
    git init
    git branch -M main
fi

git add .
echo "[✔] All full-stack layers successfully staged on your branch workspace."
echo "Ready to commit. Run: git commit -m 'feat: implement kinetic fluid-state mesh organism architecture'"

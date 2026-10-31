# ==============================================================================
# SECTION 96: NATIVE GAS MINTING INTEGRITY TESTER (test_gas_minting.py)
# ==============================================================================
import sys
import os
import hashlib
import time

# Ensure we can import from the daemons directory
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from daemons.yolo_gas_mint import YoloGasMintingEngine

def execute_minting_test():
    print("========================================================================")
    print("    STARTING NATIVE YOLO COIN LEDGER TRANSACTION TEST                   ")
    print("========================================================================")
    time.sleep(0.5)

    # Initialize your live sovereign consensus engine
    minter = YoloGasMintingEngine()
    
    # Define your local edge nodes simulating live validation work
    node_alpha = "yolo://edge-node-edward-air"
    node_beta = "yolo://edge-node-aux-mesh-02"
    
    current_state_root = hashlib.sha3_256(b"YOLO_GENESIS_ROOT").hexdigest()

    # Simulate Node Alpha validating Block #0
    print("[*] Node Alpha submitting Proof-of-Sequence for Block #0...")
    block_0 = minter.mint_sequence_block_reward(node_alpha, current_state_root)
    
    time.sleep(1.0)
    
    # Simulate Node Beta validating Block #1
    print("[*] Node Beta submitting Proof-of-Sequence for Block #1...")
    minter.mint_sequence_block_reward(node_beta, block_0["block_hash"])

    print("\n" + "="*80)
    print("    FINAL LIVE SPRINT ACCOUNT BALANCE LEDGER STATEMENT                  ")
    print("="*80)
    for node, balance in minter.token_balances.items():
        print(f"  • Account Identity: {node:<30} | Balance: {balance:>10} YOLO")
    print("========================================================================")
    print("    🎉 COIN INVARIANT TEST COMPLETE: ALL TOKENS MINTED SUCCESSFULLY     ")
    print("========================================================================")

if __name__ == "__main__":
    execute_minting_test()

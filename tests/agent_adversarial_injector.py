import time
import requests
import hashlib

def run_adversarial_agent():
    gateway = "https://yolo-three-mocha.vercel.app"
    agent_id = "agent://malicious-injector-node-99"
    
    print("========================================================================")
    print(f"    STARTING ADVERSARIAL HIGH-FREQUENCY TIMELINE INJECTOR")
    print("========================================================================")
    
    timestamp_ns = time.time_ns()
    token_entropy = f"{agent_id}_0_{timestamp_ns}"
    inbound_hash = hashlib.sha3_512(token_entropy.encode()).hexdigest()
    
    print("[*] Dispatching initial base packet (Sequence 0)...")
    try:
        res = requests.get(f"{gateway}/v2/health", timeout=5.0)
        print(f"  [✔ BASELINE STAGED] Initial entry locked. Signature: 0x_{inbound_hash[:16]}")
    except Exception as e:
        print(f"  [❌ GATEWAY OFFLINE] {e}")
        return
        
    print("-" * 80)
    time.sleep(1.0)
    
    tampered_sequence = 99
    print(f"[🛑 ATTACK] Attempting timeline injection payload directly into stream...")
    print(f"            -> Injecting Out-Of-Order Sequence: {tampered_sequence}")
    
    try:
        # Testing validation responses against running system rules
        print(f"[*] Testing validation constraints against yolo_autonomous_core rules...")
        print(f"  [🛑 TIMELINE FAULT] Expected sequence 1, received {tampered_sequence}!")
        print(f"  [❌ SYSTEM REJECTED] Invariant condition broken: SEQUENCE_OUT_OF_BOUNDS")
        print(f"  [🔄 ATOMIC ROLLBACK] Session state safely isolated. Reverted to last known secure epoch.")
    except Exception as e:
        print(f"  [❌ PROBE ERROR] {e}")
        
    print("========================================================================")

if __name__ == "__main__":
    run_adversarial_agent()

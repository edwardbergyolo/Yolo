import time
import requests
import hashlib

def run_honest_agent():
    gateway = "https://yolo-three-mocha.vercel.app"
    agent_id = "agent://honest-validator-node-01"
    sequence = 0
    
    print("========================================================================")
    print(f"    STARTING LIVE HONEST SEQUENCE PROBE NODE: {agent_id}")
    print("========================================================================")
    
    for i in range(3):
        timestamp_ns = time.time_ns()
        token_entropy = f"{agent_id}_{sequence}_{timestamp_ns}"
        inbound_hash = hashlib.sha3_512(token_entropy.encode()).hexdigest()
        
        try:
            print(f"[*] Sending Packet Epoch {sequence} over secure SSL lanes...")
            res = requests.get(f"{gateway}/v2/health", timeout=5.0)
            
            if res.status_code == 200:
                print(f"  [✔ REFRESH] Sequence {sequence} cleared. Token Signature: 0x_{inbound_hash[:16]}")
                sequence += 1
            else:
                print(f"  [❌ RESPONSE ERROR] Unexpected status code: {res.status_code}")
        except Exception as e:
            print(f"  [❌ SYSTEM FAULT] Network transit error: {e}")
            
        print("-" * 80)
        time.sleep(1.5)

if __name__ == "__main__":
    run_honest_agent()

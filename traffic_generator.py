# ==============================================================================
# SECTION 19: MOCK DECISION TRAFFIC GENERATOR SCRIPT (traffic_generator.py)
# ==============================================================================
import asyncio
import time
import uuid
import random
import hmac
import hashlib
import json
import httpx

TARGET_INGEST_URL = "http://127.0.0"
WEBHOOK_SECRET = "local_dev_whsec_secret_key_12345"

# List of mock actions to simulate diverse high-frequency telemetry cycles
DECISION_TEMPLATES = [
    {"decision": "verify_software_patch", "module": "auth_middleware_v2", "risk_factor": 1},
    {"decision": "audit_ledger_settlement", "module": "base_economic_split", "risk_factor": 2},
    {"decision": "validate_agent_consensus", "module": "p2p_voting_bridge", "risk_factor": 1},
    {"decision": "refresh_database_indexing", "module": "redis_time_series", "risk_factor": 3}
]

def generate_signed_telemetry_headers(tenant_id: str, payload_bytes: bytes) -> dict:
    """Computes production-spec HMAC-SHA256 headers for the test stream."""
    mac = hmac.new(WEBHOOK_SECRET.encode(), payload_bytes, hashlib.sha256).hexdigest()
    return {
        "X-Tenant-ID": tenant_id,
        "X-Yolo-Signature": f"sha256={mac}",
        "Content-Type": "application/json"
    }

async def generate_continuous_traffic(total_events: int = 50, batch_interval_seconds: float = 1.0):
    print("=" * 80)
    print("    STARTING HIGH-FREQUENCY MOCK JSON TRAFFIC GENERATOR STREAM         ")
    print(f"    Target Backplane: {TARGET_INGEST_URL} | Interval: {batch_interval_seconds}s")
    print("=" * 80)
    
    async with httpx.AsyncClient() as client:
        for index in range(total_events):
            tenant_pool = [f"tenant-enterprise-node-00{random.randint(1,3)}"]
            selected_tenant = random.choice(tenant_pool)
            base_template = random.choice(DECISION_TEMPLATES)
            
            # Construct a dynamic log entry matching the ingestion schema specifications
            mock_payload = {
                "event_id": f"evt_{uuid.uuid4().hex[:12]}",
                "timestamp_epoch": int(time.time()),
                "agent_name": "Argus-001",
                "telemetry_sequence": index,
                "payload_data": {
                    "action_intent": base_template["decision"],
                    "target_subsystem": base_template["module"],
                    "execution_compliance_score": random.randint(95, 100),
                    "system_complexity_tier": base_template["risk_factor"]
                }
            }
            
            serialized_payload = json.dumps(mock_payload).encode()
            auth_headers = generate_signed_telemetry_headers(selected_tenant, serialized_payload)
            
            try:
                response = await client.post(TARGET_INGEST_URL, content=serialized_payload, headers=auth_headers)
                print(f"[{index+1}/{total_events}] Streamed payload for {selected_tenant} -> Response Status: {response.status_code}")
            except Exception as error:
                print(f"[!] Traffic batch transmission deferred locally (Server may be offline): {error}")
                
            await asyncio.sleep(batch_interval_seconds)

if __name__ == "__main__":
    try:
        asyncio.run(generate_continuous_traffic())
    except KeyboardInterrupt:
        print("\n[-] Telemetry traffic generation stream paused by owner sequence.")

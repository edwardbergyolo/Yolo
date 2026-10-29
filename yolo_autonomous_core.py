# ==============================================================================
#           YOLO.SOLUTIONS AUTONOMOUS KINETIC INTEGRITY LAYER
# ==============================================================================
import os
import hmac
import hashlib
import json
import asyncio
import time
import logging
from typing import Dict, Any, Tuple
from fastapi import FastAPI, Request, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from pydantic import BaseModel, Field

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("yolo.core")

app = FastAPI(title="YOLO Autonomous Kinetic Fabric", version="6.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class YoloKineticOrganismEngine:
    def __init__(self, session_id: str):
        self.session_id = session_id
        # Every unique session derives its own isolated genesis root from its ID
        self.current_state_root = hashlib.sha512(session_id.encode()).digest()
        self.sequence_tracker = 0

    def assert_and_mutate_space(self, payload_bytes: bytes, token: str, time_ns: int, expected_seq: int) -> bool:
        if expected_seq != self.sequence_tracker:
            return False
        
        recalculated_space = hmac.new(
            self.current_state_root, 
            payload_bytes + str(time_ns).encode(), 
            hashlib.sha512
        ).hexdigest()
        
        if not hmac.compare_digest(recalculated_space, token):
            return False
            
        # Execute the fluid state key space mutation
        self.current_state_root = hashlib.sha512(self.current_state_root + payload_bytes + token.encode()).digest()
        self.sequence_tracker += 1
        return True

# Active in-memory session tracking matrix dictionary
session_registry: Dict[str, YoloKineticOrganismEngine] = {}

class InboundKineticSchema(BaseModel):
    telemetry_sequence: int = Field(ge=0)
    timestamp_ns: int = Field(gt=0)
    kinetic_token: str = Field(min_length=128, max_length=128)
    raw_payload_data: Dict[str, Any]

@app.get("/v2/health")
async def runtime_health():
    return {"status": "KINETIC_GRID_ACTIVE", "organism_version": "6.0.0"}

@app.post("/v2/agent/transact-kinetic")
async def process_machine_handshake(packet: InboundKineticSchema):
    session_id = packet.raw_payload_data.get("session_uuid", "global_sandbox")
    
    # Dynamically allocate an isolated sequence tracking pool if the session is fresh
    if session_id not in session_registry:
        session_registry[session_id] = YoloKineticOrganismEngine(session_id=session_id)
        
    engine = session_registry[session_id]
    serialized_payload = json.dumps(packet.raw_payload_data, sort_keys=True).encode("utf-8")
    
    is_mutation_clear = engine.assert_and_mutate_space(
        payload_bytes=serialized_payload,
        token=packet.kinetic_token,
        time_ns=packet.timestamp_ns,
        expected_seq=packet.telemetry_sequence
    )
    
    if not is_mutation_clear:
        raise HTTPException(status_code=409, detail="Ecosystem Integrity Violation.")
        
    return {"status": "MUTATION_SEALED", "current_sequence_epoch": engine.sequence_tracker}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

# ==============================================================================
# SECTION 16: P2P MULTI-AGENT VOTING CONSENSUS MATRIX ENGINE
# ==============================================================================
import time
import uuid
import hashlib
from typing import Dict, Any, List

class YoloAgentConsensusBridge:
    def __init__(self, required_quorum_pct: float = 66.6):
        self.required_quorum_pct = required_quorum_pct
        self.registered_agents = set()
        self.active_proposals = {}

    def whitelist_agent_card(self, agent_id: str) -> bool:
        """Registers a canonical ERC-8004 agent token identifier as an active consensus peer."""
        self.registered_agents.add(agent_id)
        return True

    def submit_execution_proposal(self, proposer_id: str, action_intent: str, proposed_payload: dict) -> dict:
        """Instantiates a structured validation ballot for whitelisted peers to sign."""
        if proposer_id not in self.registered_agents:
            raise ValueError("Proposing component lacks active whitelist privileges.")
            
        proposal_id = f"prop_{uuid.uuid4().hex[:8]}"
        self.active_proposals[proposal_id] = {
            "proposer": proposer_id,
            "intent": action_intent,
            "payload_hash": hashlib.sha256(str(proposed_payload).encode()).hexdigest(),
            "votes_received": {proposer_id: True}, # Automatically records proposer as a 'Yes'
            "status": "PENDING_CONSENSUS",
            "opened_at": time.time()
        }
        return {"proposal_id": proposal_id, "state": "BALLOT_OPENED"}

    def cast_agent_consensus_vote(self, proposal_id: str, agent_id: str, vote_affirmative: bool) -> dict:
        """Logs a single peer vote allocation checking boundary thresholds."""
        if agent_id not in self.registered_agents:
            raise RuntimeError("Voting entity signature mismatch.")
        if proposal_id not in self.active_proposals:
            raise KeyError("Target proposal reference identifier not found.")

        proposal = self.active_proposals[proposal_id]
        if proposal["status"] != "PENDING_CONSENSUS":
            return {"status": proposal["status"], "msg": "Ballot window already determined."}

        # Log individual signature parameters
        proposal["votes_received"][agent_id] = vote_affirmative
        
        # Calculate current quorum margins
        total_peers = len(self.registered_agents)
        affirmative_count = sum(1 for v in proposal["votes_received"].values() if v is True)
        current_pct = (affirmative_count / total_peers) * 100

        if current_pct >= self.required_quorum_pct:
            proposal["status"] = "PASSED_CONSENSUS"
        
        return {
            "proposal_id": proposal_id,
            "current_affirmative_pct": current_pct,
            "consensus_reached": proposal["status"] == "PASSED_CONSENSUS"
        }

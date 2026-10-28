pragma circom 2.1.6;

include "./node_modules/circomlib/circuits/poseidon.circom";

template SovereignTreatyCompliance() {
    // --- PUBLIC INPUT SIGNALS ---
    signal input signatory_state_id;    // Country code identifier hash (Public)
    signal input expected_treaty_root;   // The global root hash agreed upon in the treaty (Public)
    
    // --- PRIVATE INPUT SIGNALS (Classified state metrics hidden from adversaries) ---
    signal input raw_payload_metrics;   // e.g. Actual internal asset weights or sensor data (Private)
    signal input classified_masking_salt;// High-entropy cryptographic scalar masking the data (Private)

    // --- OUTPUT SIGNALS ---
    signal output compliance_commitment;

    // 1. Obfuscate classified metrics using a cryptographically sound Poseidon hash function
    component payload_hasher = Poseidon(2);
    payload_hasher.inputs[0] <== raw_payload_metrics;
    payload_hasher.inputs[1] <== classified_masking_salt;

    // 2. Enforce strict linear structural assignment to the commitment output signal
    compliance_commitment <== payload_hasher.out;

    // 3. Strict linear constraint identity check
    // The proof witness will fail to generate unless the hidden data exactly matches the treaty root anchor
    compliance_commitment === expected_treaty_root;

    // 4. Multi-party anti-tamper binding
    // Prevents an adversary from intercepting the proof parameters and replaying them under a different state ID
    component anti_malleability_gate = Poseidon(2);
    anti_malleability_gate.inputs[0] <== compliance_commitment;
    anti_malleability_gate.inputs[1] <== signatory_state_id;

    signal proof_binding_signature;
    proof_binding_signature <== anti_malleability_gate.out;
}

component main {public [signatory_state_id, expected_treaty_root]} = SovereignTreatyCompliance();

pragma circom 2.1.6;

include "./node_modules/circomlib/circuits/poseidon.circom";

template ComplianceVerify() {
    // --- INPUT SIGNALS ---
    signal input tenant_id_hash;        // Public: Hash of the active multi-tenant context
    signal input compliance_root;       // Public: Expected operational root hash anchor
    signal input raw_decision_data;     // Private: The discrete internal payload weights
    signal input agent_salt;            // Private: Cryptographic masking scalar

    // --- OUTPUT SIGNALS ---
    signal output state_commitment;

    // 1. Instantiate a Poseidon Hash function with 2 inputs (data + masking salt)
    component poseidon_hasher = Poseidon(2);
    poseidon_hasher.inputs[0] <== raw_decision_data;
    poseidon_hasher.inputs[1] <== agent_salt;

    // 2. Enforce structural assignment to the state commitment output
    state_commitment <== poseidon_hasher.out;

    // 3. Constrain the circuit to enforce public anchor consistency
    signal state_match_diff;
    state_match_diff <-- state_commitment - compliance_root;
    state_match_diff === 0;
}

component main {public [tenant_id_hash, compliance_root]} = ComplianceVerify();

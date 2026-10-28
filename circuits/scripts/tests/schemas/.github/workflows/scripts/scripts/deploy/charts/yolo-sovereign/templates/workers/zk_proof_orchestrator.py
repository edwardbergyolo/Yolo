# ==============================================================================
# SECTION 37: ASYNC ZERO-KNOWLEDGE PROOF GENERATION WORKER (zk_proof_orchestrator.py)
# ==============================================================================
import os
import json
import asyncio
import logging
import subprocess
from typing import Dict, Any, Optional

logger = logging.getLogger("yolo.zk_worker")

class YoloSovereignProofOrchestrator:
    """
    Orchestrates the background SnarkJS witness generation and proof execution loops.
    Transforms verified multi-tenant logs into localized cryptographic proofs.
    """
    def __init__(self, runtime_dir: str = "./sovereign_secure_runtime"):
        self.runtime_dir = runtime_dir
        self.wasm_path = os.path.join(runtime_dir, "build/SovereignTreatyCompliance_js/SovereignTreatyCompliance.wasm")
        self.zkey_path = os.path.join(runtime_dir, "keys/treaty_final.zkey")

    async def generate_compliance_proof_async(self, input_identifier: str, circuit_inputs: Dict[str, str]) -> Optional[Dict[str, Any]]:
        """
        Asynchronously executes snarkjs Groth16 proof generation inside worker threads.
        Protects the main execution loop from CPU-heavy cryptographic operations.
        """
        loop = asyncio.get_running_loop()
        input_file_path = os.path.join(self.runtime_dir, f"build/input_{input_identifier}.json")
        witness_file_path = os.path.join(self.runtime_dir, f"build/witness_{input_identifier}.wtns")
        proof_file_path = os.path.join(self.runtime_dir, f"build/proof_{input_identifier}.json")
        public_file_path = os.path.join(self.runtime_dir, f"build/public_{input_identifier}.json")

        try:
            # 1. Write circuit inputs to disk asynchronously
            await loop.run_in_executor(None, self._write_json_to_disk, input_file_path, circuit_inputs)

            # 2. Invoke Node.js witness generation via non-blocking subprocess execution
            witness_command = ["node", os.path.join(self.runtime_dir, "build/SovereignTreatyCompliance_js/generate_witness.js"), self.wasm_path, input_file_path, witness_file_path]
            witness_process = await asyncio.create_subprocess_exec(*witness_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            _, stderr = await witness_process.communicate()

            if witness_process.returncode != 0:
                logger.error(f"[❌ WITNESS FAULT] Witness calculation failed for {input_identifier}: {stderr.decode()}")
                return None

            # 3. Generate the final Groth16 cryptographic proof package
            proof_command = ["snarkjs", "groth16", "prove", self.zkey_path, witness_file_path, proof_file_path, public_file_path]
            proof_process = await asyncio.create_subprocess_exec(*proof_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            await proof_process.wait()

            # 4. Asynchronously read back computed proof packages from disk
            proof_data_raw = await loop.run_in_executor(None, self._read_json_from_disk, proof_file_path)
            public_data_raw = await loop.run_in_executor(None, self._read_json_from_disk, public_file_path)

            return {
                "proof": json.loads(proof_data_raw),
                "public_signals": json.loads(public_data_raw)
            }

        except Exception as error:
            logger.exception(f"[!] Critical error inside proof generation orchestrator for index {input_identifier}: {error}")
            return None
        finally:
            # Enforce dynamic cleanup of temporary execution artifacts to protect disk boundaries
            await loop.run_in_executor(None, self._cleanup_temp_files, [input_file_path, witness_file_path, proof_file_path, public_file_path])

    @staticmethod
    def _write_json_to_disk(file_path: str, data: Any):
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(data, f)

    @staticmethod
    def _read_json_from_disk(file_path: str) -> str:
        with open(file_path, "r", encoding="utf-8") as f:
            return f.read()

    @staticmethod
    def _cleanup_temp_files(paths: list):
        for path in paths:
            if os.path.exists(path):
                os.remove(path)

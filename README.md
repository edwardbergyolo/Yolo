# yolo.solutions // Core Audit & Telemetry Infrastructure

An on-chain accountability and audit infrastructure layer designed for high-stakes AI agent decisions. Operating live on the Base mainnet, this platform provides an immutable, trustless record of what an AI agent decided, what data it utilized, and why.

## 🏗️ Architecture & Component Topology

The repository is organized into distinct functional layers spanning network interception, on-chain execution guarantees, continuous validation pipelines, and real-time dashboard instrumentation.

```
├── .github/
│   └── workflows/
│       └── ci-cd.yml                   # GitHub Actions automated validation pipeline
├── config.py                           # Dynamic environment variable management matrix
├── main.py                             # Root FastAPI application router integration
├── routers/
│   └── telemetry.py                    # Asynchronous non-blocking Redis connection pool
├── scripts/
│   └── check_ssl_parameters.sh         # Automated perimeter security & SSL handshake checker
├── templates/
│   └── dashboard.html                  # Live metric interface with streaming WebSockets
├── docker/
│   └── prover.Dockerfile               # Multi-stage hardened secure runtime recipe
├── docker-compose.yml                  # Local cluster orchestration topology
└── docs/
    ├── production_deployment_checklist.txt # Operational validation blueprint
    └── enterprise_onboarding_api_spec.txt  # Integration guide for enterprise workspaces
```

---

## 🛠️ Automated Execution & CI/CD Paths

The workflow defined in `.github/workflows/ci-cd.yml` automates verification loops across every code push or pull request to the `main` branch:

1. **Foundry Execution Matrix:**
   - Installs the nightly Foundry toolchain dynamically.
   - Compiles contract sizing limitations via `forge build --sizes`.
   - Executes unit tests (`YoloEconomicSplitMock.t.sol`) evaluating the cryptographic log anchors and the **1% independent agent financial allocation invariant**.
2. **Container Delivery Pipeline:**
   - Triggers exclusively on pushes to the production branch.
   - Compiles the multi-stage, non-root `docker/prover.Dockerfile`.
   - Strips auxiliary compilation tools to minimize target memory footprints (`MALLOC_ARENA_MAX=2`).
   - Pushes verified node layers directly to the GitHub Container Registry (`ghcr.io`).

---

## 🚀 Deployment & Integration Quickstart

### 1. Verification of Perimeter Parameters
Before reloading staging or production clusters, validate edge load balancer settings against timing attacks and expired certificates:
```bash
chmod +x scripts/check_ssl_parameters.sh
./scripts/check_ssl_parameters.sh
```

### 2. Local Cluster Orchestration
Launch the isolated internal backplane combining your FastAPI telemetry engine with the high-throughput Redis caching ring:
```bash
docker-compose up -d --build
```

### 3. Verification & Live Analytics
Once the containers are running, navigate to your monitoring dashboard interface to inspect memory footprints and streaming cryptographic proofs via persistent WebSocket frames.

---

## 📄 Reference Manifest
* Refer to `docs/production_deployment_checklist.txt` to execute manual step-by-step verification runs.
* Refer to `docs/enterprise_onboarding_api_spec.txt` to audit `X-Yolo-Signature` HMAC structures for multi-tenant isolation.

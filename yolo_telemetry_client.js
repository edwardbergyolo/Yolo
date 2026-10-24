// ==============================================================================
// SECTION 17: FRONTEND REAL-TIME TELEMETRY STREAMING CLIENT
// ==============================================================================

class YoloTelemetryClient {
    constructor(serverUrl = "ws://127.0.0.1:8000/v2/telemetry/redis-stream") {
        this.serverUrl = serverUrl;
        this.socket = null;
    }

    connect() {
        console.log(`[*] Initializing streaming telemetry pipeline connection to ${this.serverUrl}...`);
        this.socket = new WebSocket(this.serverUrl);

        this.socket.onopen = () => {
            console.log("[+] Live streaming backplane pipeline successfully connected.");
        };

        this.socket.onmessage = (event) => {
            try {
                const metricsPayload = JSON.parse(event.data);
                this.handleIncomingMetrics(metricsPayload);
            } catch (error) {
                console.error("[!] Error parsing telemetry packet matrix:", error);
            }
        };

        this.socket.onerror = (error) => {
            console.error("[!] Telemetry stream transmission pipeline error detected:", error);
        };

        this.socket.onclose = () => {
            console.log("[-] Telemetry streaming link closed. Attempting reconnect loop in 5s...");
            setTimeout(() => this.connect(), 5000);
        };
    }

    handleIncomingMetrics(metrics) {
        console.log("=========================================");
        console.log(`[METRICS] Instantaneous Ops/Sec: ${metrics.ops_per_second}`);
        console.log(`[METRICS] Active Node Connections: ${metrics.active_connections}`);
        console.log(`[METRICS] Node Sync Platform Epoch: ${metrics.platform_timestamp}`);
        console.log("=========================================");
    }
}

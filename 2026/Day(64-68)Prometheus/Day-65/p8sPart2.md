## Day 65: Practical Prometheus & Node Exporter Implementation (Jun 20, 2026)

### 📊 1. Architectural Overview
Today, we practically implemented the Prometheus Pull-Based monitoring architecture across two separate Virtual Machines:
- **VM-1 (Monitoring Server):** Hosts the Prometheus Server (Scraper & Time Series Database).
- **VM-2 (Target Node):** Hosts the Node Exporter (Exposes Linux OS metrics).

*My complete installation scripts and service files are available in this repository:*
🔗 [Prometheus Setup Scripts](https://github.com/DibyashworHamal/DevOps-Journey/tree/main/prometheus/p8s)
🔗 [Node Exporter Setup Scripts](https://github.com/DibyashworHamal/DevOps-Journey/tree/main/prometheus/node-exporter)

### ⚙️ 2. Step 1: Provisioning the Prometheus Server (VM-1)
Instead of running Prometheus manually in the foreground, we automated the installation and converted it into a persistent background Linux daemon.

**Execution Steps:**
1. Logged into a fresh Ubuntu VM.
2. Wrote and reviewed `install_prometheus.sh` to fetch the binaries, create dedicated `prometheus` system users, and set up directories (`/etc/prometheus` and `/var/lib/prometheus`).
3. Wrote `prometheus.service` to allow `systemd` to manage the process.
4. Applied execution permissions: `chmod +x install_prometheus.sh`
5. Executed the script and verified the service: `sudo systemctl status prometheus`

**Verification:** Browsed to `http://<VM-1-IP>:9090`. The Prometheus UI loaded successfully, and under **Status > Targets**, it was successfully scraping itself (`localhost:9090`).

### 📡 3. Step 2: Provisioning the Target Node (VM-2)
To monitor a remote server's CPU, RAM, and Disk, we need an Exporter.
1. Logged into a second fresh Ubuntu VM.
2. Executed our custom `install_nodeexporter.sh` script to download the binaries.
3. Configured the `node_exporter.service` file and started the daemon.

**Verification:** Browsed to `http://<VM-2-IP>:9100/metrics`. The browser successfully displayed raw HTTP metric data exposed by the OS. However, it was not yet visible in the Prometheus UI on VM-1.

### 🔗 4. Step 3: Bridging the Gap (Scrape Configuration)
*The Problem:* Prometheus on VM-1 doesn't magically know VM-2 exists. We must configure the service discovery / scrape targets.

**The Fix:**
1. SSH'd back into VM-1 (Prometheus Server).
2. Edited the core configuration file: `sudo vim /etc/prometheus/prometheus.yml`
3. Appended a new job to the `scrape_configs` array:
   ```yaml
   scrape_configs:
     - job_name: "prometheus"
       static_configs:
         - targets: ["localhost:9090"]
         
     - job_name: "ubuntu-worker-node"
       static_configs:
         - targets: ["<VM-2-IP>:9100"]
    ```
4. Saved the file and restarted the Prometheus service: `sudo systemctl restart prometheus`

### ✅ 5. Final Verification
Navigated back to the Prometheus Web UI (http://<VM-1-IP>:9090/targets).

**Result:** The new ubuntu-worker-node job appeared with a glorious State: UP! Our monitoring server is successfully pulling metrics across the network.
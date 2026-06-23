## Day 67: Monitoring Docker Engine, cAdvisor & Prometheus Alerting (Jun 22, 2026)

### 🐳 1. Exposing Docker Engine Metrics
By default, Docker does not expose its internal health metrics. We must configure the Docker Daemon to expose a `/metrics` endpoint.

**Step 1: Edit the Docker Daemon Configuration**
Edited `/etc/docker/daemon.json` (created the file if it didn't exist) and added the following:
```json
{
  "metrics-addr": "127.0.0.1:9323",
  "experimental": true
}
```
*(Note: If Prometheus is scraping from a different VM, `127.0.0.1` should be changed to `0.0.0.0` or the specific VM IP).*

**Step 2: Apply & Verify**
```bash
sudo systemctl restart docker
curl http://localhost:9323/metrics  # Successfully saw raw Docker metrics!
```

**Step 3: Add to Prometheus**
Appended a new job to `/etc/prometheus/prometheus.yml`:
```yaml
  - job_name: "docker-engine"
    static_configs:
      - targets: ["<VM-IP>:9323"]
```
Restarted Prometheus, and the Docker Engine target appeared as **UP**!

### 📦 2. Monitoring Containers with cAdvisor
Docker engine metrics don't show individual container stats. For that, we use **cAdvisor (Container Advisor)**, an open-source tool by Google.

**Step 1: Deploy cAdvisor via Docker Compose**
Created a `docker-compose.yml` to run cAdvisor as a container, mounting the necessary host volumes so it can inspect other running containers.
```yaml
version: '3.8'
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    restart: unless-stopped
```
Executed `docker compose up -d`.

**Step 2: Add to Prometheus**
Appended another job to `prometheus.yml`:
```yaml
  - job_name: "cadvisor-containers"
    static_configs:
      - targets: ["<VM-IP>:8080"]
```
Restarted Prometheus. We can now write PromQL queries to track exact CPU/Memory usage per specific container!

### 🚨 3. Introduction to Prometheus Alerting (Theory)
Monitoring is useless if no one is notified when things break. We discussed the architecture of Prometheus Alerting.

**The Alerting Flow:**
1. **Alerting Rules:** Written in YAML, defining mathematical conditions (e.g., `if container_cpu > 80%`).
2. **The `for` Clause:** Crucial to prevent false alarms. (e.g., `for: 5m` means the CPU must stay above 80% for 5 continuous minutes before triggering).

**The 3 States of an Alert:**
1. 🟢 **Inactive:** The metric is normal. No rules are breached.
2. 🟡 **Pending:** The metric breached the threshold, but the `for` duration has not finished yet.
3. 🔴 **Firing:** The metric stayed above the threshold for the entire `for` duration. The alert is triggered!

**Labels & Annotations:**
- *Labels:* Used to route the alert (e.g., `severity: critical` routes to PagerDuty, `severity: warning` routes to Slack).
- *Annotations:* Descriptive data for humans (e.g., `description: "The Nginx container is out of memory!"`).

**Alertmanager:** 
Prometheus doesn't send emails itself. It sends "Firing" alerts to **Alertmanager**, which deduplicates the alerts, groups them together, and routes them to endpoints like Gmail, Slack, or Webhooks.
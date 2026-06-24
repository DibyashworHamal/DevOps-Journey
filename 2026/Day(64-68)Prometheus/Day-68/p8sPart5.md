## Day 68: Prometheus Alerting Rules, Alertmanager & Slack Integration (Jun 24, 2026)

### 🚨 1. Setting Up Prometheus Alerting Rules
Prometheus needs to know *what* to look for. We configured this using a `rules.yml` file.
- **Created `rules.yml`:** Defined specific mathematical conditions (e.g., "Trigger an alert if a target is down for more than 1 minute").
- **Linked to Prometheus:** Updated `prometheus.yml` to include the `rule_files` block so the server loads our custom rules.
- **Verification:** Navigated to the **Alerts** tab in the Prometheus Web UI and successfully saw our newly created rules in the `Inactive` state.

### 🔔 2. Installing & Configuring Alertmanager
Prometheus generates the alerts, but **Alertmanager** handles grouping, deduplication, and routing them to external services (like Email, PagerDuty, or Slack).

**Step-by-Step Installation:**
1. Wrote `install_alertmanager.sh` to download binaries and set up the `alertmanager` system user.
2. Wrote `alertmanager.service` to run it as a persistent Linux daemon.
3. Created the default `alertmanager.yml` configuration file.
4. Executed the script and started the service.
5. **Verification:** Accessed the Alertmanager UI via `http://<VM-1-IP>:9093`.

**Linking Prometheus to Alertmanager:**
Edited `/etc/prometheus/prometheus.yml` and configured the `alerting` block:
```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["localhost:9093"]
```
*Restarted Prometheus to apply the changes.*

### 💬 3. Slack Webhook Integration (The Magic)
We configured Alertmanager to send real-time notifications directly to a Slack channel!

1. **Slack Setup:** Created a new Slack workspace and a dedicated `#server-alerts` channel.
2. **Webhook Generation:** Navigated to the Slack API dashboard (`api.slack.com/messaging/webhooks`), created a new app, and generated an **Incoming Webhook URL**.
3. **Alertmanager Routing:** Edited `/etc/alertmanager/alertmanager.yml`:
   ```yaml
   route:
     receiver: 'slack-notifications'

   receivers:
     - name: 'slack-notifications'
       slack_configs:
         - api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/TOKEN'
           channel: '#server-alerts'
   ```
4. Restarted Alertmanager (`sudo systemctl restart alertmanager`).

### 💥 4. Chaos Testing the Pipeline
To ensure the pipeline worked, we intentionally broke our environment!
- **Action:** Stopped the `cAdvisor` Docker container on the target VM.
- **Observation 1:** In the Prometheus UI, the target went RED.
- **Observation 2:** The Alert shifted from `Inactive` ➡️ `Pending` ➡️ `Firing`.
- **The Magic:** A few seconds later, my phone and desktop pinged! A detailed, formatted alert message automatically appeared in my Slack channel warning that the container was down. 
- *Once I restarted the container, Slack automatically received a "RESOLVED" notification!*

### 📊 5. Introduction to PromQL
Wrapped up the day by querying our metrics using **PromQL (Prometheus Query Language)**.
- Explored time-series queries to filter specific instance data (e.g., `up{job="ubuntu-worker-node"}`).
- Learned how to graph CPU usage and memory spikes dynamically in the Prometheus interface.
## Day 69: Advanced Data Visualization with Grafana (Jun 25, 2026)

### 📊 1. Introduction to Grafana
While Prometheus excels at collecting and storing time-series data, its native UI is very basic. 
- **What is Grafana?** An open-source, multi-platform analytics and interactive visualization web application.
- **Why we need it:** It provides charts, graphs, and alerts for the web when connected to supported data sources (like Prometheus, InfluxDB, or Elasticsearch). It translates complex PromQL queries into beautiful, readable dashboards.

### 🛠️ 2. Installing & Securing Grafana
We deployed Grafana directly onto our existing Monitoring Server (VM-1), running alongside Prometheus.

**Installation Steps:**
1. Added the Grafana APT repository and GPG keys.
2. Ran `sudo apt update && sudo apt install grafana -y`.
3. Started and enabled the daemon: `sudo systemctl enable --now grafana-server`.

**Initial Setup & Security:**
- Grafana runs on port `3000` by default.
- Browsed to `http://<VM-1-IP>:3000`.
- Logged in using default credentials (`admin` / `admin`).
- *Security Best Practice:* Immediately forced a password change on the first login to secure the dashboard.

### 🔌 3. Configuring the Data Source
Grafana is an empty shell until you feed it data. We connected it to our Prometheus database.
1. Navigated to **Connections** ➡️ **Data Sources** ➡️ **Add Data Source**.
2. Selected **Prometheus**.
3. Set the HTTP URL to `http://localhost:9090` (since they are running on the same VM).
4. Clicked **Save & Test** and received the glorious `Data source is working` green checkmark! ✅

### 🪄 4. Importing Community Dashboards (The Magic)
Instead of building complex dashboards from scratch, DevOps engineers leverage the open-source community by importing pre-configured dashboard JSONs using simple ID numbers.

**A. Monitoring the VM (Node Exporter):**
- Clicked **Import Dashboard**.
- Entered the famous community Dashboard ID for Node Exporter (e.g., `1860`).
- Selected our Prometheus Data Source.
- *Result:* Instantly generated a massive, dynamic dashboard showing CPU usage, RAM, Disk I/O, and Network traffic for our Ubuntu VM!

**B. Monitoring Docker Containers (cAdvisor):**
- Imported the Dashboard ID for cAdvisor (e.g., `14282` or `193`).
- *Result:* The dashboard populated with real-time analytics of our running Docker containers. We could visually track exactly how much memory and CPU each specific container was consuming!

### 🔍 5. Exploring Grafana Features
We took a deep dive into the UI components:
- **Panels:** The individual graphs (Speedometers, Time-Series lines, Gauges, Heatmaps).
- **Rows:** Collapsible sections to organize panels.
- **Variables & Templating:** Dropdown menus at the top of the dashboard that allow us to switch the view between different VMs or containers dynamically without rewriting queries.
- **Time Range:** Zooming in on the last 5 minutes of a CPU spike or zooming out to see 7 days of historical trends.
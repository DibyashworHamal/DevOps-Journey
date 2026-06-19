## Day 64: SRE Fundamentals, Observability & Prometheus Architecture (Jun 19, 2026)

### 👁️ 1. Deep Dive into Observability
Monitoring tells you *if* a system is broken. Observability tells you *why* it is broken. We explored the **Four Pillars of Observability**:
1. **Metrics:** Numerical data measured over time (e.g., CPU usage is 85%, memory is 2GB).
2. **Logs:** Immutable, timestamped records of discrete events (e.g., "User A logged in at 10:00 AM").
3. **Traces:** The end-to-end journey of a single user request as it travels across different microservices.
4. **Profiles:** Deep, code-level performance insights (e.g., tracking memory leaks in a Java application).

### ⚖️ 2. The Reliability Hierarchy (SRE Concepts)
To manage system health professionally, we use the Site Reliability Engineering (SRE) hierarchy:
- **SLA (Service Level Agreement):** The business contract with the customer. (e.g., "We guarantee 99.9% uptime, or we pay you a penalty").
- **SLO (Service Level Objective):** The internal goal set by the engineering team to stay safe. (e.g., "We aim for 99.95% uptime so we don't breach the SLA").
- **SLI (Service Level Indicator):** The actual, real-time measurement. (e.g., "Our current uptime is 99.98%").

### 🌟 3. The DevOps "Golden Rule of Nines"
System availability is measured in "Nines." Every extra "9" costs exponentially more money to achieve.
- **2 Nines (99%):** ~3.65 days of downtime per year.
- **3 Nines (99.9%):** ~8.7 hours of downtime per year.
- **4 Nines (99.99%):** ~52 minutes of downtime per year.
- **5 Nines (99.999%):** ~5 minutes of downtime per year (The "Holy Grail" of high availability).

### 🔥 4. Introduction to Prometheus
Prometheus is an open-source, Cloud Native Computing Foundation (CNCF) systems monitoring and alerting toolkit. 
- **Features:** It uses a multi-dimensional data model, a highly flexible query language (**PromQL**), and relies on a **pull-based** HTTP model rather than pushing data.

### 🏗️ 5. Prometheus Architecture (Diagram Breakdown)
We dissected the official Prometheus architecture diagram to understand data flow:

1. **Prometheus Server (The Core):**
   - **Retrieval:** Actively *pulls* (scrapes) metrics from target servers via HTTP.
   - **TSDB (Time Series Database):** Stores the scraped metrics on a local HDD/SSD based on timestamps.
   - **HTTP Server:** Accepts queries via PromQL.
2. **Prometheus Targets & Exporters:**
   - Instead of installing agents, we use **Exporters** (like Node Exporter for Linux VMs) that expose a `/metrics` endpoint for Prometheus to pull from.
3. **Service Discovery:**
   - Prometheus dynamically finds new targets (like auto-scaled K8s pods) using native integrations like Kubernetes API or `file_sd`.
4. **Pushgateway:**
   - Used for short-lived batch jobs that don't live long enough for Prometheus to pull from them. The job pushes metrics here, and Prometheus pulls from the gateway.
5. **Alertmanager:**
   - Prometheus evaluates rules and sends alerts to Alertmanager, which deduplicates, groups, and routes them to receivers like **Email, Slack, or PagerDuty**.
6. **Data Visualization:**
   - We use the native Prometheus Web UI for debugging, or connect **Grafana** via API to create beautiful, production-ready dashboards.
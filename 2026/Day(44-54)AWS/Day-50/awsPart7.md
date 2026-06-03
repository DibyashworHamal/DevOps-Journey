## Day 50: AWS CloudWatch, SNS Alerts & Automated EC2 Remediation (May 25, 2026)

### 👁️ 1. Introduction to Cloud Observability
We took a deep dive into **Amazon CloudWatch**, the native monitoring and observability service for AWS.
- **Metrics:** Data about system performance (e.g., CPU Utilization, Network In/Out).
- **Alarms:** Triggers that watch a single metric and perform one or more actions based on the value relative to a threshold.
- **Amazon SNS (Simple Notification Service):** A highly available, secure, pub/sub messaging service used to send emails, SMS, or trigger external HTTP endpoints.

### 🏗️ 2. Infrastructure Setup & Baseline Monitoring
- **Provisioning:** Launched a fresh EC2 instance using the `t2.nano` family (ultra-lightweight, 1 vCPU, 0.5 GiB RAM).
- **Connection:** SSH'd into the instance from the local laptop terminal.
- **Baseline Check:** Ran the `htop` command to monitor background processes and confirmed the CPU utilization was idling at ~0.0%.

### 🚨 3. Configuring the CloudWatch Alarm & SNS Topic
We configured CloudWatch to act as our automated system administrator.

**A. Metric Selection:**
- Navigated to CloudWatch ➡️ Alarms ➡️ Create Alarm.
- Metric: *EC2 > Per-Instance Metrics > CPU Utilization* (Selected my `t2.nano` instance).
- Condition: Static, Greater/Equal (`>=`), Threshold: `70%`.

**B. Action 1: SNS Email Notification:**
- Trigger state: `In alarm`.
- Created a new SNS Topic named `dip_cpu_utilization`.
- Added my email endpoint (`hamaldivyashwor2057@gmail.com`).
- *Important Verification Step:* Navigated to the AWS SNS Dashboard (status: Pending), opened my Gmail, and clicked **Confirm Subscription** to authenticate the pub/sub connection.

**C. Action 2: EC2 Automated Remediation:**
- Added a secondary EC2 Action.
- Trigger state: `In alarm`.
- Action: **Stop this instance**. (This ensures that if a server is hijacked or stuck in an infinite loop, it shuts down before running up a massive AWS bill!).

### 💥 4. The Chaos Engineering Lab (Stress Testing)
To test our automation, we intentionally broke the server!

**Step 1: Install Stress Testing Tools**
```bash
sudo apt update
sudo apt install stress htop -y
```
**Step 2: Spike the CPU**
```bash
stress -c 4 -t 300 &
```
(Explanation: -c 4 spawns 4 workers spinning on sqrt(), -t 300 runs it for 300 seconds/5 mins, and & runs it in the background)

**Step 3: Observation & Verification**
- Checked htop in the terminal: CPU immediately spiked to 100%.
- Waited exactly 5 minutes (the default CloudWatch polling interval).
- The Magic: My SSH terminal session froze and disconnected.
- Checked Gmail: Received an automated AWS SNS Alert warning me of the CPU spike!
- Checked EC2 Dashboard: The instance state had automatically changed from Running to Stopped without me clicking a single button!

###  5. FinOps & Cleanup

Practicing strict cloud cost management, we successfully deleted the CloudWatch alarm and the SNS topic, and signed out of the AWS Console to ensure zero hidden charges.
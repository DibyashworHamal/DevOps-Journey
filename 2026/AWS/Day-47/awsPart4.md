## Day 47: EC2 Deep Dive, Security Groups & Network Troubleshooting (May 19, 2026)

### ☁️ 1. Provisioning an EC2 Instance (Step-by-Step)
Navigated the AWS Console to launch a cloud server from scratch.
- **Name & Tags:** Set logical names (e.g., `IAM_UserName`) for billing and identification.
- **AMI (Amazon Machine Image):** Chose Ubuntu Server 24.04 LTS.
- **Instance Type:** `t3.micro` (Free Tier eligible).
- **Key Pair:** Attached the `.pem` key generated previously.
- **VPC & Subnets:** Explored Virtual Private Clouds (VPC). We purposefully deleted the Default VPC and recreated it to understand how AWS isolates networks. Set Auto-assign Public IP to `Enable`.
- **Security Group (Firewall):** Created a new SG allowing **SSH (Port 22)** strictly from `My IP` for security.

### 📊 2. Exploring the EC2 Dashboard
Once the instance launched (in seconds!), we analyzed the management tabs:
- **Details:** Public IPv4, Private IPv4, DNS names, and AMI IDs.
- **Security:** Inbound/Outbound rules attached to the instance.
- **Networking:** Subnet IDs, VPC IDs, and Network Interfaces (ENI).
- **Storage:** Attached EBS (Elastic Block Store) volumes.
- **Status & Alarms:** System reachability checks and CloudWatch alarms.
- **Monitoring:** CPU utilization, Disk Read/Write, and Network In/Out graphs.

### 🔐 3. Connecting via SSH & The `chmod 400` Error
AWS offers multiple connection methods (EC2 Instance Connect, Session Manager, Serial Console). We used the traditional **SSH Client**.

**The Security Warning:**
When running `ssh -i key.pem ubuntu@<Public-IP>`, the connection was rejected with a "WARNING: UNPROTECTED PRIVATE KEY FILE!" error.
- **The Fix:** AWS requires private keys to be heavily restricted. 
- **Command:** `chmod 400 key.pem` (Changes permissions so *only* the owner can read the file, and no one can write/execute it).
- *Result:* SSH connection successful!

### ⚡ 4. Cloud Speed vs. Local VM
Ran `sudo apt update` and `sudo apt install apache2`. The download and installation finished in a fraction of a second due to AWS's massive internet backbone bandwidth (often 10+ Gbps), highlighting the massive performance gap between Local VMs and Cloud infrastructure.

### 🕵️ 5. Network Troubleshooting: Timed Out vs. Refused
This was the most critical engineering lesson of the day.

**Scenario A: `ERR_CONNECTION_TIMED_OUT`**
- *Action:* Tried to browse the Public IP in Chrome.
- *Cause:* The AWS Security Group was only allowing Port 22 (SSH). It silently dropped Port 80 (HTTP) traffic.
- *Fix:* Edited the Security Group in the AWS Console to add an Inbound Rule for HTTP (Port 80) from `0.0.0.0/0` (Anywhere). The webpage instantly loaded!

**Scenario B: `ERR_CONNECTION_REFUSED`**
- *Action:* Inside the VM, ran `sudo systemctl stop apache2`, then refreshed the browser.
- *Cause:* The Firewall (Security Group) let the traffic through, but there was no Web Server running on Port 80 to "answer the door." The OS actively refused the connection.

### 🗑️ 6. Amazon Machine Images (AMIs) & Lifecycle
- **AMIs:** The blueprint for the instance. You can create "Private AMIs" to save your fully configured server (with Apache already installed) to launch duplicates later!
- **Lifecycle Cleanup:** We practiced **Terminating** the instance at the end of the lab to ensure we don't incur AWS charges.
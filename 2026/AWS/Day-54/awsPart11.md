## Day 54: High Availability (Auto Scaling & ELB), `appspec.yml` & CodePipeline (Jun 3, 2026)

### 🚀 1. EC2 Launch Templates & Images
To achieve automation, we cannot manually configure EC2 instances one by one.
- **AMIs (Images):** The blueprint of the OS and software.
- **Launch Templates:** A saved configuration that includes the AMI, Instance Type, Key Pair, Security Groups, and Network settings. It eliminates repetitive clicking and is mandatory for modern Auto Scaling Groups.

### ⚖️ 2. Auto Scaling Architecture (Vertical vs. Horizontal)
Cloud elasticity means matching server capacity to user demand dynamically.
- **Vertical Scaling (Scale Up/Down):** Increasing the power of a single machine (e.g., upgrading from `t3.micro` (1GB RAM) to `t3.large` (8GB RAM)). *Drawback:* Requires downtime and has a hardware limit.
- **Horizontal Scaling (Scale Out/In):** Adding or removing identical instances (e.g., going from 1 web server to 10 web servers). *Advantage:* Zero downtime, infinite scalability, and highly available. **(This is what AWS Auto Scaling does!)**

### 🔀 3. Elastic Load Balancing (ELB)
When you have multiple horizontally scaled servers, you need a Load Balancer to distribute incoming traffic evenly across them so no single server crashes. AWS offers 4 types:
1. **Application Load Balancer (ALB):** Operates at Layer 7 (HTTP/HTTPS). Best for web applications and microservices (can route traffic based on URL paths).
2. **Network Load Balancer (NLB):** Operates at Layer 4 (TCP/UDP). Best for ultra-high performance and extreme low latency (Millions of requests/sec).
3. **Gateway Load Balancer (GLB):** Operates at Layer 3 (Network). Used for deploying third-party virtual firewalls.
4. **Classic Load Balancer (CLB):** Legacy (Layer 4/7). Rarely used in modern architectures.

### 📜 4. Deep Dive: The `appspec.yml` File
While `buildspec.yml` is for CodeBuild, `appspec.yml` is the instruction manual for AWS CodeDeploy. It tells the CodeDeploy Agent exactly how to handle the deployment on the EC2 instance.
**Core Hooks:**
- `BeforeInstall`: Tasks to run before copying files (e.g., stopping Apache).
- `Install`: Copies files to the destination (`/var/www/html`).
- `AfterInstall`: Configuration tasks (e.g., changing file permissions).
- `ApplicationStart`: Starting the services (`systemctl start apache2`).

### 🛠️ 5. Assignment 1: CodeDeploy Agent via User Data
Instead of SSHing into the EC2 instance to install the CodeDeploy agent, we automated it at boot time using **EC2 User Data** (a bash script executed by cloud-init upon instance launch).
```bash
#!/bin/bash
apt update -y
apt install ruby-full wget -y
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto > /tmp/logfile
systemctl start codedeploy-agent
```
- Verified the codedeploy-agent service was running.
- Navigated to CodeDeploy, created an Application, created a Deployment Group targeting the instance tags, and successfully executed a Deployment!

### ♾️ 6. Assignment 2: AWS CodePipeline (The Orchestrator)
The final piece of the AWS CI/CD puzzle! CodePipeline ties everything together.
- **Source Stage:** Triggered automatically by a push to GitHub / CodeCommit.
- **Build Stage:** Passed the code to CodeBuild (buildspec.yml) for compilation/testing.
- **Deploy Stage:** Passed the artifacts to CodeDeploy (appspec.yml) to update the live EC2 instances.
- **Result:** Achieved a fully automated, AWS-native End-to-End Pipeline!
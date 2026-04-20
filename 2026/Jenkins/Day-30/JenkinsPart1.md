## Day 30: Continuous Integration (CI) & Jenkins Architecture (Apr 20, 2026)

### 🔄 1. What is Continuous Integration (CI)?
Continuous Integration is a DevOps software development practice where developers regularly merge their code changes into a central repository (like GitHub), after which automated builds and tests are run.
- **The Goal:** Find and fix bugs quicker, improve software quality, and reduce the time it takes to validate and release new software updates.

### 🤵‍♂️ 2. What is Jenkins?
Jenkins is the most popular open-source automation server in the world. Written in Java, it provides hundreds of plugins to support building, deploying, and automating any project.
- **Key Features:** 
  - Massive Plugin Ecosystem (Integrates with Git, Docker, Maven, Slack, etc.).
  - Distributed Architecture (Master/Agent setup for heavy workloads).
  - Open Source and highly customizable.

### 🏗️ 3. Jenkins Architecture (Controller - Agent)
Jenkins uses a distributed architecture to handle massive enterprise workloads.
- **Jenkins Controller (Master):** The central control unit. It schedules build jobs, dispatches them to Agents, monitors their progress, and serves the Web UI. *It does not run the heavy builds itself!*
- **Jenkins Agent (Slave):** The worker nodes (Windows, Linux, or Docker containers). They receive instructions from the Controller, execute the actual build/test scripts, and send the results back.

### 🛠️ 4. Practical Lab: Installing Jenkins on Ubuntu VM
Following the official documentation (`jenkins.io`), we installed Jenkins from scratch.

**Step 1: Install Prerequisites (Java)**
Jenkins is a Java application, so the JVM is strictly required.
```bash
sudo apt update
sudo apt install fontconfig openjdk-17-jre -y
java -version  # Verify Java installation
```
**Step 2: Add Jenkins Repository and Key**
```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null  
```
**Step 3: Install & Start Jenkins**
```bash  
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl enable --now jenkins
sudo systemctl status jenkins  # Verify service is running
```
### 🔓 5. Unlocking & Configuring Jenkins
By default, Jenkins runs on port 8080.

**1.Browse UI:** Accessed http://<VM_IP_ADDRESS>:8080 from the Windows host browser.

**2.Unlock Jenkins:** Fetched the initial administrator password from the server.
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
**3.Setup:**
  -  Pasted the password into the Web UI.
  - Selected "Install Suggested Plugins" (Git, Pipeline, Credentials, etc.).
  - Created the First Admin User account.
  
**4.Dashboard Exploration:** Discussed the core UI features:
- **New Item:** To create Freestyle projects or Pipelines.
- **Manage Jenkins:** The control room for System Configuration, Global Tools (Java/Git paths), Plugin Management, and Node (Agent) administration.
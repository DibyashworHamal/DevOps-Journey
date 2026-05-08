## Day 38: Jenkins Distributed Builds & Master-Agent Architecture (May 8, 2026)

### 🏗️ 1. The Need for Distributed Builds
Running builds on the Jenkins Master node is a bad practice in production. 
- **Security:** Builds have access to the master's file system.
- **Performance:** Heavy tasks (like `mvn clean package`) consume high CPU/RAM, which can crash the Jenkins UI.
- **Solution:** A Master-Agent (Controller-Worker) architecture where the Master orchestrates and schedules jobs, but the remote Agent VMs execute the actual work.

### ⚙️ 2. Configuring a New Jenkins Node (Agent)
We attached a completely separate Ubuntu VM to our Jenkins Master.

**Step-by-Step UI Configuration:**
1. Navigated to *Manage Jenkins ➡️ Nodes ➡️ New Node*.
2. **Name:** `worker-node-1` (Type: Permanent Agent).
3. **Number of Executors:** `2` (Allows the node to run 2 concurrent jobs).
4. **Remote Root Directory:** `/home/vagrant` (Where Jenkins will create the workspace on the remote VM).
5. **Labels:** `maven-node` (Crucial for routing specific jobs to this specific machine).
6. **Usage:** "Use this node as much as possible" or "Only build jobs with label expressions matching this node".
7. **Launch Method:** Via SSH. Configured Host Key Verification Strategy and provided SSH credentials.

### 🛠️ 3. Agent VM Preparation
For the Agent to execute our pipeline, it needs the required tools installed locally. 
SSH'd into the new Agent VM and installed the dependencies:
```bash
sudo apt update
sudo apt install openjdk-21-jdk maven -y
```
### ✅ 4. Testing the Connection
Created a simple Freestyle Job to verify communication.
- Checked "Restrict where this project can be run" and typed our new label (maven-node).
- Added a simple Execute Shell: echo "Hello from the new Agent Node!"
- Verified in the Console Output that the job successfully executed remotely on the new VM.

### 📜 5. Multi-Node Declarative Pipeline (Jenkinsfile)
The true magic happens when we delegate different stages of a single pipeline to different servers! We modified our existing Jenkinsfile to route the Maven build to the new agent, while keeping other tasks elsewhere.
```groovy
pipeline {
    // 'agent none' at the top level forces us to declare agents per stage
    agent none 
    
    stages {
        stage('Checkout Code') {
            agent any
            steps {
                checkout scm
            }
        }
        
        stage('Maven Build on Agent') {
            // This stage runs EXCLUSIVELY on the new VM!
            agent { label 'maven-node' }
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Deploy') {
            agent any
            steps {
                echo 'Deploying artifact...'
            }
        }
    }
}
```
### 🎯 6. Execution & Verification
- Pushed the updated Jenkinsfile to GitHub.
- Triggered the build in Jenkins.
- Result: The console output explicitly showed Jenkins hopping between machines. It checked out the code on the Master, transferred execution to the Agent VM for the heavy Maven build, and securely utilized the /home/vagrant/workspace directory on the remote server!
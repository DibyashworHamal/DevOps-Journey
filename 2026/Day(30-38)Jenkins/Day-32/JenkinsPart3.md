## Day 32: End-to-End CI Pipeline (GitHub ➡️ Jenkins ➡️ Docker ➡️ Harbor) (Apr 23, 2026)

### 🏗️ 1. The CI Pipeline Architecture
Today, we built a fully automated Continuous Integration pipeline spanning multiple tools and virtual machines.
- **VCS:** GitHub (Hosts the Source Code & Dockerfile).
- **CI Server:** Jenkins (Running on VM 1 - Pulls code, executes builds).
- **Containerization:** Docker (Packages the application).
- **Private Registry:** Harbor (Running on VM 2 - Securely stores the final Docker image).

### 🛠️ 2. Pre-Flight Checks & Version Control
Before automating, an engineer must verify the code manually to prevent broken builds in the pipeline.
1. Created a Node.js application alongside an optimized `Dockerfile`.
2. **Manual Test:** Ran `docker build` manually on the VM to ensure there were no syntax errors, then deleted the test image to keep the environment clean.
3. Pushed the entire application code to a new remote repository on GitHub.

### 🔐 3. The "Permission Denied" Fix (Jenkins & Docker)
By default, Jenkins runs scripts as the `jenkins` user, which does not have root privileges to run the Docker daemon. 
**The Fix:** We must add both the `jenkins` and `vagrant` users to the `docker` group.
```bash
sudo usermod -aG docker jenkins
sudo usermod -aG docker vagrant
sudo systemctl restart jenkins
sudo systemctl restart docker
```
### ⚙️ 4. Jenkins Freestyle Job Configuration
Configured Jenkins to act as the automation engine.

- **A. Source Code Management (SCM):**
- Selected Git.
- Pasted the GitHub Repository URL.
- Set Branch Specifier to */main.
- **B. Build Steps (Execute Shell):**
Wrote a Bash script inside Jenkins to handle the deployment logic.
```bash
#!/bin/bash
IMAGE_NAME="harbor.local/library/my-node-app:latest"

echo "==== Building Docker Image ===="
docker build -t $IMAGE_NAME .

echo "==== Pushing to Private Harbor Registry ===="
# Assuming docker login to harbor.local was previously configured via credentials
docker push $IMAGE_NAME

echo "==== Cleaning up local workspace ===="
docker image rm $IMAGE_NAME
```
### ✅ 5. Execution & Verification
- Clicked Build Now in the Jenkins UI.
- **Console Output Analysis:** Watched Jenkins successfully:
     - Clone the repository from GitHub into its workspace.
     - Execute the docker build command layer by layer.
     - Authenticate and push the final image over the network to the Harbor Registry running on VM 2.
-Logged into the Harbor Web UI on VM 2 and verified the image was securely stored and scanned!

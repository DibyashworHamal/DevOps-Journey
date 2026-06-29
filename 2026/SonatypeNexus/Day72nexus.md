## Day 72: Software Artifactory Management & Sonatype Nexus Integration (Jun 29, 2026)

### 📦 1. What is a Software Artifactory?
An Artifactory (or Artifact Repository Manager) is a dedicated server that securely stores binary files (artifacts) produced during the build process (e.g., `.war`, `.jar`, Docker images, `npm` packages).
- **GitHub vs. Nexus:** GitHub is for Source Code (human-readable). Nexus is for Compiled Artifacts (machine-readable binaries ready for deployment).
- **Why we need it:** It provides version control for binaries, dependency caching, and a secure central hub for deployment tools (like Ansible or CodeDeploy) to pull the final application files.

### 🛠️ 2. Provisioning Sonatype Nexus on Ubuntu
Instead of a manual setup, I utilized an automated Bash script to provision a fresh VM as a dedicated Nexus Server.

**The Setup Process:**
1. Installed Java (Nexus requires JRE 8/11).
2. Downloaded the latest Nexus tarball (`wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz`).
3. Extracted it into `/opt/nexus`.
4. Created a dedicated `nexus` Linux user for security.
5. Configured a `nexus.service` systemd file to run it as a background daemon.
6. Started the service and retrieved the initial admin password from `/opt/sonatype-work/nexus3/admin.password`.

### 🗂️ 3. Nexus UI & Repository Creation
- Accessed the UI via `http://<Nexus-VM-IP>:8081`.
- Changed the default admin password.
- **Repository Creation:** Navigated to *Repositories* and created a new **maven2 (hosted)** repository named `my-java-release-repo`. This specific repository will host our compiled `.war` files.

### ⚙️ 4. Jenkins Configuration for Nexus
Before writing the pipeline, Jenkins needed to know how to talk to Nexus.
1. **Plugins:** Installed the `Nexus Artifact Uploader` plugin in Jenkins.
2. **Credentials:** Added the Nexus admin username and password into Jenkins Global Credentials to ensure secure, passwordless authentication during the pipeline run.

### 📜 5. Updating the `Jenkinsfile`
We added a brand new stage to our declarative pipeline to push the artifact to Nexus immediately after the Maven build and SonarQube quality gate stages.

```groovy
        stage('Upload Artifact to Nexus') {
            steps {
                script {
                    nexusArtifactUploader(
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        nexusUrl: '<NEXUS_VM_IP>:8081',
                        groupId: 'com.dibyashwor',
                        version: "${env.BUILD_NUMBER}", // Dynamically versions the artifact
                        repository: 'my-java-release-repo',
                        credentialsId: 'nexus-credentials-id',
                        artifacts: [
                            [artifactId: 'my-webapp',
                             classifier: '',
                             file: 'target/my-webapp.war',
                             type: 'war']
                        ]
                    )
                }
            }
        }
```

### ✨ 6. The Execution & "Magic" Output
1. Pushed the updated `Jenkinsfile` and Java source code to GitHub.
2. Created a new Pipeline Job in Jenkins pointing to the GitHub repo.
3. Clicked **Build Now**.
4. **The Magic:** Jenkins successfully pulled the code, compiled it, passed the security checks, and executed the Nexus upload stage. 
5. **Verification:** Logged into the Nexus Web UI, navigated to the `my-java-release-repo` browse section, and saw the `my-webapp.war` file safely stored, perfectly versioned with the Jenkins build number!
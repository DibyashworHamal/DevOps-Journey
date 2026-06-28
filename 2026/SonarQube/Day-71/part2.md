## Day 71: DevSecOps Integration - Jenkins, Maven & SonarQube Quality Gates (Jun 28, 2026)

### 🛡️ 1. The DevSecOps Pipeline Architecture
Today, we integrated Continuous Inspection into our CI/CD pipeline. The goal: If the code has bugs, vulnerabilities, or bad formatting, the pipeline should fail automatically before deployment.
- **Source Code:** A Java Maven Project hosted on GitHub.
- **CI Server:** Jenkins.
- **Static Code Analysis (SAST):** SonarQube Server.

### ⚙️ 2. Jenkins Configuration for SonarQube
Before updating the `Jenkinsfile`, we had to teach Jenkins how to talk to SonarQube securely.
1. **Plugins Installed:** Installed the `SonarQube Scanner for Jenkins` plugin.
2. **Authentication:** Generated a secure User Token in the SonarQube UI and added it to Jenkins as a `Secret text` credential.
3. **Server Integration:** Navigated to *Manage Jenkins ➡️ System* and added the SonarQube Server URL (`http://<Sonar-IP>:9000`) and linked the credential token.
4. **Global Tool Configuration:** Configured the SonarQube Scanner tool executable in Jenkins.

### 📜 3. Writing the DevSecOps `Jenkinsfile`
We modified our declarative pipeline to include code linting (Checkstyle) and SonarQube analysis.

```groovy
pipeline {
    agent any
    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('2. Maven Compile & Checkstyle') {
            steps {
                // Compiles the Java code and runs checkstyle to enforce coding standards
                sh 'mvn clean compile checkstyle:check'
            }
        }
        
        stage('3. SonarQube Analysis') {
            steps {
                // Uses the Jenkins-configured SonarQube environment
                withSonarQubeEnv('My-SonarQube-Server') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        
        stage('4. Quality Gate') {
            steps {
                // The pipeline pauses and waits for SonarQube to reply (Pass/Fail)
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('5. Package & Deploy') {
            steps {
                echo "Code passed quality checks! Proceeding to deploy..."
            }
        }
    }
}
```

### 🪄 4. Execution & The "Magic" Output
- Created a new **Pipeline Job** in Jenkins, linked it to the GitHub repository, and clicked **Build Now**.
- **Jenkins Console:** Watched Jenkins successfully execute the Checkstyle Maven goal, authenticate with the remote SonarQube server, upload the compiled source code, and wait for the Quality Gate result.
- **SonarQube Dashboard:** The real magic happened here! Logged into `http://<Sonar-IP>:9000` and saw a massive, detailed report of the Java application:
  - **Bugs:** Highlighted logical errors in the Java code.
  - **Vulnerabilities:** Flagged security risks.
  - **Code Smells:** Pointed out messy, unmaintainable code.
  - **Duplications & Coverage:** Showed exactly how much code was redundant or lacking unit tests.
- *Result:* The pipeline enforced the Quality Gate, proving our automated security checks work flawlessly!
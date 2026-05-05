## Day 37: Pipeline Post-Build Actions & Automated Email Alerts (May 5, 2026)

### 🚦 1. The `post` Block in Declarative Pipelines
The `post` section defines actions that will be run at the end of the pipeline (or at the end of a specific stage). We explored all the available conditions:

| Condition | When does it execute? |
| :--- | :--- |
| `always` | Runs no matter what the pipeline status is. Good for cleaning up workspaces. |
| `success` | Runs ONLY if the pipeline completes successfully (Green). |
| `failure` | Runs ONLY if the pipeline fails (Red). |
| `aborted` | Runs if the pipeline is manually aborted by a user. |
| `unstable` | Runs if the build is unstable (e.g., test failures but compilation succeeded). |
| `unsuccessful`| Runs if the build is *not* a success (combines failure, aborted, and unstable). |
| `changed` | Runs if the current pipeline status is different from the previous run. |
| `fixed` | Runs if the previous build failed/unstable, but this one succeeded. |
| `regression` | Runs if the previous build succeeded, but this one failed/unstable. |
| `cleanup` | Runs after all other post conditions have been evaluated. |

### 🛠️ 2. Practical Implementation in `Jenkinsfile`
We injected the `post` block at the end of our declarative pipeline to test the outputs.

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps { echo 'Building...' }
        }
    }
    post {
        always {
            echo 'This will always run, cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Build completed successfully! 🎉'
        }
        failure {
            echo 'Build failed! 🚨 Check the logs.'
        }
    }
}
```
### 📧 3. Automated Email Notifications
We integrated SMTP (Simple Mail Transfer Protocol) into Jenkins to send real emails to developers based on the build status.

**Step 1: System Configuration**
- Navigated to Manage Jenkins -> System.
- Configured the Extended E-mail Notification / E-mail Notification section with SMTP server details (e.g., smtp.gmail.com, Port 465 or 587).
- Added authentication credentials (App Passwords for security).

**Step 2: Jenkinsfile Email Scripting**

We updated our post block to send dynamic email alerts:
```groovy
post {
        success {
            mail to: 'hamaldivyashwor2057@gmail.com',
                 subject: "SUCCESS: Jenkins Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                 body: "Great news! Your pipeline executed successfully. Check the console output here: ${env.BUILD_URL}"
        }
        failure {
            mail to: 'hamaldivyashwor2057@gmail.com',
                 subject: "FAILURE: Jenkins Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                 body: "Alert! The pipeline failed. Please investigate the logs immediately: ${env.BUILD_URL}"
        }
    }
```
Result: Purposely failed a build and successfully received an alert directly in my Gmail inbox!
### ⚙️ 4. Mastering "Manage Jenkins"
To wrap up our Jenkins module, we did a deep dive into the remaining administrative features:
- **Security:** Managing user authentication and role-based access.
- **System Log:** Troubleshooting Jenkins internal errors.
- **Nodes & Clouds:** Preparing Jenkins for distributed builds across multiple agent VMs.
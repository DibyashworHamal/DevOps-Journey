## Day 53: CodeBuild Observability & AWS CodeDeploy Architectures (Jun 2, 2026)

### 📊 1. CodeBuild Observability & Phase Details
Before moving to deployment, we mastered troubleshooting our CI pipeline using AWS monitoring tools.
- **Phase Details Tab:** AWS CodeBuild visually breaks down the build into distinct lifecycle phases (e.g., `DOWNLOAD_SOURCE`, `INSTALL`, `PRE_BUILD`, `BUILD`, `POST_BUILD`). If a build fails, this tab immediately identifies exactly *which* phase caused the crash.
- **CloudWatch Logs Integration:** CodeBuild ephemeral containers vanish after running, but their console output is permanently saved in **Amazon CloudWatch**. We navigated to CloudWatch Log Groups to analyze raw execution streams, which is critical for debugging complex `npm` or `maven` errors retrospectively.

### 🚀 2. Deep Dive: AWS CodeDeploy
AWS CodeDeploy is a fully managed deployment service that automates software deployments to compute services like Amazon EC2, AWS Fargate, AWS Lambda, and even on-premises servers.
- **The Goal:** To eliminate manual SSH-and-copy deployments, maximize application uptime, and ensure consistent, repeatable rollouts.
- **The Agent:** To deploy to an EC2 instance, the target server must have the **CodeDeploy Agent** installed and running.

### 🔀 3. Deployment Types (Architectures)
Understanding how traffic and servers are handled during an update.

| Deployment Type | Description | Pros & Cons |
| :--- | :--- | :--- |
| **In-Place Deployment** | The application on the existing EC2 instance is stopped, the latest revision is installed, and the new version is started. | **Pros:** Cost-effective (uses existing servers).<br>**Cons:** Application downtime occurs during the update. Difficult to rollback quickly. |
| **Blue/Green Deployment** | A completely new set of instances (Green) is provisioned alongside the old ones (Blue). The new version is installed on Green, tested, and then a Load Balancer switches all user traffic from Blue to Green. | **Pros:** Zero downtime. Instant rollback (just route traffic back to Blue).<br>**Cons:** More expensive (temporarily running double the servers). |

### 🛠️ 4. Practical Lab: Configuring AWS CodeDeploy
We set up the architecture required to push code to a live EC2 server.
1. **IAM Roles:** Created two specific roles.
   - *CodeDeploy Service Role:* Grants CodeDeploy permission to read our target EC2 tags.
   - *EC2 Instance Profile:* Grants the EC2 instance permission to download artifacts from S3/GitHub.
2. **Application Creation:** Created a CodeDeploy Application to act as a container for our deployment groups.
3. **Deployment Group:** Configured a group that targets our specific EC2 instances using **Tags** (e.g., `Environment = Dev`).
4. **Execution:** Initiated a manual deployment, linking our revision from GitHub, and watched the CodeDeploy dashboard track the deployment lifecycle steps (Download, BeforeInstall, Install, AfterInstall, ApplicationStart) in real-time!
## Day 51: AWS Developer Tools Overview & CodeCommit Deep Dive (May 27, 2026)

### 🛠️ 1. High-Level Overview of AWS Developer Tools
AWS provides a native suite of CI/CD services designed to securely host, build, test, and deploy applications without needing third-party tools.
- **AWS CodeCommit:** Fully managed source control service that hosts secure Git-based repositories (AWS's version of GitHub).
- **AWS CodeBuild:** Fully managed continuous integration service that compiles source code, runs tests, and produces ready-to-deploy software packages (AWS's version of Jenkins/Maven).
- **AWS CodeDeploy:** Automates software deployments to a variety of compute services like EC2, Fargate, and Lambda.
- **AWS CodePipeline:** The orchestrator. It builds, tests, and deploys your code every time there is a code change (AWS's version of Jenkins Pipelines).

### 🗄️ 2. Deep Dive: AWS CodeCommit
CodeCommit is a secure, highly scalable, managed source control service.
- **Why use it over GitHub?**
  - Fully integrated with **AWS IAM** for highly granular role-based access control.
  - Data is automatically encrypted at rest using AWS KMS (Key Management Service) and in transit.
  - Keeps proprietary enterprise source code strictly within the AWS Virtual Private Cloud (VPC) boundary.

### 🔐 3. Authentication Mechanisms for CodeCommit
Because CodeCommit is tied to AWS IAM, we cannot just use a standard password. We explored authentication methods:
1. **HTTPS Git credentials:** Generating specific Git usernames and passwords directly from the IAM User Dashboard.
2. **SSH Keys:** Uploading the public SSH key to IAM (which we learned on Day 46) for passwordless access.
3. **AWS CLI Credential Helper:** Using the temporary AWS access keys to authenticate Git commands securely.

### 💻 4. Practical Lab: Pushing Code to AWS CodeCommit
We simulated an enterprise Git workflow using AWS Native tools.

**Step 1: Create the Repository**
- Navigated to the AWS Developer Tools console ➡️ CodeCommit ➡️ Create Repository.
- Named the repository and added a description.

**Step 2: IAM Authentication Setup**
- Went to the IAM Dashboard ➡️ Users ➡️ Security Credentials.
- Generated "HTTPS Git credentials for AWS CodeCommit".
- Saved the `.csv` file containing the generated Username and Password.

**Step 3: Local Git Configuration & Push**
Dropped into the local Ubuntu VM terminal to push our code.
```bash
# Clone the empty AWS repository
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/my-aws-repo

# (Prompted for the IAM-generated Git credentials)

# Navigate into the repo and create a file
cd my-aws-repo
echo "Hello AWS CodeCommit!" > index.html

# Stage, Commit, and Push
git add .
git commit -m "Initial commit to AWS CodeCommit"
git push origin master
```
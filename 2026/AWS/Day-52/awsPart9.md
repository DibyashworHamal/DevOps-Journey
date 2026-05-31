## Day 52: AWS CodeBuild, `buildspec.yml` & GitHub App Integration (May 29, 2026)

### 🏗️ 1. Deep Dive: AWS CodeBuild
AWS CodeBuild is a fully managed continuous integration service. 
- **No Servers to Manage:** Unlike Jenkins, where we have to maintain the controller and agent VMs, CodeBuild provisions a temporary, isolated Docker container for every build and deletes it immediately after.
- **Pay-as-you-go:** You are charged strictly by the minute for the compute resources your build consumes.
- **Secure:** Natively integrates with AWS IAM and KMS.

### 📜 2. The `buildspec.yml` File
If Jenkins relies on the `Jenkinsfile`, AWS CodeBuild relies on `buildspec.yml`. This YAML file must be placed in the root of the source code repository. We explored the official AWS documentation to understand its architecture.

**The 4 Core Phases of a Buildspec:**
1. `install`: Used for installing runtime environments (like Node.js) and dependencies.
2. `pre_build`: Used for signing in to registries (like ECR/Harbor) or setting up variables.
3. `build`: The actual execution of the code compiling or Docker image building.
4. `post_build`: Used for packaging artifacts or pushing Docker images.

**Example Node.js `buildspec.yml`:**
```yaml
version: 0.2
phases:
  install:
    runtime-versions:
      nodejs: 18
    commands:
      - echo "Installing dependencies..."
      - npm install
  build:
    commands:
      - echo "Running tests and building the app..."
      - npm test || true
  post_build:
    commands:
      - echo "Build phase completed successfully."
artifacts:
  files:
    - '**/*'
```
### 🔗 3. Practical Lab: Connecting CodeBuild to GitHub
Instead of hosting the code in AWS CodeCommit, we simulated a real-world multi-tool enterprise environment by keeping our source code in GitHub and processing the build in AWS.

**Step-by-Step Implementation:**

1. **GitHub Prep:** Created a Node.js project containing our source code, package.json, and our new buildspec.yml file, and pushed it to a public/private GitHub repository.
2. **AWS CodeBuild Setup:**
- Navigated to the CodeBuild Console ➡️ Create Build Project.
- Selected GitHub as the source provider.
3. **The GitHub App Connection:**
- Instead of using a legacy Personal Access Token (PAT), we authenticated securely using the modern AWS Connector for GitHub App. This establishes a highly secure, OAuth-based webhook between GitHub and AWS.
4. **Environment Setup:**
- Chose the Managed Ubuntu operating system image provided by AWS to run our build container.
5. **Execution & Logs:**
- Clicked **Start Build**.
- Watched the live CloudWatch tail logs as AWS dynamically spun up a container, pulled my code from GitHub, parsed the buildspec.yml, installed Node.js dependencies, and successfully completed the build process!    
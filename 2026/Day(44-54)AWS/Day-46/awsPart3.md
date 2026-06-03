## Day 46: Advanced IAM, AWS CLI Integration & EC2 Provisioning (May 18, 2026)

### 🔐 1. Advanced IAM & Security Credentials
We finalized the IAM module by exploring the "Security Credentials" tab, focusing on how different identities authenticate with AWS.
- **Console Access:** Logging in via a web browser using a Username and Password.
- **MFA (Multi-Factor Authentication):** Added a critical layer of security to the console login. We successfully linked a virtual Authenticator App (like Google Authenticator) to generate Time-based One-Time Passwords (TOTP).
- **SSH Public Keys for CodeCommit:** AWS's native Git repository service requires specific SSH keys uploaded to IAM for secure push/pull operations.
- **X.509 Signing Certificates:** Used for specialized authentication, primarily for older AWS SOAP APIs or federated identity integrations.

### 💻 2. Programmatic Access & AWS CLI
DevOps relies on automation, which means our servers need to talk to AWS without a web browser. We do this using **Access Keys** (an Access Key ID and a Secret Access Key).

**Practical Lab: Connecting Local VM to AWS**
1. **Created Access Keys:** Generated a new key pair for my IAM user in the AWS Console. *(Security Rule: Never share the Secret Key or push it to GitHub!)*
2. **Installed AWS CLI:** Installed the Amazon Web Services Command Line Interface on my local Ubuntu VM.
3. **Configured AWS CLI:**
   ```bash
   aws configure
   # Entered Access Key ID
   # Entered Secret Access Key
   # Default region name: us-east-1 (or ap-south-1)
   # Default output format: json
   ```
#### 1. Under the Hood (~/.aws/):
Explored how Linux stores these credentials safely.
- `cat ~/.aws/credentials`: Stores the sensitive Access and Secret keys.
- `cat ~/.aws/config`: Stores default region and output formats.

**AWS CLI Commands Executed:**
```
aws iam list-users    # Returns a JSON list of all IAM users in the account
aws s3 ls             # Lists all S3 Storage buckets
```
### ☁️ 3. Amazon EC2 (Elastic Compute Cloud) Introduction
Transitioned from local Vagrant VMs to globally hosted Cloud VMs!
- **What is EC2?** A web service that provides secure, resizable compute capacity in the cloud.
- **Instance Families Recap:**
  - t & m (General Purpose)
  - c (Compute)
  - r (Memory)
  - p/g (GPU)

### 🚀 4. Practical: Launching My First EC2 Instance
Navigated the comprehensive EC2 Dashboard and provisioned a cloud server.
- **AMI (Amazon Machine Image):** Selected Ubuntu 24.04 LTS (The OS blueprint).
- **Instance Type:** Chose t3.micro (2 vCPUs, 1 GiB RAM) because it is Free Tier eligible!
- **Key Pair:** Generated a new .pem SSH key to securely log into the instance later.
- **Network & Security Groups:** Configured the virtual firewall to allow SSH (Port 22) traffic from my IP.
- **Storage:** Configured standard EBS (Elastic Block Store) SSD volume.
- **Result:** Clicked "Launch Instance" and watched AWS provision a public-facing cloud server in seconds!
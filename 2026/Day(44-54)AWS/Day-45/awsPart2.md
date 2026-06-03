## Day 45: AWS IAM Deep Dive & Cloud Security Governance (May 17, 2026)

### 🔐 1. AWS IAM (Identity and Access Management)
IAM is a global AWS service that helps securely control access to AWS resources. It dictates **Who** (Identity) can do **What** (Authorization) on which **Resource**.
- **Global Service:** IAM is not tied to a specific region (like us-east-1). It applies across the entire AWS account.
- **The IAM Sign-in URL:** IAM users do not log in from the standard AWS root login page. They use a custom 12-digit account alias link: `https://<Account_ID>.signin.aws.amazon.com/console`.

### 👥 2. Users, Groups, and Permissions
We explored the enterprise best practices for structuring cloud access.
- **IAM User:** Represents a person or a service (like Jenkins) interacting with AWS.
- **IAM Group:** A collection of IAM users. 
- **Security Best Practice:** *Never* attach permissions directly to a user! Always create a Group (e.g., `Developers` or `DatabaseAdmins`), attach the permission policies to the Group, and then add the User to the Group. This makes onboarding and offboarding highly scalable.

### 📜 3. IAM Policies
Policies define permissions and are written in **JSON** (JavaScript Object Notation).
They consist of three main parts:
- **Effect:** `Allow` or `Deny` (Deny always trumps Allow).
- **Action:** The API call allowed (e.g., `ec2:StartInstances`, `s3:GetObject`).
- **Resource:** The specific AWS asset the action applies to (e.g., a specific S3 bucket).

### 🔍 4. Advanced Auditing & IAM Dashboard Features
We explored the tools Cloud Architects use to maintain compliance and audit security.
- **Access Advisor:** Shows which AWS services a user or role has access to, and *when they last accessed them*. Crucial for removing unused permissions safely.
- **Access Analyzer:** A proactive security tool that uses mathematical logic to identify resources in your organization that are shared with an external entity. It helps prevent accidental public data exposure.
- **Credential Report:** A downloadable CSV report listing all users in the account and the status of their credentials (e.g., password creation dates, MFA status, access key rotation).

---

### 📚 5. Research Task (Preparation for Tomorrow)
Preparing for our introduction to AWS Compute services.

**i. What is EC2?**
- **Elastic Compute Cloud (EC2):** A web service providing secure, resizable compute capacity (Virtual Machines) in the cloud. It is the backbone of AWS IaaS.

**ii. EC2 Instance Types & Families**
Different workloads require different hardware. AWS groups EC2 instances into "Families":
- **General Purpose (T, M):** Balanced CPU, RAM, and Network. Good for web servers.
- **Compute Optimized (C):** High-performance processors. Good for batch processing and gaming servers.
- **Memory Optimized (R, X):** High RAM. Good for in-memory databases (Redis/Memcached).
- **Storage Optimized (I, D):** High, sequential read/write access. Good for big data.
- **Accelerated Computing (P, G):** Hardware accelerators (GPUs). Good for Machine Learning.

**iii. EC2 Storage Types**
- **EBS (Elastic Block Store):** Persistent network-attached storage. (Data survives if VM shuts down).
- **Instance Store:** Temporary, directly-attached physical storage. Fast, but data is lost if the VM stops (Ephemeral).
- **EFS (Elastic File System):** A shared file system that can be mounted to multiple EC2 instances simultaneously.
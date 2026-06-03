## Day 48: Amazon S3 (Simple Storage Service) & Object Storage Architecture (May 20, 2026)

### 🗄️ 1. What is Amazon S3?
Amazon Simple Storage Service (S3) is an **Object Storage** service that offers industry-leading scalability, data availability, security, and performance. 
- **Traditional Storage vs. S3:**
  - *Traditional (Block/File Storage):* Like your laptop's hard drive (EBS). It requires an Operating System to format it (NTFS/EXT4) and is limited by a fixed maximum size.
  - *S3 (Object Storage):* A flat structure where data is stored as "Objects" inside "Buckets". It does not require an OS, scales infinitely, and is accessed purely via HTTP/REST APIs.

### 🌟 2. Key Features of S3
- **Durability:** Designed for 99.999999999% (11 9's) of data durability.
- **Scalability:** Virtually unlimited storage capacity.
- **Security:** Highly granular access management and encryption by default.
- **Cost-Efficiency:** Multiple storage classes to save money based on data retrieval frequency.

### 🏗️ 3. How S3 Works
- **Buckets:** The root-level folders. **Important:** Bucket names exist in a *Global Namespace*. Your bucket name must be completely unique across ALL AWS accounts in the world!
- **Objects:** The actual files (images, backups, logs). Each object consists of the *Data* itself, *Metadata* (content-type, date modified), and a unique *Key* (the file path).

### 🛠️ 4. Practical Lab: Provisioning a Secure S3 Bucket
We navigated the AWS S3 Console to create an enterprise-standard storage bucket.

**Bucket Configurations Applied:**
- **Bucket Type:** General purpose bucket.
- **Namespace:** Created a globally unique name.
- **Object Ownership (ACLs Disabled):** *Modern Best Practice.* Access Control Lists are legacy. We disabled them so all objects in the bucket are owned by the AWS account, and access is governed strictly by IAM/Bucket Policies.
- **Block Public Access:** Checked `Block all public access`. *Security Rule:* Never make a bucket public unless it is specifically hosting a static website.
- **Bucket Versioning:** Disabled (If enabled, S3 keeps every overwritten version of a file, preventing accidental deletion but increasing storage costs).
- **Encryption:** `SSE-S3` (Server-Side Encryption with Amazon S3 managed keys). Data is automatically encrypted at rest!
- **Bucket Key:** Enabled (Reduces encryption costs).
- **Object Lock:** Disabled (Used for compliance/legal reasons to make files WORM - Write Once, Read Many).

### 📤 5. Object Upload & S3 Dashboard Deep Dive
- Clicked **Upload** and added a test file.
- Explored the **Properties & Destination Details**.
- Analyzed **Storage Classes**:
  - *Standard:* Frequently accessed data (millisecond access).
  - *Intelligent-Tiering:* Automatically moves data to cheaper tiers if untouched.
  - *Glacier:* Cheap, long-term archival storage (takes hours to retrieve).
- Verified the upload was successful and explored the generated Object URL.

### 🗑️ 6. Lifecycle Cleanup
To adhere to FinOps (Financial Operations) best practices and avoid unnecessary AWS billing, we successfully **Emptied** the bucket and then **Deleted** the bucket.
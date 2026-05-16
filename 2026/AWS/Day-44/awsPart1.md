## Day 44: Introduction to Cloud Computing & AWS Foundations (May 16, 2026)

### ☁️ 1. What is Cloud Computing?
Cloud computing is the on-demand delivery of IT resources over the Internet with pay-as-you-go pricing. Instead of buying, owning, and maintaining physical data centers and servers, you access technology services on an as-needed basis from a cloud provider.

**Traditional IT vs. Cloud Computing:**
- **Traditional:** CapEx (Capital Expenditure). You buy servers upfront. Takes weeks to set up. You pay for electricity and maintenance even if the server is idle.
- **Cloud:** OpEx (Operational Expenditure). You rent servers. Takes seconds to set up. You only pay for what you consume. 

**Benefits:** 
Agility, Elasticity (Scale up/down instantly), Cost Savings, and Deploy globally in minutes.

### 🏗️ 2. Cloud Deployment & Service Models
Understanding the architecture of cloud offerings.

**Deployment Models (Where is the cloud?):**
1. **Public Cloud:** Owned by a third-party provider (e.g., AWS). Resources are shared over the internet.
2. **Private Cloud:** Cloud infrastructure dedicated exclusively to one organization (often on-premises).
3. **Hybrid Cloud:** A mix of Public and Private clouds bound together, allowing data/apps to be shared between them.

**Service Models (What are you renting?):**
1. **IaaS (Infrastructure as a Service):** You rent the raw hardware (VMs, Networking, Storage). *Example: AWS EC2.*
2. **PaaS (Platform as a Service):** You rent the environment. The cloud provider manages the OS and runtime; you just upload your code. *Example: AWS Elastic Beanstalk, Heroku.*
3. **SaaS (Software as a Service):** A fully completed product run and managed by the provider. *Example: Gmail, Office 365.*

### 🌍 3. The Big 3 Public Clouds
- **AWS (Amazon Web Services):** The undisputed market leader. First to market, largest service ecosystem.
- **Microsoft Azure:** Strongest in enterprise integrations (Windows Server, Active Directory).
- **GCP (Google Cloud Platform):** Known for Data Analytics, Machine Learning, and Kubernetes (GKE).

### 🛠️ 4. Practical: AWS Account Setup & Access
We transitioned from theory to setting up our own global cloud environments.

**The Payment Gateway (Dollar Card):**
To create an AWS account from Nepal, we need an international payment method. We discussed utilizing a **Prepaid Dollar Card** (issued by Nepali banks like Nabil, Global IME, etc.) which allows seamless international tech subscriptions.

**AWS Free Tier:**
AWS offers a generous free tier for the first 12 months to learn the platform.
- 750 hours/month of EC2 (t2.micro/t3.micro).
- 5GB of S3 Storage.
- 750 hours/month of RDS (Databases).

**Security Best Practice: Root vs. IAM User**
- **Root User:** The email address used to create the account. It has absolute, unrestricted access (including billing). **Rule:** *Only use this to create the account and set up billing. Never use it for daily tasks!*
- **IAM User (Identity and Access Management):** A secondary user created within the account with specific, limited permissions. **Rule:** *Always log in as an IAM user for daily DevOps engineering tasks.*
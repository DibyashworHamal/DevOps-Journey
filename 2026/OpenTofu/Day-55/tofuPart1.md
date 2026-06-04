## Day 55: Infrastructure as Code (IaC) with OpenTofu & AWS Integration (Jun 4, 2026)

### 🏗️ 1. What is Infrastructure as Code (IaC)?
IaC is the process of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.
- **Benefits:** Speed, Consistency (No human error), Version Control, and Reproducibility.

### 🍱 2. Terraform vs. OpenTofu
We discussed the evolution of IaC tools. 
- **Terraform:** The original tool created by HashiCorp.
- **OpenTofu:** An open-source, community-driven fork of Terraform (now part of the Linux Foundation) created after Terraform changed its license to BUSL. OpenTofu maintains 100% compatibility while ensuring the tool remains free and open forever.

### 🛠️ 3. Environment Setup
**Prerequisite:** Ensured `aws cli` was configured with IAM credentials (`aws configure`) so OpenTofu has permission to talk to our AWS account.

**Installation (Ubuntu VM):**
Followed the official OpenTofu repository steps to install the `tofu` binary.
```bash
tofu --version  # Verified installation
```
### 📜 4. The OpenTofu Workflow & .tf Files
We learned that OpenTofu uses the **HCL (HashiCorp Configuration Language)**. We created instance.tf to define our infrastructure.
**Core Commands & Lifecycle:**
1. **tofu fmt:** Automatically formats the code for readability and standardizes indentation.
2. **tofu validate:** Checks the configuration files for internal consistency and syntax errors.
3. **tofu init:** Initializes the working directory. It downloads the required AWS Provider plugins.
 - **Key File:** .terraform.lock.hcl – This file records the exact versions of the providers used, ensuring every team member uses the same plugin versions.
4. **tofu plan:** The "Dry Run." It compares the current state of the cloud with our code and lists exactly what will be created, changed, or destroyed.
5. **tofu apply:** The execution step. It sends the API calls to AWS to build the resources.
6. **tofu destroy:** The cleanup step. Deletes all resources managed by the current configuration.

### 🔍 5. The "Source of Truth": terraform.tfstate
We discussed the most important file in IaC: the State File.
- OpenTofu records every resource it creates in this JSON file.
- It maps your code to the real-world IDs in AWS.
- **Critical Warning:** Never delete this file manually! If you lose the state file, OpenTofu "forgets" what it built, leading to orphaned resources and duplicate billing.

### 🚀 6. Practical Lab: Provisioning EC2 via Code
File: instance.tf   
```hcl
provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "ec2_vm" {
  ami                = "ami-091138d0f0d41ff90"
  instance_type      = "t3.micro"
  availability_zone  = "us-east-1a"
  key_name           = "dip_aws_vm_key"
  vpc_security_group_ids = ["sg-055ebf380703ebd07"]
  tags = {
    name    = "hamaldivyashwor2057@gmail.com"
    project = "DevOps"
  }
}
```
**Verification:** After running tofu apply, we logged into the AWS Console and verified that a brand new VM was running with the exact tags we defined in our script.

### 🔄 7. Portability Test
Created a new directory, copied the .tf file, and ran tofu init. This proved that infrastructure is now **portable code**. We can replicate our entire server setup in a different folder or a different account in seconds!
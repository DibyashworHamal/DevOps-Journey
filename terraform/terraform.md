# Terraform Overview

## Table of Contents
- [What is Terraform?](#what-is-terraform)
- [Why Use Terraform?](#why-use-terraform)
- [Key Benefits](#key-benefits)
- [Core Concepts](#core-concepts)
- [Terraform vs OpenTofu](#terraform-vs-opentofu)
- [Getting Started](#getting-started)

---

## What is Terraform?

Terraform is an open-source **Infrastructure as Code (IaC)** tool developed by HashiCorp. It allows you to define, preview, and deploy infrastructure resources across multiple cloud providers and on-premises environments using a high-level configuration language (HCL - HashiCorp Configuration Language).

Rather than manually provisioning resources through cloud console UIs or writing imperative scripts, Terraform enables you to declaratively define your desired infrastructure state in configuration files. These files serve as version-controlled, executable documentation of your infrastructure.

---

## Why Use Terraform?

### 1. **Infrastructure as Code (IaC)**
   - Write infrastructure configurations in code rather than using point-and-click UIs
   - Treat infrastructure with the same rigor as application code:
     - Version control (Git)
     - Code reviews
     - Testing
     - Collaboration

### 2. **Multi-Cloud Support**
   - Define infrastructure that works across AWS, Azure, Google Cloud, and 50+ other providers
   - Avoid vendor lock-in by using consistent configurations
   - Easy migration between cloud providers

### 3. **Reproducibility**
   - Ensure consistent infrastructure across development, staging, and production environments
   - Eliminate "works on my machine" problems for infrastructure
   - Rapidly spin up identical environments for testing and disaster recovery

### 4. **Automation & Efficiency**
   - Automate repetitive infrastructure provisioning tasks
   - Reduce human error from manual configuration
   - Deploy complex multi-resource infrastructure with a single command

### 5. **Cost Management**
   - Easily identify and destroy unused resources
   - Track infrastructure costs through code review
   - Quickly provision and destroy test/staging environments

---

## Key Benefits

### **Declarative Configuration**
You describe the desired end state (what you want), not the steps to get there. Terraform figures out how to reach that state efficiently.

**Example:**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}
```

### **State Management**
Terraform maintains a state file that represents your current infrastructure. This allows Terraform to:
- Detect changes and track drift
- Plan exact changes before applying them
- Support collaborative infrastructure management

### **Plan Before Apply**
The `terraform plan` command shows exactly what changes will be made before executing them, providing:
- Safety and confidence
- Opportunity to review changes
- Prevention of unexpected modifications

### **Modularity & Reusability**
- Organize infrastructure into reusable modules
- Share modules across projects and teams
- Standardize configurations across your organization

### **Version Control Integration**
- Store infrastructure code in Git alongside application code
- Track all infrastructure changes with commit history
- Enable code review processes for infrastructure changes
- Easy rollback to previous infrastructure states

---

## Core Concepts

### **Resources**
The fundamental building blocks in Terraform. A resource represents an infrastructure component (EC2 instance, RDS database, S3 bucket, security group, etc.).

### **Providers**
Plugins that Terraform uses to interact with different cloud platforms and services. Examples: AWS, Azure, Google Cloud, Kubernetes, Docker, etc.

### **State File**
A JSON file that tracks the current state of your infrastructure. It maps your configuration to real-world resources and enables Terraform to know what exists.

### **Variables & Outputs**
- **Variables**: Input values that make configurations reusable and dynamic
- **Outputs**: Export values from your infrastructure for use by other systems or teams

### **Modules**
Collections of resources organized together as a reusable unit. Modules promote code organization, reusability, and standardization.

### **Backends**
Where Terraform stores its state file. Options include local filesystem, S3, Azure Storage, Terraform Cloud, etc.

---

## Terraform vs OpenTofu

As you progress through this course (specifically Day 55-57 covering OpenTofu), it's important to understand the relationship:

| Aspect | Terraform | OpenTofu |
|--------|-----------|----------|
| **Origin** | HashiCorp | Community fork (created after BSL license change) |
| **License** | Business Source License (BSL) | Mozilla Public License 2.0 (MPL 2.0) |
| **Compatibility** | Proprietary toolchain | Community-driven, open-source |
| **Use Cases** | Enterprise with HashiCorp support | Community-preferred alternative |
| **Configuration** | HCL (same) | HCL (same - fully compatible) |

**Key Point:** OpenTofu is a community-driven fork of Terraform that maintains compatibility with Terraform configurations. The concepts, syntax, and core functionality are virtually identical. Learning Terraform concepts directly applies to OpenTofu.

---

## Getting Started

### **Installation**
Download Terraform from [terraform.io](https://www.terraform.io/downloads) or use package managers (Homebrew, apt, etc.).

### **Basic Workflow**
1. **Write** - Create `.tf` configuration files describing your infrastructure
2. **Plan** - Run `terraform plan` to see what changes will be made
3. **Apply** - Run `terraform apply` to create/update resources
4. **Manage** - Monitor and update your infrastructure as needed
5. **Destroy** - Run `terraform destroy` to tear down resources when done

### **Directory Structure**
```
my-infrastructure/
├── main.tf           # Primary resource definitions
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── terraform.tfvars  # Variable values (often Git-ignored)
└── .terraform/       # Auto-generated provider plugins
```

### **Common Commands**
```bash
terraform init      # Initialize working directory, download providers
terraform plan      # Show what changes will be made
terraform apply     # Apply changes to reach desired state
terraform destroy   # Destroy all resources
terraform state     # Inspect and manage state
terraform validate  # Check syntax and validity of configuration
terraform fmt       # Format code according to standard
```

---

## Next Steps

1. **Set up your first Terraform project** with a cloud provider account
2. **Create simple resources** to understand the workflow
3. **Practice state management** and working with multiple environments
4. **Explore modules** for code organization and reusability
5. **Compare with OpenTofu** (Day 55-57) to understand the community alternative

---

## Resources

- [Official Terraform Documentation](https://www.terraform.io/docs)
- [Terraform Language Reference](https://www.terraform.io/language)
- [Terraform Module Registry](https://registry.terraform.io/)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [Infrastructure as Code Best Practices](https://www.terraform.io/language/modules/develop)

---

**Last Updated:** June 7, 2026  
**Course Context:** Day 55-57 - Terraform & OpenTofu Introduction

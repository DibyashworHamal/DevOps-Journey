## Day 62: Introduction to AWS EKS & Cluster Provisioning (Jun 14, 2026)

### ☸️ 1. What is AWS EKS (Elastic Kubernetes Service)?
We transitioned from manually bootstrapping clusters (`kubeadm`) to Managed Kubernetes. 
- **The EKS Advantage:** AWS completely manages the Kubernetes Control Plane (API server, etcd, scheduler) across multiple Availability Zones for high availability. 
- **Our Responsibility:** We only manage the Data Plane (Worker Nodes) and our applications.

### 🏗️ 2. Deployment Modes: Standard vs. Fully Automated
We explored the different ways to run worker nodes in EKS:
- **Standard EKS (EC2 Nodes):** We provision actual EC2 instances to act as worker nodes. We have full control over the underlying OS, instance types, and SSH access. (This is what we chose for our lab).
- **Fully Automated (AWS Fargate / Serverless):** We don't provision any EC2 instances. We just tell AWS to run a Pod, and AWS dynamically provisions the exact compute capacity needed in the background.

### 🔐 3. The Crucial Prerequisite: AWS IAM Roles for EKS
Before clicking "Create Cluster", we had to set up strict IAM Roles. EKS relies heavily on AWS IAM for security and resource creation.

**A. EKS Cluster Role (For the Control Plane)**
Allows the EKS Control Plane to manage AWS resources on our behalf (e.g., creating Elastic Load Balancers when we deploy a `LoadBalancer` service).
- *Attached Policy:* `AmazonEKSClusterPolicy`

**B. Node IAM Role (For the Worker Nodes)**
Allows the EC2 worker nodes to communicate with the EKS Control Plane, configure networking, and pull Docker images from AWS ECR.
- *Attached Policies:* 
  1. `AmazonEKSWorkerNodePolicy`
  2. `AmazonEC2ContainerRegistryReadOnly`
  3. `AmazonEKS_CNI_Policy`

### ☁️ 4. Practical Lab: Initiating EKS Creation
Navigated to the **AWS EKS Console** to begin provisioning.
1. **Name & Version:** Defined the cluster name and selected the latest stable Kubernetes version.
2. **Cluster Service Role:** Attached the IAM Cluster Role we created.
3. **Networking & Add-ons:** We reviewed the default VPC, Subnets, and Security Group configurations, and discussed default Add-ons like `coredns`, `kube-proxy`, and `vpc-cni`.
4. **Pause for Tomorrow:** Since EKS clusters take 10-15 minutes to provision and require deeper node group configurations, we saved the remaining steps (Compute Node Groups and `kubeconfig` setup) for tomorrow's session!

## Day 63: EKS Node Groups, Kubeconfig & Deploying a Multi-Tier Microservices App (Jun 17, 2026)

### ☁️ 1. EKS Cluster Verification & AWS CLI
We verified the EKS Control Plane provisioned yesterday using the AWS CLI on our Ubuntu VM.
```bash
# Get massive JSON output of the cluster configuration
aws eks describe-cluster --name my-eks-cluster --region us-east-1

# Filter the output to just see the status using JMESPath query
aws eks describe-cluster --name my-eks-cluster --region us-east-1 --query "cluster.status"
# Output: "ACTIVE"
```
### 🏗️ 2. Provisioning Compute (Node Groups)
An EKS cluster without worker nodes can't run anything.
- Navigated to **EKS ➡️ Compute ➡️ Add Node Group**.
- Attached the AmazonEKSWorkerNodeRole created yesterday.
- Configured the Auto Scaling Group to launch **2 Worker Nodes (t3.medium recommended for K8s)**.
- Verification: Navigated to the EC2 Dashboard and saw 2 new EC2 instances spinning up automatically!

### 🔌 3. Connecting the Local VM to the AWS Cluster
How do we tell our local kubectl to stop talking to Minikube and start talking to AWS?
```bash
aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster
```
What this does: It downloads the authentication certificates from AWS and injects them into the ~/.kube/config file.
```bash
cat ~/.kube/config            # Viewed the raw cluster certificates and contexts
kubectl config view           # Cleanly view current context
kubectl get nodes             # Saw the 2 AWS EC2 Worker Nodes in 'Ready' state
kubectl get pods -n kube-system # Saw core K8s services running (aws-node, coredns, kube-proxy)
```
### 🗳️ 4. Practical Lab: Deploying the "Example Voting App"
We deployed Docker's famous multi-tier microservices application consisting of 5 distinct components: Python frontend (Vote), Node.js frontend (Result), .NET worker, Redis cache, and PostgreSQL database.

**Step 1: Clone the Source Code**
```bash
git clone https://github.com/dockersamples/example-voting-app.git
cd example-voting-app/k8s-specifications/
```
**Step 2: The Cloud-Native Networking Magic**

By default, the YAML files were set to NodePort. We edited vote-service.yaml and result-service.yaml using vim and changed:
**type: NodePort ➡️ type: LoadBalancer**

**Step 3: Execution**

Deployed all YAML files in the directory simultaneously:
```bash
kubectl apply -f .
```
### 🌐 5. Verification & Cloud Controller Magic
Checked the resources spinning up across our distributed nodes:
```bash
kubectl get deployments
kubectl get pods -o wide
kubectl get services
```
**The Magic:** Running kubectl get services showed a long AWS DNS name (e.g., a1b2c...us-east-1.elb.amazonaws.com) under the EXTERNAL-IP column for our Vote and Result services.
- ***What happened?*** The Kubernetes **Cloud Controller Manager** spoke to the AWS API and automatically provisioned a real **Elastic Load Balancer (ELB)** and configured the EC2 Security Groups without us ever touching the AWS Console!
- **Testing:** Copied the Load Balancer DNS name, pasted it into my Windows browser, and successfully voted on cats vs. dogs, with the results updating in real-time on the other microservice!
# Day 61 Lab: Building and Testing a Multi-Node Kubernetes Cluster on AWS (Kubeadm)(Jun 12, 2026)

## 📌 Overview
Moving beyond local single-node clusters, this lab documents the end-to-end process of provisioning, bootstrapping, and testing a highly available **Multi-Node Kubernetes Cluster** on AWS from scratch using `kubeadm`. We also conducted chaos engineering to observe Kubernetes' native self-healing capabilities in a cloud environment.

---

### 🏗️ Step 1: Infrastructure Provisioning (AWS EC2)
To simulate a true distributed architecture, we provisioned three separate virtual machines.
- **Launched 3 Ubuntu 24.04 EC2 Instances** on AWS.
- **Designations:** 1x Control Plane (Master Node), 2x Worker Nodes.
- Connected to all three instances simultaneously from my Windows machine using **GitBash** via SSH.

### ⚙️ Step 2: Cluster Bootstrapping (Kubeadm & Calico)
Before Kubernetes can orchestrate containers, the underlying runtime and cluster components must be installed on all nodes.
1. Installed **containerd** (Container Runtime).
2. Installed **kubeadm, kubelet, and kubectl**.
3. Initialized the cluster on the Master Node:
   ```bash
   sudo kubeadm init --pod-network-cidr=192.168.0.0/16
   ```
4. Installed the **Calico CNI (Container Network Interface)** to enable pod-to-pod communication across different nodes.

### 🔗 Step 3: Joining Worker Nodes
With the Control Plane running, we attached the compute muscle.
- Generated the bootstrap token on the Master Node and executed the kubeadm join command on both Worker Nodes.
- Verified the cluster architecture from the Master:
```bash
kubectl get nodes
# Output confirmed 1 Master and 2 Workers all in 'Ready' status.
```
### 🚀 Step 4: Workload Deployment & HA Testing
To test the kube-scheduler, we deployed a web server and scaled it to observe workload distribution.
```bash
# Create the deployment
kubectl create deployment nginx-web --image=nginx:latest

# Scale to 6 replicas for High Availability
kubectl scale deployment nginx-web --replicas=6

# Verify distribution across Worker Nodes
kubectl get pods -o wide
```
***Results:*** The scheduler perfectly balanced the 6 Pods, placing 3 on Worker Node 1 and 3 on Worker Node 2.

### 🌐 Step 5: Networking & NodePort Configuration
To make the application accessible to the outside world, we exposed the deployment using a NodePort Service.
```bash
kubectl expose deployment nginx-web --type=NodePort --port=80
```
***Assigned NodePort: Kubernetes dynamically assigned port 31134.***

### 🛡️ Step 6: AWS Security Configuration
Kubernetes opens the port internally, but the AWS Cloud Firewall blocks external traffic by default.
- Navigated to the **AWS EC2 Console**.
- Edited the **Security Group (Inbound Rules)** attached to the Worker Nodes.
- Added a Custom TCP rule opening port **31134 to 0.0.0.0/0 (Anywhere).**

### 🛑 Step 7: Troubleshooting Lesson (Internal vs. External Access)
**The Problem:** I attempted to access the NGINX application in my browser using the internal Calico network IP (e.g., tunl0 interface / 192.168.x.x) and received a "Connection Timed Out" error.

**The Root Cause:** CNI IPs (like Calico's 192.168.x.x) are purely for internal cluster communication. They are unroutable from the public internet.

**The Fix:** To access the app globally, I had to use the AWS Public IPv4 Address of the EC2 instances, appended with the NodePort:
http://<AWS_PUBLIC_IP>:31134

**Result:** The NGINX welcome page loaded perfectly!

### 💥 Step 8: Chaos Engineering & Self-Healing
To validate Kubernetes' resilience, I performed a chaos engineering test.
1. Navigated to the AWS Console and forcefully **Stopped** Worker Node 1.
2. Watched the cluster state via the Master Node (kubectl get pods -o wide -w).
3. **Observation:** Kubernetes instantly detected the dead node, marked the 3 lost pods as Terminating, and automatically recreated them on the surviving Worker Node 2 to maintain the desired state of 6 replicas. Zero manual intervention required!

**🧠 Key Takeaways / Lessons Learned**

- **Kubeadm Complexity**: Bootstrapping a cluster from scratch highlights the immense value of managed services like AWS EKS, but doing it manually with kubeadm provides a deep understanding of K8s architecture.
- **Network Boundaries**: Differentiating between Pod IPs, ClusterIPs, NodePorts, and actual Cloud Provider Public IPs is the most critical networking skill in cloud-native deployments.
- **True High Availability**: Stopping an EC2 instance and watching Kubernetes automatically reschedule the workload onto surviving nodes without human intervention is the ultimate proof of why the industry shifted to container orchestration!
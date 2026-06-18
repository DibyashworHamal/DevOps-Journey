## Day 58: Introduction to Kubernetes (K8s), Architecture & Local Cluster Setup (Jun 9, 2026)

### ☸️ 1. Introduction to Kubernetes (K8s)
We reviewed Docker containerization and realized its limits: managing multiple containers across different servers manually is impossible. 
- **What is Kubernetes?** Kubernetes (K8s) is an open-source container orchestration platform designed to automate deploying, scaling, and operating application containers.
- **Why do we need it?** 
  - *Service Discovery & Load Balancing:* Exposes containers using DNS names or IPs.
  - *Storage Orchestration:* Automatically mounts local, cloud (AWS S3/EBS), or network storage.
  - *Automated Rollouts & Rollbacks:* Deploys updates with zero downtime; rolls back if a bug is detected.
  - *Self-Healing:* Automatically restarts, replaces, and reschedules containers that fail or don't respond to health checks.
- **What Kubernetes is NOT:**
  - It is not a PaaS (like Heroku). It does not build your application code (you still need Jenkins/CodeBuild).
  - It does not provide application-level services (like databases, message queues, or caching).
**Historical Context:** 
Originally designed by **Google** based on their internal cluster management systems (**Borg** and **Omega**). Google open-sourced it in 2014, donating it to the **Cloud Native Computing Foundation (CNCF)**.

---

### 🏗️ 2. Kubernetes Architecture (Master-Worker Topology)
Kubernetes operates on a Master-Worker node architecture.

#### **A. The Control Plane (Master Node - The "Brain")**
It manages the global state of the cluster, detects events, and makes decisions.
1.  **`kube-apiserver`:** The entry point of the cluster. Every command we run (`kubectl`) communicates strictly with this API.
2.  **`etcd`:** The cluster's database. A highly available key-value store that stores the configuration data and state of the entire cluster.
3.  **`kube-scheduler`:** Watches for newly created Pods and decides which Worker Node they should run on based on resource availability.
4.  **`kube-controller-manager`:** Runs background controllers to maintain the cluster state (e.g., Node Controller, Job Controller, Endpoint Controller).

#### **B. Worker Nodes (The "Muscle")**
These run the actual containerized applications.
1.  **`kubelet`:** An agent that runs on each node in the cluster. It ensures that the containers described in Pod specs are running and healthy.
2.  **`kube-proxy`:** A network proxy that runs on each node, maintaining network rules to allow communication to your Pods from inside or outside the cluster.
3.  **Container Runtime:** The software responsible for running containers (e.g., `containerd` or `Docker`).

---

### 📦 3. What is a Pod?
A **Pod** is the smallest, most basic deployable unit in Kubernetes.
- It represents a single instance of a running process in your cluster.
- A Pod wraps one or more containers (e.g., your App container + a helper container).
- All containers inside a single Pod share the same **IP Address**, **Network namespace**, and **Storage volumes**.

---

### 🛠️ 4. Practical Lab: Local Environment Setup
We successfully provisioned a local single-node Kubernetes cluster on our Windows 11 laptop.
- **`kubectl`:** The command-line utility used to send commands to the Kubernetes API server.
- **`minikube`:** A lightweight tool that spins up a local Kubernetes cluster using virtual machines or container runtimes (like Docker Desktop) as the driver.

**Commands Executed & Mastered:**
| Command | Description |
| :--- | :--- |
| `minikube version` | Checks the installed Minikube version. |
| `minikube start` | Starts the local Kubernetes cluster. |
| `minikube status` | Verifies if the master and nodes are up and running. |
| `minikube dashboard` | Opens a web-based GUI in the browser to visually monitor the cluster. |
| `kubectl get nodes` | Lists all active nodes (shows our `minikube` master/worker node). |
| `kubectl get pods` | Lists all active pods in the default namespace. |
| `kubectl get namespace` | Lists the active namespaces (logical isolations) in the cluster. |
| `minikube stop` | Pauses the local cluster to save computer RAM/CPU. |
| `minikube delete` | Completely destroys the local cluster. |
**Key Takeaways:**
- We can run a full Kubernetes cluster locally using Minikube, which is perfect for development and learning.
- The `kubectl` tool is essential for interacting with the cluster, and mastering its commands is crucial for effective Kubernetes management.
- The Kubernetes Dashboard provides a visual interface to monitor and manage cluster resources, making it easier for beginners to understand the cluster's state.
- Always remember to stop or delete your local cluster when not in use to free up system resources.

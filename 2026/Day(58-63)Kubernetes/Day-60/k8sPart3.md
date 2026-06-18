## Day 60: K8s Deployments (Zero-Downtime) & Services (Networking) (Jun 11, 2026)

### 🚀 1. Deep Dive: Kubernetes Deployments
Yesterday we used ReplicaSets. Today we learned why we **never** create ReplicaSets directly in production. We use **Deployments**.
- **What is it?** A Deployment is a higher-level controller that manages ReplicaSets. 
- **Use Cases:** It provides declarative updates for Pods. We use it to roll out new versions of our application (e.g., upgrading Nginx v1 to v2), roll back to an older version if the new code crashes, and scale the application seamlessly.

### 🔄 2. Deployment Strategies: RollingUpdate vs. Recreate
When pushing a new version of an application, the Deployment controller uses a specific strategy:

| Strategy | How it Works | Pros & Cons |
| :--- | :--- | :--- |
| **RollingUpdate** *(Default)* | Replaces old Pods with new Pods one by one (or in batches). | **Pros:** Zero downtime. Users don't notice the upgrade.<br>**Cons:** Both old and new versions run simultaneously for a brief time (requires database backward compatibility). |
| **Recreate** | Kills ALL existing Pods before creating new ones. | **Pros:** Clean slate, no version conflict.<br>**Cons:** Application experiences complete downtime during the swap. |

### 🌐 3. Deep Dive: Kubernetes Services
**The Problem:** Pods are ephemeral. If a Pod crashes, the Deployment spins up a new one, but it gets a **brand new IP address**. We cannot hardcode Pod IPs into our application backend!
**The Solution:** A **Service** acts as a static, permanent IP/DNS name that sits in front of the Pods and load-balances traffic to them.

### 🔀 4. The 4 Types of K8s Services
We explored how to expose our applications based on different architectural needs:

1. **ClusterIP (Default):** 
   - Exposes the service on a cluster-internal IP. 
   - *Use Case:* Internal communication only (e.g., the Web Frontend talking to the Backend Database). The outside world cannot reach it.
2. **NodePort:** 
   - Exposes the service on each Worker Node’s IP at a static port (between `30000 - 32767`).
   - *Use Case:* Quick testing or external access without a cloud provider. (You access it via `http://<NodeIP>:<NodePort>`).
3. **LoadBalancer:** 
   - Integrates with the Cloud Provider (AWS, GCP, Azure). 
   - *Use Case:* Production web applications. It provisions an actual AWS Application Load Balancer (ALB) and routes external internet traffic into the cluster.
4. **ExternalName:** 
   - Maps the Service to the contents of the `externalName` field (e.g., `foo.bar.example.com`), returning a `CNAME` record. 
   - *Use Case:* Allowing Pods to talk to an external database hosted outside of Kubernetes.

### 🛠️ 5. Practical Implementation
- Wrote a `deployment.yml` to spin up Nginx.
- Updated the image version in the YAML and ran `kubectl apply -f deployment.yml` to observe a live **RollingUpdate**.
- Wrote a `service.yml` to create a `NodePort` service, mapping port 80 of the Pod to port 30001 on the Node.
- Verified traffic routing using `kubectl get svc` and successfully browsed the app!
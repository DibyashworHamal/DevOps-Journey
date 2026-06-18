## Day 59: Kubernetes Pods, Declarative YAML & ReplicaSets (Jun 10, 2026)

### 📄 1. The Declarative Approach (YAML over Ad-Hoc)
In Kubernetes, we can create pods using ad-hoc commands (`kubectl run`), but this is a bad practice for production. Instead, we use the **Declarative Approach** by writing `.yml` manifests.
- **Why?** YAML files can be version-controlled in Git (GitOps), reviewed by teams, and reused. You declare the *desired state*, and K8s makes it happen.

**Core Fields of a K8s YAML File:**
1. `apiVersion`: The version of the Kubernetes API you're using (e.g., `v1`, `apps/v1`).
2. `kind`: What kind of object you want to create (e.g., `Pod`, `ReplicaSet`).
3. `metadata`: Data that helps uniquely identify the object (e.g., `name`, `labels`).
4. `spec`: The exact desired state/configuration of the object (e.g., container image, ports).

**Example `pod.yml`:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-first-pod
  labels:
    type: front-end
spec:
  containers:
    - name: mynginx
      image: nginx:1.28
      ports:
      - containerPort: 80
```
***Executed via:*** kubectl apply -f pod.yml

### 🔄 2. Kubernetes Replication & ReplicaSets
A single Pod is fragile. If the Node it runs on crashes, the Pod dies and is not restarted. We solve this using a ReplicaSet.
- **What is a ReplicaSet?** A controller that ensures a specified number of identical Pod replicas are running at any given time.
- **Why use it?** High Availability, Fault Tolerance, and Scalability. If a Pod crashes, the ReplicaSet instantly detects the missing Pod and creates a new one to replace it (Self-Healing!).

### 🧬 3. Deep Dive: Writing a replicaset.yml
We deployed a ReplicaSet to maintain 2 instances of an Nginx web server. The magic linking the ReplicaSet to the Pods is the Selector and Labels.
**Example replicaset.yml:**
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp
  labels:
    type: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      type: frontend
  template:
    metadata:
      labels:
        type: frontend
    spec:
      containers:
      - name: mynginx
        image: nginx:1.28
        ports:
        - containerPort: 80
```
***Executed via:*** kubectl apply -f replicaset.yml

### 🛠️ 4. Practical Execution & Deep Inspection
We verified our architecture using core Kubernetes troubleshooting commands.
1. `kubectl get pods`: We saw the magic happen! Two Nginx pods were instantly spun up with random hash names (e.g., frontend-replicaset-xyz12).
2. `kubectl describe pod <pod_name>`: The ultimate debugging tool. It outputs deep details about the pod:
   - **Node Assignment**: Which worker node the pod was scheduled on.
   - **IP Address**: The internal cluster IP assigned to the pod.
   - **State**: Pending, Running, or Terminated.
   - **Events**: A chronological log at the bottom showing image pulling, container creation, and startup success/failures.
   
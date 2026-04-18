## Day 29: Harbor Administration, SBOM & Docker Compose Orchestration (Apr 18, 2026)

### ⚓ 1. Advanced Harbor Registry Management
After setting up Harbor yesterday, today we explored its enterprise-grade features:
- **Projects:** Logical isolation of images. We created custom projects to separate development environments from production.
- **User & Permissions (RBAC):** Role-Based Access Control. We assigned users specific roles (Project Admin, Developer, Guest) to enforce the Principle of Least Privilege.
- **Webhooks:** Automated HTTP callbacks. Configured Harbor to send a notification (POST request) to external tools (like Slack or Jenkins) whenever a new image is successfully pushed or scanned.
- **Replication:** High Availability and Disaster Recovery. We learned how to set up rules to automatically copy (replicate) images from our local Harbor registry to another remote registry.

### 🛡️ 2. SBOM (Software Bill of Materials)
A critical concept in modern DevSecOps and software supply chain security.
- **What is it?** A formal, machine-readable inventory of all open-source and third-party components, libraries, and dependencies used in a Docker image.
- **Why it matters:** If a zero-day vulnerability (like Log4j) is discovered, the SBOM allows engineers to instantly know if their containers contain the compromised library without having to manually scan every line of code.

### 🐙 3. Deep Dive into Docker Compose
Docker Compose is a tool for defining and running multi-container Docker applications using a single YAML file.
- **Imperative vs. Declarative:** Instead of running imperative commands (`docker run -p 80:80 -d nginx`), we write declarative YAML files (`docker-compose.yml`) that describe *what* the final state of the infrastructure should look like.
- **Key Sections in `docker-compose.yml`:**
  - `version`: The compose file format version.
  - `services`: Defines the containers (e.g., `web`, `db`).
  - `networks`: Custom isolated networks for the services to communicate.
  - `volumes`: Persistent storage definitions.

### 🛠️ 4. Practical Lab: Full Stack Deployment
We combined a custom `Dockerfile` with a `docker-compose.yml` to spin up a demo app.

**The `docker-compose.yml` Structure:**
```yaml
version: '3.8'
services:
  web-app:
    build: .                 # Tells Compose to build the Dockerfile in this directory
    container_name: demo-app
    ports:
      - "8080:80"            # Host Port : Container Port
    restart: unless-stopped
``` 

**Commands Executed:** 
| Command | Description |
| :--- | :--- |
| docker compose up -d | Builds the image (if needed), creates networks, and starts containers in the background. |
| docker compose logs -f | Follows the live log output of all services in the compose file. |
| docker compose down | Stops and gracefully removes the containers, networks, and volumes. |

**Verification:**

i.Checked live traffic hitting the container via docker compose logs.

ii.Successfully browsed the demo application locally inside the Ubuntu VM (curl localhost:8080) and externally on my Windows host browser (http://<VM_IP>:8080).
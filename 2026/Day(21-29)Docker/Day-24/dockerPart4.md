## Day 24: Docker Images, Dockerfiles & Restart Policies (Apr 7, 2026)

### 🖼️ 1. What is a Docker Image?
A Docker Image is a read-only, immutable template that contains the application code, runtime, libraries, environment variables, and configuration files needed to run a container.
- **Principles of Docker Images:**
  - **Immutable:** Once built, an image cannot be changed. To update it, you must build a new image.
  - **Layered Architecture:** Every instruction in a Dockerfile creates a new layer. Layers are cached, making rebuilds extremely fast.

### 🗄️ 2. Registry vs. Repository
These two terms are often confused, but they are very different:
- **Registry:** The actual server/service that stores and distributes Docker images (e.g., *Docker Hub*, *AWS ECR*, *Google GCR*).
- **Repository:** A collection of different versions (tags) of the *same* image inside a registry (e.g., the `nginx` repository contains `nginx:latest`, `nginx:alpine`, etc.).

### 🏷️ 3. Kinds of Images on Docker Hub
When searching for images on Docker Hub, we look for specific badges to ensure security:
1. **Official Images:** Maintained directly by Docker and the upstream software creator (e.g., Ubuntu, Nginx, Python). Highly secure.
2. **Verified Publisher:** High-quality images published by commercial entities (e.g., Oracle, IBM).
3. **Sponsored OSS:** Open-source projects sponsored by Docker.
4. **Hardened Images:** Images specifically scanned and stripped of vulnerabilities, focused on high security.

### 🔄 4. Container Restart Policies
If a container crashes or the VM reboots, what should Docker do? We control this using the `--restart` flag during `docker run`.
| Policy | Behavior |
| :--- | :--- |
| `no` | **(Default)** Do not restart the container if it stops or crashes. |
| `on-failure[:max-retries]` | Restart only if the container exits with a non-zero (error) status. You can specify max attempts (e.g., `on-failure:5`). |
| `always` | Always restart the container regardless of why it stopped. If manually stopped, it restarts when the Docker daemon restarts. |
| `unless-stopped` | Always restart, *except* when the container is explicitly stopped manually by the user. (Best practice for web servers!). |

### 🛠️ 5. Docker Image Management Commands
| Command | Description |
| :--- | :--- |
| `docker image ls` | Lists all downloaded images on the host. |
| `docker image rm <image_id>` | Deletes an image (must stop/remove containers using it first). |
| `docker image pull <name>` | Downloads an image from a registry. |
| `docker image push <name>` | Uploads your custom image to a registry. |
| `docker image inspect <name>` | Shows deep JSON metadata about the image layers and configs. |
| `docker image prune` | Deletes dangling images (images without a tag/name). |

### 📝 6. Dockerfile Instructions
A `Dockerfile` is a text document containing all the commands a user could call on the command line to assemble an image.
- `FROM`: Sets the base image (e.g., `FROM ubuntu:24.04`). *Must be the first instruction.*
- `RUN`: Executes commands inside the container during the *build* process (e.g., `RUN apt update`).
- `COPY`: Copies files/folders from the Host VM to the Container.
- `ADD`: Similar to COPY, but can extract `.tar` files automatically and download from URLs.
- `WORKDIR`: Sets the working directory inside the container (like `cd`).
- `EXPOSE`: Documents which port the container listens on (e.g., `EXPOSE 80`).
- `CMD`: The default command that runs when the container *starts* (e.g., `CMD ["nginx", "-g", "daemon off;"]`).
- `ENTRYPOINT`: Configures a container to run as a specific executable.

### 🚀 7. Practical Lab: Building a Custom Web Server
We wrote our first custom containerized application!

**Step 1: Create `index.html`**
```html
<h1>Hello from Dibyashwor's Custom Docker Container!</h1>
```
**Step 2: Create Dockerfile**
```
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```
**Step 3: Build & Run**
```
# Build the image from the Dockerfile
docker build -t dibyashwor-web:v1 .

# Run the container using the newly built image
docker container run -d --name my-custom-web -p 8080:80 --restart unless-stopped dibyashwor-web:v1
```
**Step 4: Verify**
Accessed the site via curl localhost:8080 in the VM and via http://<VM_IP>:8080 in the Windows browser. Success!

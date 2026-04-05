## Day 23: Docker Networking Deep Dive & Persistent Storage (Volumes) (Apr 5, 2026)

### 🌐 1. Docker Networking Architecture
Docker networking allows containers to communicate with each other, the host, and the outside world safely. It is built on three major components:
1. **Container Network Model (CNM):** The design specification/standard for Docker networking.
2. **libnetwork:** The actual implementation (code) of the CNM written in Go.
3. **Drivers:** The plugins that provide the actual network implementations.

### 🔀 2. Docker Network Drivers
| Driver | Description | Practical Use Case |
| :--- | :--- | :--- |
| **Bridge** | The default network. Containers on the same bridge can talk via IP. | Standard standalone container deployments. |
| **Host** | Removes network isolation. The container shares the VM's network stack directly. | High-performance applications. |
| **Overlay** | Connects multiple Docker daemons together. | Docker Swarm / Multi-host clustering. |
| **Macvlan** | Assigns a physical MAC address to the container. | Legacy apps needing direct network access. |
| **None** | Completely disables all networking for the container. | Highly secure/isolated processing. |

### 🛠️ 3. Network Management Commands
- **Create:** `docker network create my_custom_net`
- **List:** `docker network ls`
- **Inspect:** `docker network inspect my_custom_net` (Shows connected containers & IP subnets)
- **Connect/Disconnect:** `docker network connect my_custom_net <container_id>`
- **Cleanup:** `docker network rm my_custom_net` or `docker network prune` (Deletes all unused networks).

**Running a Container on a Custom Network:**
```bash
docker container run -d --name web_server -P --network my_custom_net nginx
```
(Note: The uppercase -P publishes all exposed ports to random high ports, whereas lowercase -p 8080:80 maps to a specific chosen port).

### 4.  Docker Storage: Volumes vs. Bind Mounts
Containers are ephemeral—if a container is deleted, all data inside it is lost forever. We use Storage to persist data.
1. Docker Volumes (Best Practice):
-Managed entirely by Docker. Stored in /var/lib/docker/volumes/ on   the Host VM.
-Independent of the OS file system. Very safe.
2. Bind Mounts:
-Maps a specific directory on the Host VM (e.g., /home/user/app) directly into the container.
-Great for development (code changes on the host instantly reflect in the container).

### 5. Volume Management Commands
**Create**: docker volume create my_database_data
**List**: docker volume ls
**Inspect**: docker volume inspect my_database_data
**Cleanup**: docker volume rm <name> or docker volume prune

### 6. Attaching Storage to Containers (-v vs --mount)
We practiced both syntaxes for attaching storage during container creation. --mount is preferred because it is more explicit and readable.

Using the --mount flag (Modern/Preferred):
```
# Attaching a Volume
docker container run -d --name db --mount type=volume,source=my_database_data,target=/var/lib/mysql mysql

# Attaching a Bind Mount
docker container run -d --name web --mount type=bind,source=/home/user/html,target=/usr/share/nginx/html nginx
```
Using the -v flag (Legacy/Shorthand):
```
# Volume shorthand
docker container run -d -v my_database_data:/var/lib/mysql mysql

# Bind Mount shorthand
docker container run -d -v /home/user/html:/usr/share/nginx/html nginx
```

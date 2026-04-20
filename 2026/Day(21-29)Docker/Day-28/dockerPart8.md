## Day 28: Enterprise Custom Registries, Harbor & DevSecOps (Trivy) (Apr 15, 2026)

### 🏢 1. Why a Custom Registry?
Public registries (like Docker Hub) are great, but enterprises require:
- **Privacy & Security:** Proprietary source code cannot be stored on public servers.
- **Access Control:** Role-Based Access Control (RBAC) integrated with Active Directory/LDAP.
- **Vulnerability Scanning:** Automatically checking images for CVEs (Common Vulnerabilities and Exposures) before they are deployed.
- **Bandwidth/Speed:** Pulling images across a local LAN is infinitely faster than pulling from the internet.

### ⚓ 2. What is Harbor & Trivy?
- **Harbor:** An open-source trusted cloud-native registry project by CNCF that stores, signs, and scans content. 
- **Trivy:** A comprehensive and versatile security scanner for containers. We integrated it into Harbor to automatically scan every image we push.

### 🛠️ 3. Step-by-Step: Harbor Setup with Self-Signed Certificates
Since Harbor requires HTTPS to work securely with Docker, we act as our own Certificate Authority (CA).

**Step 1: Generate Self-Signed SSL Certificates (OpenSSL)**
```bash
# Generate a private key
openssl genrsa -out ca.key 4096

# Generate a self-signed CA certificate
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=NP/ST=Kathmandu/L=Kathmandu/O=TechAxis/OU=DevOps/CN=harbor.local" \
 -key ca.key -out ca.crt
 
# Generate Server Certificate and Key (harbor.local.key & harbor.local.crt)
# (Skipping detailed CSR/extfile steps for brevity, but they bind the cert to the IP/Hostname)
```
**Step 2: Download & Extract Harbor**
```
wget https://github.com/goharbor/harbor/releases/download/v2.x.x/harbor-offline-installer-v2.x.x.tgz
tar xzvf harbor-offline-installer-v2.x.x.tgz
cd harbor
```
**Step 3: Configure harbor.yml**

Copied the template: cp harbor.yml.tmpl harbor.yml
Edited the following fields in harbor.yml using vim:

**hostname: harbor.local (or VM IP address)**

**certificate: /your/path/to/harbor.local.crt**

**private_key: /your/path/to/harbor.local.key**

**harbor_admin_password: StrongPassword123**

**Step 4: Install Harbor with Trivy**

Harbor runs as a stack of Docker containers via Docker Compose.
```
sudo ./install.sh --with-trivy
```
### 🤝 4. Trusting the Certificate & Pushing Images
Because the certificate is self-signed, the Docker client will block the connection initially.

**Step 1: Tell Docker to Trust the CA**
```
sudo mkdir -p /etc/docker/certs.d/harbor.local/
sudo cp ca.crt /etc/docker/certs.d/harbor.local/
sudo systemctl restart docker
```
**Step 2: Login to Harbor**
```
docker login harbor.local
# User: admin | Pass: StrongPassword123
```
**Step 3: Tag and Push!**
We take an existing local image, tag it with our Harbor domain and project name (library), and push it.
```
docker tag my-node-app:v1 harbor.local/library/my-node-app:v1
docker push harbor.local/library/my-node-app:v1
```
Result: Logged into the Harbor Web UI, saw the image, and triggered a **Trivy Scan** to check for vulnerabilities!

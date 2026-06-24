## Day 66: DevSecOps - Securing Prometheus & Node Exporter (Basic Auth & TLS) (Jun 22, 2026)

### 🛡️ 1. The Security Problem
By default, Node Exporter exposes sensitive OS metrics on `http://<IP>:9100/metrics` in plain text with zero authentication. Anyone on the network can read this data. Today, we locked it down.

### 🔑 2. Implementing Basic Authentication
We secured the Node Exporter endpoint requiring a Username and Password.

**Step 1: Configure Node Exporter (VM-2)**
1. Generated a hashed password (bcrypt) from a plain-text string.
2. Created the configuration directory and file:
   ```bash
   sudo mkdir /etc/node_exporter
   sudo vim /etc/node_exporter/config.yml
   ```
3. Added the hashed credentials to config.yml:
   ```yaml
   basic_auth_users:
    admin: <hashed_password_here>
   ```
4. Edited the Systemd service file (/etc/systemd/system/node_exporter.service) to point to the new config:
```ini
[Service]
ExecStart=/usr/local/bin/node_exporter --web.config.file=/etc/node_exporter/config.yml
```
5. Reloaded the Systemd daemon and restarted Node Exporter:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart node_exporter
   ```
6. Verified the endpoint by browsing to `http://<VM-2-IP>:9100/metrics`. The browser prompted for credentials, and after entering the correct username and password, the metrics were displayed.

**Step 2: Configure Prometheus to Authenticate (VM-1)**

Because we locked Node Exporter, the Prometheus server threw a "Target Down" error.

1. Edited /etc/prometheus/prometheus.yml.
2. Added the basic_auth block under the Node Exporter job:
```yaml
- job_name: "ubuntu-worker-node"
  basic_auth:
    username: "admin"
    password: "my_plain_text_password"
  static_configs:
    - targets: ["<VM-2-IP>:9100"]
```
3. Restarted Prometheus. The target state returned to UP!

### 🔐 3. Implementing TLS Encryption (HTTPS)
Basic Auth prevents unauthorized access, but the data is still traveling in plain-text. We need SSL/TLS encryption.

**Step 1: Generate Self-Signed Certificates (VM-2)**

1. Used openssl to generate a private key (node_exporter.key) and a self-signed certificate (node_exporter.crt).
2. Moved both files into /etc/node_exporter/.
3. Updated config.yml to include TLS:
 ```yaml
 tls_server_config:
  cert_file: /etc/node_exporter/node_exporter.crt
  key_file: /etc/node_exporter/node_exporter.key
```
4. Fixed file permissions for security:
```bash
sudo chown -R node_exporter:node_exporter /etc/node_exporter
```
5. Restarted the service.

6. **Verification:** Tried HTTP and got the error: "Client sent an HTTP request to an HTTPS server". Changed URL to https://... and successfully accessed the encrypted metrics!

**Step 2: Configure Prometheus for HTTPS (VM-1)**

Again, Prometheus broke because it was trying to scrape via HTTP.

1. Securely copied the node_exporter.crt from VM-2 to VM-1 and placed it in /etc/prometheus/.
2. Updated /etc/prometheus/prometheus.yml:
```yaml
- job_name: "ubuntu-worker-node"
  scheme: https
  tls_config:
    ca_file: /etc/prometheus/node_exporter.crt
    insecure_skip_verify: true  # Necessary for self-signed certs
  basic_auth: ...
```
3. Restarted Prometheus.
4. **Final Result:** Checked the Prometheus UI. The target is UP, utilizing a fully secure https:// endpoint with Basic Authentication!
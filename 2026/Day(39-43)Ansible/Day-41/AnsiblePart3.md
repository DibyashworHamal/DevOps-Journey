## Day 41: Advanced Ansible Configuration, Inventories & Cross-Platform Deployment (May 13, 2026)

### ⚙️ 1. Ansible Configuration File (`ansible.cfg`)
Instead of passing flags (like `-i inventory`) every time we run a playbook, we can define default behaviors in the `ansible.cfg` file.
- **`inventory = ./inventory`** : Tells Ansible where the host list is located by default.
- **`host_key_checking = False`** : Prevents the SSH prompt (*"Are you sure you want to continue connecting?"*) from pausing the automation script. This is crucial for fully headless deployments!

**Ansible Configuration Precedence:**
According to official docs, Ansible looks for its configuration file in this exact order (Highest to Lowest Priority):
1. `ANSIBLE_CONFIG` (Environment variable)
2. `./ansible.cfg` (Current working directory - **Best Practice for project isolation**)
3. `~/.ansible.cfg` (User's home directory)
4. `/etc/ansible/ansible.cfg` (System-wide default)

### 🗂️ 2. Advanced Inventory Management
We expanded our inventory file from a simple list of IPs to a structured database.
- **Groups:** Organizing servers functionally (e.g., `[web]`, `[db]`).
- **Child Groups:** Combining groups together using `:children`.
  ```ini
  [datacenter:children]
  web
  db
  ```
- **Variables (Host vs. Group):**
- **Group Variables:** Apply to all servers in a group (e.g., [web:vars] ansible_user=vagrant).
- **Host Variables:** Apply only to one specific server (defined right next to the IP).
- **Priority Rule:** Host variables always override Group variables!

### 📜 3. YAML Syntax Deep Dive
Ansible playbooks rely strictly on YAML (YAML Ain't Markup Language).

- Uses spaces for indentation (NEVER use tabs!).
- Lists/Arrays: Denoted by a dash (-).
- Dictionaries/Key-Value Pairs: Denoted by a colon and space (key: value).
- Data structure consistency is the key to avoiding playbook parsing errors.

### 🐧 4. Cross-Platform Practical Lab (CentOS Database)
We brought up a new CentOS VM to host our database, mixing it with our existing Ubuntu Web Server.

**The Database Deployment Steps:**

1. Target the [db] group (CentOS) in the playbook.
2. Install the database engine (MariaDB) using the CentOS package manager (yum/dnf instead of apt).
3. Crucial Dependency: Installed PyMySQL via pip. Ansible requires this Python library on the target node to successfully execute MySQL modules!
4. Utilized Ansible database modules:
   - `mysql_db`: Created the application database.
   - `mysql_user`: Created the database user, set passwords, and granted privileges.
5. Started and enabled the DB service to persist across reboots.

***Result:*** A fully functional Cross-Platform 2-Tier Architecture! The Ubuntu VM serves Apache/WordPress, securely connecting to the CentOS VM hosting the MariaDB database.
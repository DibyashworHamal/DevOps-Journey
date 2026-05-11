## Day 40: Passwordless SSH, Ansible Playbooks & Multi-Tier Deployment (May 11, 2026)

### 🔐 1. Passwordless Authentication (Security Best Practice)
Putting plain-text passwords in an inventory file is a major security risk. We secured our Ansible Controller by implementing SSH Key Pairs.
```bash
# On the Control Node:
ssh-keygen -t ed25519
ssh-copy-id vagrant@192.168.56.11   # Target Web Server
ssh-copy-id vagrant@192.168.56.12   # Target DB Server
```
***Result:*** We removed ansible_ssh_pass from our inventory file. Ansible now securely communicates with 100+ servers using cryptography without asking for a password.

### 🏛️ 2. Ansible Architecture Components
- Modules: Small programs Ansible pushes to managed nodes to perform tasks (e.g., apt, service, copy).
- Plugins: Pieces of code that augment Ansible’s core functionality.
- Inventory: The static or dynamic list of target IPs/hostnames.
- Playbooks: YAML files where we orchestrate multiple modules to define the desired state of our infrastructure.

### ⚡ 3. Ansible Ad-Hoc Commands
Ad-hoc commands are quick, one-off commands to execute tasks without writing a full playbook.
```bash
# Install Apache2 (-b means become/sudo)
ansible web -m apt -a "name=apache2 state=present" -b

# Start and Enable the service
ansible web -m service -a "name=apache2 state=started enabled=yes" -b

# Copy a custom index.html to the web server
ansible web -m copy -a "src=./index.html dest=/var/www/html/index.html" -b

# Remove Apache2
ansible web -m apt -a "name=apache2 state=absent" -b
```
### 📖 4. Finding Modules offline (ansible-doc)
DevOps engineers don't memorize every module; they use built-in documentation.
- ansible-doc -l : Lists all available modules.
- ansible-doc copy : Shows the manual, parameters, and examples for the copy module.

### 📜 5. Transitioning to Playbooks (Infrastructure as Code)
Ad-hoc commands are great, but they aren't repeatable. We wrote our first playbook.yml to declare our desired server state. We also configured ansible.cfg to set our default inventory, allowing us to run playbooks without passing the -i flag.
**Playbook Validation Commands:**
- ansible-playbook playbook.yml --syntax-check : Scans the YAML file for indentation or syntax errors.
- ansible-playbook playbook.yml --check : Dry Run. Simulates the playbook to see what would change, without actually applying the changes!
- ansible-playbook playbook.yml : Executes the configuration.

### 🚀 6. The Grand Assignment: Multi-Node WordPress Deployment
We brought everything together by automating our Day 19 LAMP stack deployment across multiple VMs.

**The Architecture:**
- **Control Node:** Runs the Ansible Playbook.
- **Node 1 (Web):** Ansible installs Apache, PHP, downloads WordPress, configures wp-config.php, and starts the web server.
- **Node 2 (DB):** Ansible installs MariaDB, secures it, creates the wordpress database, and grants user privileges.

**The Playbook Logic:**
We created a single YAML file with multiple "Plays".
- **Play 1:** Targeted hosts: db to run the database modules.
- **Play 2:** Targeted hosts: web to run the apache and application modules.

**Magic Moment:** Ran the playbook, and in less than 2 minutes, the entire infrastructure spun up. I opened my Windows browser, typed the Web VM's IP, and the live WordPress installation screen appeared!
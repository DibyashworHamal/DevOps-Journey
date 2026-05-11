# 📂 Topic: Ansible Foundations & 2-Tier Architecture Deployment
**📅 Date:** May 11, 2026  
**🎯 Objective:** Master Ansible architecture, Ad-Hoc commands, Playbooks, and deploy a multi-node WordPress + MariaDB stack.

---

## 1. 🔐 Passwordless Authentication (SSH Keys)
Ansible uses SSH to connect to managed nodes. To automate tasks without typing passwords, we must establish passwordless SSH.
*   **Generate Key:** `ssh-keygen` (Run on Controller Node)
*   **Copy Key to Target:** `ssh-copy-id username@target_ip`
*   **Test:** `ssh username@target_ip` (Should log in instantly without a password).

## 2. 🏗️ Ansible Architecture & Components
Ansible is an **agentless** Configuration Management tool.
*   **Controller Node:** The machine where Ansible is installed.
*   **Managed Nodes:** The target servers being configured.
*   **Inventory:** A file (e.g., `hosts`) listing the IP addresses of Managed Nodes.
*   **Modules:** Built-in scripts Ansible uses to do work (e.g., `apt`, `service`, `copy`).
*   **Playbooks:** YAML files containing a list of tasks for Ansible to execute automatically.

## 3. ⚡ Ad-Hoc Commands (The Quick Fixes)
Ad-Hoc commands are single-line commands used for quick, one-time tasks without writing a playbook.

*   **Ping targets:** `ansible all -m ping -i inventory`
*   **Install Apache:** `ansible web -m apt -a "name=apache2 state=present update_cache=yes" -b -i inventory`
*   **Start/Enable Service:** `ansible web -m service -a "name=apache2 state=started enabled=yes" -b -i inventory`
*   **Copy File:** `ansible web -m copy -a "src=index.html dest=/var/www/html/index.html" -b -i inventory`
*   **Remove Apache:** `ansible web -m apt -a "name=apache2 state=absent" -b -i inventory`
*(Note: `-b` means `become: yes` / sudo)*

## 4. 📜 Ansible Playbooks (Infrastructure as Code)
Playbooks are repeatable scripts written in YAML.

**Simple Apache Playbook (`apache.yml`):**
```yaml
---
- name: Setup Webserver
  hosts: web
  become: yes
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
    - name: Copy index.html
      copy:
        src: index.html
        dest: /var/www/html/index.html
    - name: Start Apache
      service:
        name: apache2
        state: started
```
Essential Playbook Commands:
- Syntax Check: ansible-playbook apache.yml --syntax-check (Finds YAML spacing errors).
- Dry Run (Check Mode): ansible-playbook apache.yml --check (Simulates the changes without actually doing them).
- Run Playbook: ansible-playbook apache.yml

### 5. 📚 Finding Modules (ansible-doc)
DevOps engineers don't memorize modules; we use the built-in manual!
- List all modules: ansible-doc -l
- Get help for a specific module: ansible-doc apt or ansible-doc copy (Press q to quit).
### 6. 🏆 Capstone Assignment: 2-Tier WordPress Deployment
**Goal:** Deploy MariaDB on VM-2 and WordPress/Apache on VM-1 using a single Playbook.
- **Inventory setup:** Defined [web] and [db] groups.
- **Playbook execution:** Used apt, service, replace, mysql_db, and unarchive modules.
- **Result:** Ansible automatically installed dependencies, configured firewall bind-addresses, injected DB credentials via replace, and launched a fully functioning WordPress site across two servers in minutes!

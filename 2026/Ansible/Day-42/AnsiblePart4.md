## Day 42: Intelligent Automation - Facts, Conditionals, Templates & Handlers (May 14, 2026)

### 🧠 1. Ansible Fact Variables & Conditionals (`when`)
Ansible automatically gathers system data (Facts) before running tasks via the `setup` module. We can use this data to make our playbooks intelligent.
- **Fact Variables:** Information like IP addresses, CPU architecture, and OS Family (e.g., `ansible_os_family`).
- **Conditionals (`when`):** Used to execute tasks *only* if a specific condition is met.
  
**Practical Use Case (NTP Server Installation):**
We wrote a single task block that detects the target OS and installs the correct NTP package dynamically!
```yaml
- name: Install NTP on Debian/Ubuntu
  apt:
    name: ntp
    state: present
  when: ansible_os_family == "Debian"

- name: Install NTP on CentOS/RedHat
  yum:
    name: chrony
    state: present
  when: ansible_os_family == "RedHat"
```
### 🔁 2. Ansible Loops
Instead of writing 10 separate tasks to install 10 different packages, we use loops to iterate over a list.
```yaml
- name: Install multiple packages
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - git
    - curl
    - vim
```
### 🗂️ 3. Centralizing Variables (group_vars)
To keep playbooks clean, we moved global variables out of the playbook and into a dedicated directory.
- Created group_vars/all.yml. Variables defined here are automatically applied to ALL hosts in the inventory.
- Best Practice: This is where we store global settings like standard ports, timezone configs, or default usernames.

### 📝 4. File Manipulation (copy & lineinfile)
Configured the MOTD (Message of the Day) that users see when they SSH into the servers.
- copy Module: Pushed a custom message text file to /etc/motd.
- lineinfile Module: This is a surgical tool! Instead of replacing a whole file, we used it to find the specific line Banner none in the /etc/ssh/sshd_config file and change it to Banner /etc/motd.

### 📄 5. Ansible Templates (Jinja2)
The copy module pushes static files. The template module pushes dynamic files using Jinja2 (.j2) formatting.
- Created an ntp.conf.j2 file.
- Passed variables from our playbook to dynamically generate the NTP configuration file for the Asia Timezone pool on the fly, tailoring it specifically for each target server before copying it over.

### ⚡ 6. Ansible Handlers (Idempotency Optimization)
If we change a configuration file (like ntp.conf), we must restart the service. But we only want to restart it if the file actually changed.
- The Solution: Handlers!
- We added a notify: Restart NTP directive to the template task.
- The handler only triggers at the end of the playbook, and only if the preceding task reported a changed state. This saves massive amounts of time and prevents unnecessary service interruptions!
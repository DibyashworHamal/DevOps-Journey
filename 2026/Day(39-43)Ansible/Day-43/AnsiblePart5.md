## Day 43: Ansible Roles, Ansible Galaxy, Vault Security & Tower (May 15, 2026)

### 📂 1. Modularizing Infrastructure with Ansible Roles
Writing a 500-line playbook is bad practice. Roles allow us to break a monolithic playbook into clean, reusable, and sharable components.
- **Initialization:** Created the skeleton structure using `ansible-galaxy role init firstrole`.
- **Visualization:** Used `sudo apt install tree` and ran `tree firstrole/` to see the generated hierarchy.

**Refactoring our Playbook (`provisioning.yml`):**
We dismantled our previous monolithic playbook and distributed its parts into the `firstrole` directory:
- Moved tasks to `tasks/main.yml`.
- Moved handlers to `handlers/main.yml`.
- Moved `.j2` template files to `templates/`.
- Moved global variables (`group_vars/all.yml`) to `defaults/main.yml`.
- *Result:* Our main `provisioning.yml` file is now incredibly clean—it simply calls `- roles: - firstrole` and dynamically executes the entire orchestrated structure!

### 🌌 2. Ansible Galaxy
Ansible Galaxy is the global hub for finding and sharing Ansible roles.
- **Commands:** Explored `ansible-galaxy role --help`.
- **Usage:** Instead of writing complex tasks (like installing an Nginx cluster) from scratch, we can pull battle-tested, pre-written roles from the Ansible Galaxy community. We also explored how to package and push our own custom roles to Galaxy for public use.

### 🔐 3. DevSecOps: Ansible Vault
Never store plain-text passwords or sensitive server IPs in GitHub! Ansible Vault encrypts files using AES-256 cryptography.

**Core Commands:**
- `ansible-vault encrypt inventory` : Secures the file.
- `ansible-vault decrypt inventory` : Unlocks it for editing.
- `ansible-vault edit inventory` : Edits an encrypted file on the fly.

**Executing Encrypted Playbooks:**
If the inventory is encrypted, Ansible will fail unless we provide the decryption key.
- *Method 1 (Manual):* `ansible-playbook provisioning.yml -i inventory --ask-vault-pass`
- *Method 2 (Automated):* `ansible-playbook provisioning.yml -i inventory --vault-password-file=test` (Where `test` is a secure file containing the password).

**The Enterprise Setup:**
We updated `ansible.cfg` to include `vault_password_file = ./test`. Now, Ansible automatically looks for the password file and decrypts the inventory seamlessly when we run our playbook!

### 🗼 4. Ansible Tower (AWX) Overview
Wrapped up by discussing the enterprise UI for Ansible: **Ansible Tower** (or its upstream open-source version, AWX).
- Provides a web-based console, REST API, visual dashboards, Role-Based Access Control (RBAC), and job scheduling for massive infrastructure management.
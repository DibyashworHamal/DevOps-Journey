## Day 15: Automated VM Provisioning with Vagrant (Mar 26, 2026)

### 🚀 1. What is Vagrant and Why Do We Need It?
Before today, we created VMs manually using the VirtualBox GUI. This is slow, non-repeatable, and prone to human error.
- **What is Vagrant?** An open-source tool by HashiCorp used to build and manage virtual machine environments via a simple configuration file.
- **Why we need it:** It provides reproducible environments. By sharing a single text file (`Vagrantfile`), my entire development team can spin up the exact same Linux server with the exact same configurations in minutes. No more "It works on my machine!"

### 🌐 2. Vagrant Networking (`Vagrantfile` Configs)
We explored how to configure the network directly inside the `Vagrantfile` without touching VirtualBox settings.

1. **NAT (Forwarded Ports):** The default. Maps a port on the host machine to a port on the guest VM.
   - *Example:* `config.vm.network "forwarded_port", guest: 80, host: 8080`
2. **Host-Only (Private Network):** Assigns an IP address to the VM that is only accessible from the Host machine.
   - *Example:* `config.vm.network "private_network", ip: "192.168.33.10"`
3. **Bridged Adapter (Public Network):** The VM gets an IP from the physical router, making it accessible to anyone on the local Wi-Fi/LAN.
   - *Example:* `config.vm.network "public_network"`

### ⌨️ 3. Essential Vagrant Command Cheat Sheet
Vagrant replaces the need to open the VirtualBox application. Everything is done in the terminal.

| Command | Description |
| :--- | :--- |
| `vagrant --version` | Checks the installed version of Vagrant. |
| `vagrant init` | Initialize Vagrantfile on current directory. |
| `vagrant validate` | Checks the `Vagrantfile` for syntax errors before running it. |
| `vagrant up` | **The Magic Command:** Downloads the OS image (box), configures the VM, and boots it up. |
| `vagrant status` | Shows the current state of the VM (running, powered off, aborted). |
| `vagrant ssh` | Instantly SSH into the VM without needing to configure keys manually! |
| `vagrant halt` | Gracefully shuts down the VM. |
| `vagrant destroy` | Deletes the VM and frees up the hard drive space. |

### 🛠️ 4. Practical Implementation
- Downloaded and installed Vagrant.
- Initialized a default VM.
- Edited the `Vagrantfile` to configure networking.
- Successfully booted and SSH'd into the machine purely via CLI.
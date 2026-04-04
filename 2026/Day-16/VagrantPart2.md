## Day 16: Advanced Vagrant - Provisioning, Synced Folders & Multi-Machine Setup (Mar 29, 2026)

### 📦 1. Vagrant Boxes (`bento/ubuntu-24.04`)
- Instead of downloading massive ISO files manually, Vagrant uses pre-packaged environments called "Boxes".
- **Bento Boxes:** Open-source Vagrant boxes built by Chef. They are highly optimized and minimal.
- **Command:** `vagrant init bento/ubuntu-24.04`

### 🔄 2. Synced Folders
Synced folders allow sharing a directory between the Host machine (Windows) and the Guest machine (Linux VM).
- **Why?** You can write HTML/Code in VS Code on your Windows laptop, and the Apache server inside the Linux VM serves it instantly without manually copying files!
- **Syntax:** `config.vm.synced_folder "./host_data", "/var/www/html"`

### ⚙️ 3. Hardware Allocation (CPU & RAM)
By default, Vagrant allocates minimal resources. We can customize this via the VirtualBox provider block.

config.vm.provider "virtualbox" do |vb|
  vb.memory = "2048"  # Allocate 2GB RAM
  vb.cpus = 2         # Allocate 2 CPU Cores
end

### 4. Provisioning (Automating Deployments)
Provisioners run scripts automatically after the VM boots up for the very first time.

#### A. Inline Shell Provisioning:
config.vm.provision "shell", inline: <<-SHELL
  sudo apt-get update
  sudo apt-get install apache2 -y
SHELL

#### B. External Script Provisioning (Beat Practice):
Instead of writing long bash scripts inside the Vagrantfile, we keep them in a separate file (e.g., setup.sh).

config.vm.provision "shell", path: "setup.sh"

### 5. Multi-Machine Setup (Simulating Clusters)
A single Vagrantfile can spin up an entire network of servers (e.g., a Web Server and a Database Server).
Vagrant.configure("2") do |config|
  # Machine 1: Web Server
  config.vm.define "web" do |web|
    web.vm.box = "bento/ubuntu-24.04"
    web.vm.network "private_network", ip: "192.168.56.10"
  end

  # Machine 2: DB Server
  config.vm.define "db" do |db|
    db.vm.box = "bento/ubuntu-24.04"
    db.vm.network "private_network", ip: "192.168.56.11"
  end
end

To start only the web server: vagrant up web
To start both: vagrant up
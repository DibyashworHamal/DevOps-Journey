Vagrant.configure("2") do |config|

  # ==========================================
  # VM 1: The Web Server (Apache + WordPress)
  # ==========================================
  config.vm.define "web" do |web|
    web.vm.box = "bento/ubuntu-24.04"
    web.vm.hostname = "web-server"
    
    # Give it a static Private IP so the DB can talk to it
    web.vm.network "private_network", ip: "192.168.56.10"
    
    # Allocate RAM and CPU
    web.vm.provider "virtualbox" do |vb|
      vb.name = "Web_Node"
      vb.memory = "1024"
      vb.cpus = 1
    end
    web.vm.provision "shell" , path: "scripts/install_web"  
  end

  # ==========================================
  # VM 2: The Database Server (MySQL/MariaDB)
  # ==========================================
  config.vm.define "db" do |db|
    db.vm.box = "bento/ubuntu-24.04"
    db.vm.hostname = "db-server"
    
    # Give it a DIFFERENT static Private IP
    db.vm.network "private_network", ip: "192.168.56.11"
    
    # Allocate RAM and CPU
    db.vm.provider "virtualbox" do |vb|
      vb.name = "DB_Node"
      vb.memory = "1024"
      vb.cpus = 1
    end
    db.vm.provision "shell" , path: "scripts/install_db"
  end

end

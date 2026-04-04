## Day 5: SSH Security & Storage Management (Feb 23, 2026)

### 1. Secure Shell (SSH) Implementation
Today we set up a secure, remote connection between the Host (Windows) and Guest (Linux VM).

#### **Installation & Configuration**
1.  **Update Package Index:** `sudo apt update`
2.  **Install OpenSSH:** `sudo apt install openssh-server`
3.  **Check Status:** `sudo systemctl status ssh`
4.  **Enable on Boot:** `sudo systemctl enable ssh`

#### **Firewall Configuration (UFW)**
To allow traffic on Port 22:
sudo ufw allow ssh
sudo ufw enable
sudo ufw status

### Configuring SSH Daemon
Edited the config file at /etc/ssh/sshd_config
After changes, reloaded the service:

sudo systemctl daemon-reload
sudo systemctl restart ssh

###  Passwordless Authentication (SSH Keys)
Moving away from passwords to Key Pairs for automation and security.

Step 1: Generate Keys (On Windows Host)
Using Git Bash:
ssh-keygen -t ed25519 -C "my-key"
This creates a Public Key (Lock) and Private Key (Key)

Step 2: Copy Public Key to Server
ssh-copy-id -i ~/.ssh/id_ed25519.pub username@<vm_ip_address>
Result: I can now login using ssh username@<ip> without being asked for a password.

### Linux Storage & File Systems

Partitioning Schemes
MBR (Master Boot Record): Older. Max 4 Primary partitions. Max 2TB drive size.
GPT (GUID Partition Table): Newer (UEFI). Unlimited partitions. Handles huge drives.
LVM (Logical Volume Manager)
A layer of abstraction between the OS and the Hard Drive.
Why use it? Unlike traditional partitions, LVM allows us to resize (expand/shrink) storage volumes on the fly without unmounting.
Structure: Physical Volume (PV) -> Volume Group (VG) -> Logical Volume (LV).
File Systems & Mounting
Types: EXT4 (Standard Linux), NTFS (Windows), FAT32 (Universal/USB).
Mounting: Attaching a storage device to a specific directory in the File System Hierarchy so the OS can read/write to it.
Swap Space: A dedicated partition or file used as "Virtual RAM" when physical RAM is full.
   Practical Labs
Created two VMs: One using standard partitioning, one using LVM.
Configured VirtualBox Network Adapters (NAT + Bridged).
Demonstrated Absolute Path (/home/user/file) vs Relative Path (./file).
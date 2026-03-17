# My DevOps-Journey

Documentation of my learning path at Tech Axis to becoming a DevOps Engineer.

## Day 1: Orientation
- Introduction to the current IT landscape in Nepal.
- Career Roadmap by Er. Sailesh Nepal.

## Day 2: DevOps Fundamentals & Lifecycle (Feb 19, 2026)

### 1. What is DevOps?
DevOps is a set of practices, tools, and a cultural philosophy that automates and integrates the processes between software development (Dev) and IT teams (Ops).
- **Goal:** Shorten the systems development life cycle and provide continuous delivery with high software quality.

### 2. The DevOps Lifecycle (The Infinity Loop)
1.  **Plan:** Define business value and requirements.
2.  **Code:** Design and software development (Git).
3.  **Build:** Automated builds and version control (Maven/Gradle).
4.  **Test:** Continuous testing for quality assurance (JUnit/Selenium).
5.  **Release:** Manage, schedule, and approve releases (Jenkins).
6.  **Deploy:** Automated deployment to production (Docker/Kubernetes).
7.  **Operate:** Manage infrastructure and software (Ansible/Terraform).
8.  **Monitor:** Track performance and end-user experience (Nagios/Prometheus).

### 3. Key Concepts & Terms
- **CI (Continuous Integration):** Developers frequently merge code changes into a central repository where automated builds and tests run.
- **CD (Continuous Deployment):** Code changes are automatically deployed to a production environment after passing tests.
- **Configuration Management:** Managing server settings via code (Infrastructure as Code) to ensure consistency.
- **Configuration Monitoring:** Continuously checking if the system performance matches the desired state.

### 4. Agile vs. DevOps
- **Agile:** Focuses on processes, adaptability, and customer feedback during *development*.
- **DevOps:** Focuses on automation, stability, and delivery during *deployment and operations*.

### 5. Role of a DevOps Engineer
- Bridging the gap between Dev and Ops.
- Automating repetitive tasks.
- Ensuring system reliability and scalability.
- **Challenges:** Handling legacy systems, security integration (DevSecOps), and cultural resistance to change.

###  Next Steps
- **Practical Lab Setup:** Installing Oracle VirtualBox.
- **OS Installation:** Setting up Linux (Ubuntu 24.04.4 LTS) to begin CLI training.

## Day 3: Lab Setup & Linux Networking (Feb 20, 2026)

### Environment Setup
Today, we set up the virtual lab that will be used for the rest of the course.
- **Hypervisor:** Oracle VirtualBox
- **Guest OS:** Ubuntu 24.04.4 LTS ISO
- **Host OS:** Windows

### Networking Concepts: NAT vs. Bridged
One of the most important parts of setting up a VM is networking.
1. **NAT (Network Address Translation):**
   - The VM shares the Host's IP address.
   - Good for browsing the internet from inside the VM.
   - **Downside:** The outside world (and my Host PC) cannot easily talk *in* to the VM.
2. **Bridged Adapter:**
   - The VM connects directly to the Router (Wi-Fi/LAN).
   - IT gets its own unique IP Address on the local network.
   - **Benefit:** I can ping and SSH into the Linux VM directly from my windows Terminal (Powershell/CMD), just like a real production server.

### Essential Linux Commands Executed
| Command | Description |
| :--- | :--- |
| `sudo apt update` | Updates the list of available packages and their versions (does not install anything). |
| `sudo apt upgrade` | Installs the newer versions of the packages you have. |
| `ip a` | Shows IP addresses and network interfaces (Modern replacement for `ifconfig`). |
| `clear` | Clears the terminal screen. |
| `exit` | Logs out of the shell. |
| `sudo poweroff` | Safely shuts down the system. |
| `init 0` | Another way to shut down (Changes system runlevel to 0). |  

### Key Takeaway
Running 'sudo apt update' **before** 'sudo apt upgrade' is mandatory.
You must refresh the catalog before you buy the producths!

## Day 4: Linux Architecture & SSH Security (Feb 22, 2026)

### Virtualization Deep Dive
Today we explored the architecture behind our lab environment.
- **Hypervisor:** The software that creates and runs Virtual Machines (VMs).
  - *Type 1 (Bare Metal):* Installs directly on hardware (e.g., VMware ESXi). Used in Production.
  - *Type 2 (Hosted):* Installs on an OS (e.g., VirtualBox, VMware Workstation). Used in our Lab.
- **Resource Allocation:** Assigning CPU, RAM, and Storage to VMs.
- **Storage Provisioning:**
  - *Thin Provisioning (Dynamically Allocated):* Uses storage only as data is written. Saves space.
  - *Thick Provisioning (Fixed Size):* Allocates all storage upfront. Better performance but wastes space.
- **Snapshots:** A "save point" for the VM state. Crucial before making risky configuration changes.

### Linux File System Hierarchy (FHS)
Unlike Windows (C:\, D:\), Linux uses a tree structure starting from Root (`/`).
- `/` : Root directory.
- `/bin` & `/sbin` : Essential user and system binaries (commands like `ls`, `ip`).
- `/etc` : Configuration files (where the system settings live).
- `/home` : User personal directories.
- `/var` : Variable data files (logs, temporary files).
- `/root` : The superuser's home directory.

### Pathnames
- **Absolute Path:** The full address starting from Root `/` (e.g., `/home/dibyashwor/projects`).
- **Relative Path:** The address starting from the *current* directory (e.g., `./projects/script.sh`).

### SSH (Secure Shell) & Key Pairs
SSH is the standard protocol for accessing remote servers securely.
- **Why Key Pairs?** Using passwords is risky and hard to automate. SSH Keys allow secure, passwordless login.
- **Public Key:** Like a padlock. You put this on the server (Linux VM).
- **Private Key:** Like the key. You keep this safe on your local machine (Windows).
- **Authentication:** The server checks if your Private Key fits the Public Key lock.

### Practical Labs
1.  **Network Configuration:** Configured VirtualBox with multiple adapters (NAT for internet, Bridge for local access).
2.  **IP Verification:** Used `ip a` to inspect interfaces (`enp0s3`, `enp0s8`).
3.  **Snapshotting:** Took a snapshot of the clean Ubuntu state to revert changes if I break the system later.

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

## Day 6: Advanced Storage Management (MBR, GPT & LVM) (Feb 24, 2026)

### 1. Partitioning Schemes: MBR vs. GPT
Before using a hard disk, it must be partitioned. We explored the two main standards:

| Feature | **MBR (Master Boot Record)** | **GPT (GUID Partition Table)** |
| :--- | :--- | :--- |
| **Architecture** | Legacy (BIOS) | Modern (UEFI) |
| **Max Size** | 2 TB Limit | 18 Exabytes (Unlimited for now) |
| **Partitions** | Max 4 Primary (or 3 Primary + 1 Extended) | 128 Primary Partitions |
| **Reliability** | Stored in one place (Risk of corruption) | Redundant (Stored at start & end of disk) |

### 2. LVM (Logical Volume Manager) Architecture
LVM provides a layer of abstraction between the physical disk and the file system, allowing for dynamic resizing.

**The 3 Layers of LVM:**
1.  **PV (Physical Volume):** The raw hard disk or partition (`/dev/sdb1`).
2.  **VG (Volume Group):** A pool of storage created by combining multiple PVs. Think of it as a "Virtual Hard Drive."
3.  **LV (Logical Volume):** The usable partitions cut from the VG. These can be resized on the fly.

### 3. LVM Command Cheat Sheet
| Action | Command |
| :--- | :--- |
| **Create PV** | `sudo pvcreate /dev/sdb1` |
| **Create VG** | `sudo vgcreate my_vol_group /dev/sdb1` |
| **Create LV** | `sudo lvcreate -L 10G -n my_logical_vol my_vol_group` |
| **Format LV** | `sudo mkfs.ext4 /dev/my_vol_group/my_logical_vol` |
| **Mount** | `sudo mount /dev/my_vol_group/my_logical_vol /mnt/data` |
| **Extend LV** | `sudo lvextend -L +5G /dev/my_vol_group/my_logical_vol` |

### 4. Assignment: GPT & Swap Configuration
- **GPT Implementation:** Unlike `fdisk` (used for MBR), GPT uses `gdisk` or `parted`.
- **Swap Space:** "Virtual RAM" on the hard disk.
    - **Create:** `sudo mkswap /dev/sdc1`
    - **Enable:** `sudo swapon /dev/sdc1`
    - **Verify:** `free -h`

## Day 7: LVM Architecture and GPT Implementation (Feb 25, 2026)

### LVM Architecture Explained (The Diagram)
Today, we practically implemented the LVM hierarchy. The core concept is **Abstract** decoupling the storage from the physical hardware.

Based on the architecture diagram studied:
1. **Physical Layer (Bottom):**
   - **HDD 1, HDD2, HDD3:** The raw physical hard drives attached to the server.
   - **PV (Physical Volumes):** We initialized these drives (`/dev/sda2`, `/dev/sdb1`, `/dev/sdc1`) to be used by LVM.

2. **Volume Group Layer (Middle - The Pool):**
   - **Aggregation:** We combined **HDD 2** and **HDD 3** into a single Volume Group named **`vg-data`**
   - *Engineering Insight:* This allows us to create a storage pool larger than any single physical disk!

3. **Logical Layer (Top - The Usage):**
   - **LV (Logical Volumes):** We carved out virtual partitions like `root LV`, `swap LV`, and `lv-data LV`.
   - **Mount Points:** Finally, we mounted these LVs to directories (`/`, `/swap`, `/vg-data/lv-data`) so the OS can store files.

### GPT (GUID Partition Table)
We moved beyond MBR and implemented GPT particals:
- **Why GPT?** It supports drives larger than 2TB and allows 128 primary partitions.
- **Tool:** Used `gdisk` (instead of `fdisk`) to create partitions.

### Practical Commands Log
**1. Creating the Physical Volume**

sudo pvcreate /dev/sdb /dev/sdc # Initializing the raw disks
sudo pvs                        # Verify

**2. Creating the Volume Group (Pooling)**

sudo vgcreate vg-data /dev/sdb /dev/sdc  # Combining disks into one pool
sudo vgs                                 # Verify

**3. Creating the Logical Volume**

sudo lvcreate -L 5G -n lv-data vg-data   # Carving out 5GB from the pool
sudo lvs                                 # Verify

**4. Formatting and Mounting**

sudo mkfs.ext4 /dev/vg-data/lv-data      # Applying Filesystem
sudo mkdir /mnt/project_data             # Creating entry point
sudo mount /dev/vg-data/lv-data /mnt/project_data  # Linking them

### Key Takeaway
LVM allows us to extend vg-data by simply plugging in a new Hard Drive (HDD 4) and adding it to the group. This provides infinite scalability without downtime.

## Day 8: Linux Boot Process and System Initialization (Feb 26, 2026)

### 1. The Linux Boot Process (Architecture)
Today we demystified exactly what happens from the moment we press "Power On" to the Login Screen.

**The 6 Stages of Booting:**
1.  **BIOS/UEFI (Basic Input/Output System):**
    -   Performs **POST** (Power-On Self Test) to check hardware (RAM, Disk).
    -   Locates the Boot Device (HDD/SSD).
2.  **MBR/GPT (Master Boot Record):**
    -   Located at the very first sector of the disk. It tells the system *where* the Bootloader is.
3.  **Bootloader (GRUB2):**
    -   Grand Unified Bootloader. It shows the menu to select the OS (Kernel).
    -   Loads the Kernel into RAM.
4.  **Kernel:**
    -   The core of the OS. It mounts the Root Filesystem (`/`) and initializes hardware drivers.
    -   It starts the very first process: **`systemd`** (or `init`).
5.  **Init / Systemd (PID 1):**
    -   The parent of all processes. It reads configuration files and starts services (Network, UI, SSH).
6.  **Runlevel / Target:**
    -   The system reaches the desired state (e.g., Graphical UI or Command Line).

### 2. Init vs. Systemd
We compared the legacy system with the modern standard.

| Feature | **SysVinit (Legacy)** | **Systemd (Modern)** |
| :--- | :--- | :--- |
| **Process ID** | PID 1 | PID 1 |
| **Execution** | Serial (One by one) | Parallel (Faster booting) |
| **Scripts** | Shell Scripts (`/etc/init.d`) | Unit Files (`.service`) |
| **Command** | `service httpd start` | `systemctl start httpd` |

### 🎯 3. Runlevels vs. Targets
Linux works in different "modes." In Systemd, these are called **Targets**.

| Runlevel (Old) | Systemd Target (New) | Description |
| :--- | :--- | :--- |
| **0** | `poweroff.target` | Shut down the system. |
| **1** | `rescue.target` | Single-user mode (Repair mode). |
| **3** | `multi-user.target` | CLI Mode (Server mode, no Graphics). |
| **5** | `graphical.target` | GUI Mode (Desktop). |
| **6** | `reboot.target` | Restart the system. |

### 🛠️ 4. Managing Services (Daemons)
A **Daemon** is a background process (like `sshd` or `mysqld`).
-   **Start:** `sudo systemctl start ssh`
-   **Stop:** `sudo systemctl stop ssh`
-   **Enable (Auto-start on boot):** `sudo systemctl enable ssh`
-   **Check Status:** `sudo systemctl status ssh`

### 🧪 Practical Commands
-   **Check current target:** `systemctl get-default`
-   **Switch to CLI mode instantly:** `sudo systemctl isolate multi-user.target`
-   **Shutdown:** `sudo shutdown -h now` or `init 0`
-   **Reboot:** `sudo reboot` or `init 6`    

## Day 9: User & Group Administration (Feb 27, 2026)

### 1. User Administration Architecture
Linux is a multi-user system. We explored how users are stored and managed.

**The Database: `/etc/passwd`**
This file stores user account information. It consists of **7 Fields** separated by colons (`:`):
`root:x:0:0:root:/root:/bin/bash`

1.  **Username:** Login name (e.g., `root`, `dibyashwor`).
2.  **Password:** Represented by `x` (The encrypted hash is actually stored in `/etc/shadow`).
3.  **UID (User ID):** Unique number (0 for root, 1000+ for normal users).
4.  **GID (Group ID):** The primary group ID.
5.  **Comment (GECOS):** Full name or description.
6.  **Home Directory:** Where the user lands after login (`/home/abc`).
7.  **Shell:** The command interpreter (`/bin/bash` or `/bin/sh`).

### 2. Password Aging & Security
Managed via the `chage` command or `/etc/shadow`.
-   **Policies:** Setting minimum days between changes, maximum validity, and warning periods.
-   **Why?** To force users to rotate passwords regularly for security.

### 3. Group Administration
-   **Primary Group:** The default group assigned to a file created by the user.
-   **Secondary Group:** Additional groups a user belongs to (e.g., `docker`, `sudo`, `admin`).
-   **Commands:** `groupadd`, `groupmod`, `groupdel`.

### 4. File Permissions & Ownership
Every file in Linux has an Owner (User) and a Group owner.

**The Permission String:** `drwxr-xr--`
-   **Types:** `r` (Read), `w` (Write), `x` (Execute).
-   **Levels:** `u` (User/Owner), `g` (Group), `o` (Others).

**Permission Methods:**
1.  **Symbolic:** `chmod u+x file.sh` (Give Execute to User).
2.  **Numeric (Octal):**
    -   Read = 4, Write = 2, Execute = 1.
    -   Example: `chmod 755 file` (rwx for User, rx for Group/Others).

### 5. Umask (User File Creation Mask)
Umask determines the *default* permissions for new files/directories.
-   **Base Permission:** Directory (777), File (666).
-   **Formula:** Final Permission = Base - Umask.
-   *Example:* If Umask is `022`, new directories are `755` (`777 - 022`).

### Practical Commands Log
| Action | Command |
| :--- | :--- |
| **Add User** | `sudo useradd -m -s /bin/bash abc` |
| **Set Password** | `sudo passwd abc` |
| **Modify User** | `sudo usermod -aG sudo abc` (Add to sudo group) |
| **Delete User** | `sudo userdel -r abc` (Remove home dir too) |
| **Check Aging** | `sudo chage -l abc` |
| **Change Owner** | `sudo chown dibyashwor:devs file.txt` |
| **Switch User** | `su - abc` |

## Day 11: Linux Basic Commands & The VIM Editor Deep Dive (Mar 15, 2026)

### 💻 1. Basic Linux Navigation & File Management
Today, we mastered moving around the Linux file system purely through the CLI.

| Category | Commands | Description |
| :--- | :--- | :--- |
| **Navigation** | `pwd` | Print Working Directory (where am I?). |
| | `cd /path` | Change directory. (`cd ..` to go up, `cd ~` for home directory). |
| **List Files** | `ls -al` | List all files (including hidden) with detailed info. |
| | `ls -lh` | List with human-readable file sizes (KB, MB). |
| | `ls -t` / `ls -r` | Sort by time modified / Reverse order. |
| **File Creation** | `touch file.txt` | Create an empty file. |
| | `mkdir -p /a/b` | Create a directory (and parent directories if needed). |
| **Copy & Move** | `cp -r dir1 dir2` | Copy directories recursively. |
| | `mv file1 file2` | Move or rename a file/directory. |
| **Remove** | `rm -r dir1` | Remove a directory recursively. |
| | `rm -rf *` | ⚠️ **DANGEROUS:** Force remove everything in current directory. |

### 📖 2. Reading System Documentation
Never memorize everything; learn how to find the answers!
-   `man cp` : Opens the manual page for the `cp` command.
-   `cp --help` : Quick syntax help.
-   `apropos directory` : Searches the manual for commands related to "directory".
-   `info bash` : Detailed info pages.

---

### 🔥 3. VIM Editor Cheat Sheet (Visual Display Improved)
VIM is the most powerful terminal-based text editor. You must rely on the keyboard, not the mouse.

#### **A. The 4 Modes of VIM**
1.  **Normal (Command) Mode (`ESC`):** Default mode. Used for navigation and manipulation.
2.  **Insert Mode (`i`):** Used to type text like a normal editor.
3.  **Visual Mode (`v`):** Used to highlight/select text.
4.  **Extended/Colon Mode (`:`):** Used to save, quit, and configure VIM.

#### **B. Navigation (Normal Mode)**
| Key | Action |
| :--- | :--- |
| `h`, `j`, `k`, `l` | Move Left, Down, Up, Right (Faster than arrow keys!). |
| `w` / `b` / `e` | Move to next word / beginning of word / end of word. |
| `0` / `$` | Move to the beginning / end of the current sentence. |
| `gg` / `G` | Move to the top / bottom of the entire file. |
| `2G` | Go specifically to line number 2. |

#### **C. Editing & Deleting (Normal Mode)**
| Key | Action |
| :--- | :--- |
| `3i god ESC` | Inserts "godgodgod" (Multiplier effect). |
| `x` / `X` | Delete character under cursor / to the left of cursor. |
| `r` | Replace the single character under the cursor. |
| `dd` / `3dd` | Delete (Cut) the current line / Delete 3 lines. |
| `yy` / `3yy` | Yank (Copy) the current line / Copy 3 lines. |
| `p` / `P` | Paste below / Paste above the cursor. |
| `u` / `Ctrl+r` | Undo the last change / Redo the change. |

#### **D. Extended Command Mode (`ESC` + `:`)**
| Command | Action |
| :--- | :--- |
| `:w` | Save (Write). |
| `:q!` | Quit forcefully (Discard changes). |
| `:wq!` | Save and Quit forcefully. |
| `:se nu` | Show line numbers. |
| `:se nonu` | Hide line numbers. |
| `/text` | Search for "text" in the file (`n` for next, `N` for previous). |

## Day 12: Advanced VIM & Text Processing Power Tools (Mar 16, 2026)

### 📄 1. File Viewing & Inspection
Instead of opening heavy files in an editor, we use these tools to inspect data directly from the terminal.

| Command | Description | Practical Example |
| :--- | :--- | :--- |
| `cat` | Concatenate and print files. | `cat config.yml` |
| `head` | Print the first 10 lines of a file. | `head -n 20 /var/log/syslog` (Shows top 20) |
| `tail` | Print the last 10 lines. **Crucial for Logs.** | `tail -f /var/log/nginx/access.log` (Follows logs in real-time!) |
| `more` | View text one screen at a time (forward only). | `more largefile.txt` |
| `less` | View text with backward & forward navigation. | `less largefile.txt` (Press `q` to quit) |
| `wc` | Word count (lines, words, bytes). | `wc -l file.txt` (Counts total lines) |

### 🔍 2. Searching for Files
When you lose a configuration file in the Linux hierarchy, these tools find it.

- **`locate`**: Very fast. Searches a pre-built database.
  - *Example:* `locate sshd_config`
  - *Note:* Requires running `sudo updatedb` to refresh the database.
- **`find`**: Slower but immensely powerful. Searches the live file system.
  - *Example:* `find /etc -name "nginx.conf"` (Finds file by name in /etc)
  - *Example:* `find /var/log -type f -mtime -7` (Finds files modified in the last 7 days)

### 🛠️ 3. The Big Four: Text Manipulation & Filtering
These are the most powerful tools for a DevOps engineer parsing logs or writing bash scripts.

#### **A. `grep` (Global Regular Expression Print)**
Filters text and finds matching patterns.
- `grep "ERROR" /var/log/syslog` : Prints all lines containing "ERROR".
- `grep -i "error" file.txt` : Case-insensitive search.
- `grep -v "INFO" file.txt` : Inverse search (prints everything EXCEPT "INFO").

#### **B. `cut`**
Extracts specific sections (columns/fields) from lines of text.
- `cut -d':' -f1 /etc/passwd` : Uses colon (`:`) as delimiter and extracts the 1st field (List of all usernames).

#### **C. `sed` (Stream Editor)**
Used for finding and replacing text on the fly.
- `sed 's/old_word/new_word/g' file.txt` : Replaces "old_word" with "new_word" globally (`g`).
- `sed -i 's/8080/80/g' server.conf` : The `-i` flag edits the file directly and saves it.

#### **D. `awk`**
A complete text-processing programming language. Great for tabular data.
- `awk '{print $1, $3}' file.txt` : Prints the 1st and 3rd columns of a file separated by spaces.
- `ls -l | awk '{print $9}'` : Lists files and pipes output to awk to print only the file names (9th column).

### ⌨️ 4. Advanced VIM
Continued building muscle memory in VIM, combining text manipulation commands with VIM's internal search (`/`) and replace (`:%s/old/new/g`) functionalities.
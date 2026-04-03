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

## Day 13: File Systems, Links, I/O Redirection & Package Management (Mar 18, 2026)

### 🔗 1. Inodes and Linux Links
Every file in Linux has an **Inode** (Index Node). An inode stores metadata about the file (permissions, owner, size) and points to the actual data blocks on the hard drive. *It does not store the file name.*

**Hard Links vs. Soft Links:**
| Feature | Hard Link | Soft (Symbolic) Link |
| :--- | :--- | :--- |
| **Command** | `ln source_file link_name` | `ln -s source_file link_name` |
| **How it works** | Points directly to the same **Inode** as the original. | Points to the **path/name** of the original file (like a Windows Shortcut). |
| **If original is deleted**| Hard link **still works** (data is safe until all links are deleted). | Soft link **breaks** (becomes a dangling link). |
| **Directories** | Cannot link directories. | Can link directories. |
| **File Systems** | Must be on the same partition/file system. | Can cross different file systems. |

*Check inodes using:* `ls -li` (The first number is the Inode ID).

### 📁 2. The 7 Types of Files in Linux
In Linux, everything (even your mouse and hard drive) is treated as a file. You can identify the file type by looking at the **first character** of the `ls -l` output.

1. **`-` (Regular File):** Standard files like text, images, or executables (`-rw-r--r--`).
2. **`d` (Directory):** A folder containing other files (`drwxr-xr-x`).
3. **`l` (Linked File):** A symbolic (soft) link to another file.
4. **`c` (Character Device):** Unbuffered devices transmitting data character-by-character (e.g., keyboards, mice, `/dev/tty`).
5. **`b` (Block Device):** Buffered devices transmitting data in blocks (e.g., hard drives, `/dev/sda`).
6. **`s` (Local Domain Socket):** Used for Inter-Process Communication (IPC) between applications.
7. **`p` (Named Pipe):** Acts as a FIFO (First In, First Out) pipeline for connecting processes.

### 🔄 3. I/O Redirection (Input/Output)
Linux uses three standard data streams: **stdin (0)**, **stdout (1)**, and **stderr (2)**. Redirection allows us to control where the output of a command goes.

- `>` : Redirect standard output to a file (**Overwrites** the file).
  - *Example:* `echo "Hello" > file.txt`
- `>>` : Redirect standard output to a file (**Appends** to the file).
  - *Example:* `echo "World" >> file.txt`
- `2>` : Redirect standard **error** to a file.
  - *Example:* `ls /fake_dir 2> error.log`
- `&>` or `> file 2>&1` : Redirect BOTH standard output and standard error to the same file.
- `<` : Redirect standard input from a file.
  - *Example:* `wc -l < file.txt`

### 📦 4. Package Management (`apt` vs `dpkg`)
In Debian/Ubuntu-based systems, we manage software using two main tools.

**`dpkg` (Debian Package - Low Level):**
Installs local `.deb` files directly. *Does not resolve dependencies automatically.*
- Install: `sudo dpkg -i package_name.deb`
- Remove: `sudo dpkg -r package_name`

**`apt` (Advanced Package Tool - High Level):**
Fetches packages from internet repositories. *Automatically resolves and installs dependencies.*
- Update list: `sudo apt update`
- Install: `sudo apt install nginx`
- Remove: `sudo apt remove nginx`
- Clean up unused dependencies: `sudo apt autoremove`

## Day 15: Sudo, Process Management & Intro to Bash Scripting (Mar 24, 2026)

### 🔐 1. Deep Dive into `sudo` and Privilege Escalation
In enterprise environments, giving users full `root` access is dangerous. We use `sudo` to grant specific administrative privileges.
- **`visudo`:** The ONLY safe way to edit the `/etc/sudoers` file. It checks for syntax errors before saving. If you edit `/etc/sudoers` with `vim` and make a typo, you could permanently lock yourself out of root!
- **`/etc/sudoers.d/`:** A directory to place custom sudo rules for specific users/groups without cluttering the main sudoers file. (e.g., granting a developer permission to restart the web server, but nothing else).

### ⚙️ 2. Process and Service Management
Monitoring server health and finding rogue processes.
- **`top`:** Real-time, dynamic view of running processes (CPU, RAM usage).
- **`ps aux` (BSD Syntax):** Shows all processes for all users, with detailed stats (Memory/CPU %).
- **`ps -ef` (System V Syntax):** Shows all processes with full command-line arguments and Parent Process IDs (PPID). Great for tracing process trees.

### 📜 3. Bash Scripting Fundamentals
Bash scripting allows us to automate repetitive Linux tasks.

#### **A. The Shebang (`#!/bin/bash`)**
- Always the first line of a script. It tells the operating system which interpreter to use to execute the file.

#### **B. Execution Security & The "Permission Denied" Trap**
When you create a new script (`touch script.sh`), Linux restricts execution for security.
- **Method 1 (Interpreter):** Run it by explicitly calling bash: `bash script.sh` (Bypasses execution permission).
- **Method 2 (Executable):** Grant execute permission: `chmod +x script.sh`. Then run it natively: `./script.sh`.

#### **C. Variables and Quotes**
- **Declaration:** `NAME="Dibyashwor"` (No spaces around `=`).
- **Single Quotes (`'...'`):** Strict/Literal meaning. `echo '$NAME'` outputs `$NAME`.
- **Double Quotes (`"..."`):** Weak quoting. Evaluates variables inside. `echo "$NAME"` outputs `Dibyashwor`.

#### **D. Essential Scripting Commands**
- `echo`: Prints text to the terminal.
- `export`: Exports a variable so it becomes an Environment Variable, making it accessible to child processes and other scripts.

### 🌍 4. Environment Configuration Files
Linux loads specific files when a user logs in to set up their environment (aliases, paths, variables).
- **`~/.bashrc`:** User-specific configuration. Runs every time the user opens a new terminal.
- **`/etc/profile`:** System-wide configuration. Applied to ALL users on the system upon login.

## Day 16: Advanced Bash Scripting – Logic, Variables & Loops (Mar 25, 2026)

### 📥 1. Handling User Input
Interactive scripts require user input. We use the `read` command.
- **Standard Input:** `read var_name`
- **Prompting (`-p`):** `read -p "Enter your name: " name` (Shows a message on the same line).
- **Silent Input (`-sp`):** `read -sp "Enter password: " pass` (Hides the characters typed, crucial for secure scripts!).

### 🧩 2. Positional & Special Parameters
When running a script (e.g., `./script.sh arg1 arg2`), we can pass arguments dynamically.

| Variable | Description | Practical Use |
| :--- | :--- | :--- |
| `$0` | The name of the script itself. | Good for printing usage instructions. |
| `$1, $2..`| The 1st, 2nd, etc., positional arguments passed. | Taking dynamic input without prompts. |
| `$@` | All arguments passed as a list. | Iterating through all inputs in a loop. |
| `$#` | Total number of arguments passed. | Checking if the user provided enough info. |
| `$?` | Exit status of the *last executed command*. | `0` = Success, `1-255` = Error. **(Crucial)** |
| `$$` | Process ID (PID) of the current script. | Tracking the script in `top` or `ps`. |
| `$RANDOM`| Generates a random integer (0 - 32767). | Creating temporary random filenames. |
| `$USER` | The current logged-in user. | Script authorization checks. |
| `$HOSTNAME`| The name of the server/machine. | Logging which server ran the script. |
| `$SECONDS`| Number of seconds since the script started. | Measuring how long a script took to run. |
| `$LINENO`| Current line number in the script. | Debugging errors. |

### 🔄 3. Command Substitution
Allows us to save the output of a Linux command directly into a variable.
- **Modern Syntax:** `CURRENT_DATE=$(date)`
- **Legacy Syntax:** `CURRENT_DATE=\`date\``

### 🧮 4. Operators in Bash
Bash supports standard programming operators:
- **Arithmetic:** `+`, `-`, `*`, `/`, `%`
- **Relational (Numbers):** `-eq` (equal), `-ne` (not equal), `-gt` (greater than), `-lt` (less than).
- **String:** `=` (equal), `!=` (not equal), `-z` (is empty).
- **Logical:** `&&` (AND), `||` (OR).
- **File Test (Very Important):**
  - `-e file` (Exists?)
  - `-f file` (Is a regular file?)
  - `-d dir` (Is a directory?)

### 🔀 5. Conditional Statements
Controlling the flow of the script using `if`, `elif`, and `else`.
if [ $1 -gt 100 ]; then
    echo "Argument is greater than 100"
elif [ $1 -eq 100 ]; then
    echo "Argument is exactly 100"
else
    echo "Argument is less than 100"
fi

### 6. Loops in Bash
Automating repetitive tasks.
For Loop (Iterating over a list):

for file in $(ls); do
    echo "Found file: $file"
done

While Loop (Running while a condition is true):

count=1
while [ $count -le 5 ]; do
    echo "Count is $count"
    sleep 1  # Pauses the script for 1 second
    ((count++))
done

## Day 17: Automated VM Provisioning with Vagrant (Mar 26, 2026)

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

## Day 18: Advanced Vagrant - Provisioning, Synced Folders & Multi-Machine Setup (Mar 29, 2026)

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

## Day 19: Apache2 Deep Dive & Full WordPress Deployment (Mar 29, 2026)

### 🌐 1. Apache2 Web Server Architecture
We didn't just install Apache; we dissected its entire directory structure in `/etc/apache2/`.

**Core Configuration Files & Directories:**
- `apache2.conf`: The main configuration file for the server.
- `envvars`: Holds environment variables for Apache.
- `security.conf`: Manages server signatures and security headers.
- `000-default.conf` / `default-ssl.conf`: Default virtual host files for HTTP (80) and HTTPS (443).

**The "Available vs. Enabled" Architecture:**
Apache uses a brilliant symlink system to enable/disable features without deleting configuration files.
- `sites-available/` vs `sites-enabled/`: Stores Virtual Host files (different websites on one server).
- `mods-available/` vs `mods-enabled/`: Stores Apache modules (like `rewrite` or `php`).
- `conf-available/` vs `conf-enabled/`: Stores global configurations.
*To enable a site:* `sudo a2ensite mywebsite.conf`
*To disable a site:* `sudo a2dissite mywebsite.conf` (Followed by `systemctl reload apache2`).

**Server Logs (Crucial for Troubleshooting):**
Located in `/var/log/apache2/`.
- `access.log`: Records every HTTP request (IP, Browser, Time).
- `error.log`: Records server errors, PHP crashes, and missing files (404s).

### 🗄️ 2. Database Configuration (MySQL/MariaDB)
WordPress requires a database to store content.
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;

### 3. Deploying WordPress
Followed the official Ubuntu documentation to set up the application layer.
#### A. Downloading and Structuring
i.Downloaded the latest tarball using curl.
ii.Extracted files to the standard directory: /srv/www/wordpress/.
iii.Set proper ownership: sudo chown -R www-data:www-data /srv/www/wordpress/.

#### B. Automating Configuration with sed:
Instead of manually editing wp-config.php with vim, we used sed (Stream Editor) to inject the database credentials directly from the command line!
```
sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sed -i 's/username_here/wpuser/' /srv/www/wordpress/wp-config.php
sed -i 's/password_here/password/' /srv/www/wordpress/wp-config.php
```
#### C.  Configuring the Apache Virtual Host:
```
Created /etc/apache2/sites-available/wordpress.conf:

<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
</VirtualHost>
```
Enabled the site: sudo a2ensite wordpress.conf, disabled the default: sudo a2dissite 000-default.conf, and reloaded Apache.

### 4.  Final Testing & Publishing
i.Used curl -I http://localhost to verify the HTTP status code (200 OK).
ii.Browsed to the VM's bridged IP address in the Windows host browser.
iii.Completed the famous "5-minute WordPress installation" GUI.
iv.Successfully wrote and published my first blog post!

## Day 20: Version Control Systems & Git Fundamentals (Mar 30, 2026)

### 📚 1. What is Git & Types of VCS
Version Control Systems (VCS) track changes to files over time, allowing teams to collaborate and revert to previous versions if something breaks.

**Kinds of VCS:**
1. **Local VCS:** Revisions are stored locally on one computer. High risk of data loss.
2. **Centralized VCS (CVCS):** Uses a central server (like SVN). If the server goes down, nobody can collaborate. 
3. **Distributed VCS (DVCS):** Every developer has a full, local copy of the entire repository history (e.g., **Git**). If the remote server goes down, developers can still work and commit locally.

### 🏗️ 2. The 4 Stages of Git Architecture
Understanding how a file travels from your laptop to GitHub.
1. **Working Directory:** Where you actively write and edit files. (Untracked/Modified).
2. **Staging Area (Index):** A holding area where you gather files you want to commit. (`git add`)
3. **Local Repository:** Your local `.git` database where commits are permanently saved on your machine. (`git commit`)
4. **Remote Repository:** A server (like GitHub or GitLab) where you share your code with the team. (`git push`)

### ⚙️ 3. Git Configuration (Global vs. Local)
Before committing, Git needs to know who you are.

- **Global Config** (Applies to all repos on your user account):
```
  git config --global user.name "Dibyashwor Hamal"

  git config --global user.email "hamaldivyashwor2057@gmail.com"
  ```
- **Local Config** (Applies only to the current project)
```
git config --local user.name "Project Admin"

git config --local user.email "hamaldivyashwor2057@gmail.com"
```

- **Check Configs:** git config --list

### 4. Essential git command Cheat Sheet:

| Command | Description |
| :--- | :--- |
| `git init` |Initializes a new local Git repository (creates a hidden .git folder).|
| `git status` | Shows the state of the Working Directory and Staging Area. |
| `git add <file>` |Moves a file from Working Directory to the Staging Area. (git add . for all files).|
| `git commit -m "Msg"` | Takes a snapshot of the Staging Area and saves it to the Local Repository.|
| `git log` |Shows the commit history (Author, Date, Commit Hash, Message). |
| `git branch -a` | 	Lists all local and remote branches.|

### 5.  Connecting Local Repo to Remote Repo (GitHub)
**Step 1:** Create an empty repository on GitHub.

**Step 2:** Link your local repository to the remote one:

git remote add origin https://github.com/DibyashworHamal/MyProject.git

**Step 3:** Push your local commits to the remote server:

git push -u origin main

(The -u flag sets the upstream, so next time you only need to type git push).

## Day 21: Secure Git Authentication, Log Inspection & Branching Strategies (Mar 31, 2026)

### 🔐 1. Secure Authentication (Adding SSH Keys to GitHub)
Instead of using HTTPS and typing a Personal Access Token (PAT) every time we push, we use SSH Keys for secure, passwordless authentication.

**Steps to Configure:**
1. Generate Key Pair: `ssh-keygen -t ed25519 -C "your_email@gmail.com"`
2. Start SSH Agent: `eval "$(ssh-agent -s)"`
3. Add Private Key: `ssh-add ~/.ssh/id_ed25519`
4. Copy Public Key: `cat ~/.ssh/id_ed25519.pub`
5. Paste the output into **GitHub -> Settings -> SSH and GPG Keys -> New SSH Key**.
6. Test Connection: `ssh -T git@github.com`

### 📄 2. The Power of `README.md`
- The `README.md` is the landing page of any repository. 
- Written in **Markdown**, it provides crucial context for other developers (or CI/CD pipelines) on how to install, configure, and run the project.

### 🕵️ 3. Inspecting Git History
When working in a team, you need to know *who* changed *what* and *when*.

| Command | Description |
| :--- | :--- |
| `git log` | Shows full commit history (Hash, Author, Date, Message). |
| `git log --oneline` | Compresses history into a clean, readable list. (Highly recommended!) |
| `git show <commit_hash>` | Shows the exact metadata and code changes (diff) made in a specific commit. |
| `git diff` | Shows the difference between your current Working Directory and the Staging Area (what you changed but haven't `git add`ed yet). |

### ⏪ 4. Undoing Mistakes with `git restore`
Introduced in Git 2.23, `restore` safely undoes uncommitted changes.
- **Discard changes in Working Directory:** `git restore <file>` (Reverts the file to the last committed state. ⚠️ *Deletes unsaved work!*)
- **Unstage a file:** `git restore --staged <file>` (Moves a file out of the staging area back to the working directory without losing the edits).

### 🌳 5. Git Branching Strategy & Workflow
We discussed how teams collaborate without breaking the main production code.

**Standard GitFlow Concept:**
- **`main` / `master` branch:** The stable, production-ready code. Nobody commits directly here.
- **`develop` branch:** Where all integrated features are tested before going to production.
- **`feature/xxx` branches:** Created by individual developers to work on a specific task (e.g., `feature/login-page`). Once done, it gets merged into `develop`.

## Day 22: Advanced Git - Rebasing, Stashing, Tagging & Cherry-Picking (Apr 1, 2026)

### 🌿 1. Branching & Merging Strategies
Best Practice: Never work directly on `main`. Create feature branches, stabilize them, and then integrate them into `main`.

- **Fast-Forward Merge:** If `main` hasn't changed since you created your branch, Git simply moves the pointer forward.
- **No-Fast-Forward Merge (`--no-ff`):** Forces Git to create a specific "Merge Commit," preserving the historical timeline of the feature branch.
  - *Command:* `git merge feature_branch --no-ff`
- **Conflict Resolution:** Occurs when two branches modify the same line of code. We must manually edit the file, resolve the conflict, `git add`, and `git commit` to complete the merge.

### 🛤️ 2. Rebasing (Rewriting History)
Rebasing is an alternative to Merging. It takes your feature branch commits and "replays" them on top of the latest `main` branch, creating a perfectly clean, linear history.

| Scenario | Command |
| :--- | :--- |
| **Standard Rebase** | `git rebase main` |
| **Handling Conflicts** | Resolve manually -> `git add file` -> `git rebase --continue` |
| **Bail Out!** | `git rebase --abort` (Stops the rebase and returns to original state) |
| **Pull with Rebase** | `git pull --rebase origin main` (Fetches and rebases instead of merging) |
*⚠️ Golden Rule of Git:* **Never rebase public branches that others are working on!**

### 📦 3. Stashing (Work-In-Progress Management)
If you are halfway through a feature and suddenly need to switch branches for a quick bug fix, you use `git stash` to save your incomplete work without committing it.

| Command | Description |
| :--- | :--- |
| `git stash` / `git stash save "msg"` | Saves modified tracked files to the stash stack. |
| `git stash -u` | Stashes untracked (newly created) files as well. |
| `git stash list` | Lists all saved stashes (e.g., `stash@{0}`, `stash@{1}`). |
| `git stash pop` | Applies the most recent stash AND removes it from the list. |
| `git stash apply stash@{1}` | Applies a specific stash but KEEPS it in the list. |
| `git stash drop stash@{1}` | Deletes a specific stash. |
| `git stash branch new_branch` | Creates a new branch directly from a saved stash! |

### 🏷️ 4. Git Tagging (Milestones & Releases)
Tags are labels applied to specific commits in history (e.g., `v1.0`).

- **Lightweight Tag:** `git tag v1.0` (Just a pointer).
- **Annotated Tag:** `git tag -a v2.0 -m "Release Version 2.0"` (Includes author, date, and message metadata).
- **Tag a past commit:** `git tag -a v0.9 <commit_id>`
- **Push tags to remote:** `git push origin --tags`
- **Delete remote tag:** `git push origin :v0.8-alpha`

### 🍒 5. Cherry-Picking
Sometimes you don't want to merge a whole branch; you just want ONE specific commit from it.
- **Command:** `git cherry-pick <commit_id>`
- **Multiple Commits:** `git cherry-pick <id_1> <id_2>`
- **Cherry-Pick without committing:** `git cherry-pick -n <commit_id>` (Brings the changes into your staging area so you can modify them before committing).

## Day 23: Introduction to Containerization & Docker Architecture (Apr 2, 2026)

### 📦 1. What is Containerization?
Containerization is the packaging of software code with all its necessary components (libraries, frameworks, and other dependencies) so that it can run consistently on any infrastructure.
- **The Problem Solved:** Eliminates the "It works on my machine" excuse. 

### 🖥️ 2. Virtual Machines vs. Containers
Understanding the architectural difference is crucial for resource management.

| Feature | Virtual Machines (VMs) | Containers (Docker) |
| :--- | :--- | :--- |
| **Virtualization Level** | Hardware-level (Hypervisor) | OS-level (Container Engine) |
| **Guest OS** | Every VM needs a full, heavy Guest OS. | Containers share the Host OS Kernel. |
| **Boot Time** | Minutes | Milliseconds |
| **Size** | Gigabytes (GBs) | Megabytes (MBs) |
| **Resource Usage** | Pre-allocated (Wastes RAM/CPU) | Dynamic (Uses only what it needs) |

### 🐳 3. What is Docker & How it Works
Docker is an open-source platform that automates the deployment, scaling, and management of containerized applications. 

**The Docker Client-Server Architecture:**
1. **Docker Client:** The CLI (`docker run`, `docker pull`) where we type commands. It uses REST APIs to talk to the Daemon.
2. **Docker Host (Daemon - `dockerd`):** The background service running on the server that does the heavy lifting (building, running, and distributing containers).
3. **Docker Registries:** A centralized storage for Docker Images (e.g., **Docker Hub**). The Daemon pulls images from here if they aren't available locally.

### 🧱 4. Core Docker Objects
- **Images:** A read-only template containing the application, OS libraries, and dependencies. (Think of it as the "Class" in Java).
- **Containers:** A runnable instance of an Image. It is an isolated, lightweight, and executable package of software. (Think of it as the "Object" instantiated from the Class).

### 🛠️ 5. Practical Implementation
- Provisioned our Ubuntu 24.04 VM using Vagrant.
- Installed the Docker Engine (`docker-ce`, `docker-ce-cli`, `containerd.io`).
- Verified the installation and checked the Docker Daemon status (`systemctl status docker`).

## Day 24: Docker Container Lifecycle, Exec & Port Mapping (Apr 3, 2026)

### 🔐 1. Post-Installation Configuration
By default, Docker requires root privileges. To run Docker commands without typing `sudo` every time, we add our user to the `docker` group.

```bash
sudo usermod -aG docker $USER
newgrp docker   # Applies the group change immediately without logging out
docker system info # Verifies Docker is running properly
```

### 2. The Docker Container Lifecycle Commands
A container is a running instance of an image. Here is the ultimate cheat sheet for managing them:

| Action| Command | Description |
| :--- | :--- | :--- |
| Run | docker container run nginx | Pulls the image (if not local) and starts the container. |
| List Active | docker ps or docker container ls | Lists currently running containers. |
| List All | docker ps -a | Lists ALL containers (running + stopped). |
| Start/Stop | docker container start/stop <id> | Starts a stopped container or gracefully stops a running one. |
| Kill | docker container kill <id> | Forcefully kills a container (SIGKILL). |
| Pause/Unpause | docker container pause/unpause <id> | Suspends the container processes. |
| Remove | docker container rm <id> | Deletes a stopped container. |
| Prune | docker container prune | ⚠️ Deletes ALL stopped containers to free up space. |
| Stats & Top | docker container stats / top | Live CPU/RAM usage / Shows running processes inside the container. |

### 3. Attach vs. Detach Mode
i. Attach Mode (Default): Runs the container in the foreground. If you press Ctrl+C, the container stops.
ii. Detach Mode (-d): Runs the container in the background. It returns your terminal prompt so you can keep working.
Example:``` docker container run -d nginx```

### 4. Interacting Inside a Container
Containers are isolated environments, but we can step inside them or move files in and out.
i. Execute a Command Inside:
```
docker container exec -it <container_id> bash
```
(The -it flag stands for Interactive Terminal. This drops you into the container's shell!)

ii. Copy Files (Host ↔ Container):
```
docker container cp my_file.txt <container_id>:/opt/  # Host to Container
docker container cp <container_id>:/etc/nginx/nginx.conf .  # Container to Host
```
### 5. Networking & Port Mapping
Containers have their own isolated network. To access a container from the outside world (like a browser), we must map a port from the Host VM to the Container.
i.Syntax: ```-p HostPort:ContainerPort```
Example: ```docker container run -d -p 80:80 nginx```
(This maps port 80 of your Ubuntu VM to port 80 of the Nginx container).
ii.Verification:
On the VM terminal: ```curl localhost:80```
On the Windows Browser: ```http://<VM_IP_Address>:80```

### 6. Deep Inspection
i. Inspect: ```docker container inspect <container_id>``` outputs a massive JSON file containing all metadata (IP address, mounts, environment variables) of the container.
ii. Docker Root Dir: Explored /var/lib/docker/ where the Docker Daemon stores all images, containers, and volumes physically on the VM.
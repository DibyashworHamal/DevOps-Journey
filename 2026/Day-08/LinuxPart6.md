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
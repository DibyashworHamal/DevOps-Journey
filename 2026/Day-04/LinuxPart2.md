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
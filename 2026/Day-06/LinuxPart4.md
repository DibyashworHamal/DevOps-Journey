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
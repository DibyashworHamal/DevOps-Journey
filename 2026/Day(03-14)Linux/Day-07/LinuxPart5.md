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
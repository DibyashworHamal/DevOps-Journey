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
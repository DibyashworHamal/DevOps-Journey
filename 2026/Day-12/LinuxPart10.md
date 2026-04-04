## Day 12: File Systems, Links, I/O Redirection & Package Management (Mar 18, 2026)

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
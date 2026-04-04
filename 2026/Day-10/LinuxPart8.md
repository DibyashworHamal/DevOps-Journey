## Day 10: Linux Basic Commands & The VIM Editor Deep Dive (Mar 15, 2026)

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
## Day 11: Advanced VIM & Text Processing Power Tools (Mar 16, 2026)

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
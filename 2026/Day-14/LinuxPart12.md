## Day 14: Advanced Bash Scripting – Logic, Variables & Loops (Mar 25, 2026)

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
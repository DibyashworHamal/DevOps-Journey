## Day 19: Secure Git Authentication, Log Inspection & Branching Strategies (Mar 31, 2026)

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
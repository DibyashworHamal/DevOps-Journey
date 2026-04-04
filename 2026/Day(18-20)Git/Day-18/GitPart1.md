## Day 18: Version Control Systems & Git Fundamentals (Mar 30, 2026)

### 📚 1. What is Git & Types of VCS
Version Control Systems (VCS) track changes to files over time, allowing teams to collaborate and revert to previous versions if something breaks.

**Kinds of VCS:**
1. **Local VCS:** Revisions are stored locally on one computer. High risk of data loss.
2. **Centralized VCS (CVCS):** Uses a central server (like SVN). If the server goes down, nobody can collaborate. 
3. **Distributed VCS (DVCS):** Every developer has a full, local copy of the entire repository history (e.g., **Git**). If the remote server goes down, developers can still work and commit locally.

### 🏗️ 2. The 4 Stages of Git Architecture
Understanding how a file travels from your laptop to GitHub.
1. **Working Directory:** Where you actively write and edit files. (Untracked/Modified).
2. **Staging Area (Index):** A holding area where you gather files you want to commit. (`git add`)
3. **Local Repository:** Your local `.git` database where commits are permanently saved on your machine. (`git commit`)
4. **Remote Repository:** A server (like GitHub or GitLab) where you share your code with the team. (`git push`)

### ⚙️ 3. Git Configuration (Global vs. Local)
Before committing, Git needs to know who you are.

- **Global Config** (Applies to all repos on your user account):
```
  git config --global user.name "Dibyashwor Hamal"

  git config --global user.email "hamaldivyashwor2057@gmail.com"
  ```
- **Local Config** (Applies only to the current project)
```
git config --local user.name "Project Admin"

git config --local user.email "hamaldivyashwor2057@gmail.com"
```

- **Check Configs:** git config --list

### 4. Essential git command Cheat Sheet:

| Command | Description |
| :--- | :--- |
| `git init` |Initializes a new local Git repository (creates a hidden .git folder).|
| `git status` | Shows the state of the Working Directory and Staging Area. |
| `git add <file>` |Moves a file from Working Directory to the Staging Area. (git add . for all files).|
| `git commit -m "Msg"` | Takes a snapshot of the Staging Area and saves it to the Local Repository.|
| `git log` |Shows the commit history (Author, Date, Commit Hash, Message). |
| `git branch -a` | 	Lists all local and remote branches.|

### 5.  Connecting Local Repo to Remote Repo (GitHub)
**Step 1:** Create an empty repository on GitHub.

**Step 2:** Link your local repository to the remote one:

git remote add origin https://github.com/DibyashworHamal/MyProject.git

**Step 3:** Push your local commits to the remote server:

git push -u origin main

(The -u flag sets the upstream, so next time you only need to type git push).
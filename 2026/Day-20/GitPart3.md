## Day 20: Advanced Git - Rebasing, Stashing, Tagging & Cherry-Picking (Apr 1, 2026)

### 🌿 1. Branching & Merging Strategies
Best Practice: Never work directly on `main`. Create feature branches, stabilize them, and then integrate them into `main`.

- **Fast-Forward Merge:** If `main` hasn't changed since you created your branch, Git simply moves the pointer forward.
- **No-Fast-Forward Merge (`--no-ff`):** Forces Git to create a specific "Merge Commit," preserving the historical timeline of the feature branch.
  - *Command:* `git merge feature_branch --no-ff`
- **Conflict Resolution:** Occurs when two branches modify the same line of code. We must manually edit the file, resolve the conflict, `git add`, and `git commit` to complete the merge.

### 🛤️ 2. Rebasing (Rewriting History)
Rebasing is an alternative to Merging. It takes your feature branch commits and "replays" them on top of the latest `main` branch, creating a perfectly clean, linear history.

| Scenario | Command |
| :--- | :--- |
| **Standard Rebase** | `git rebase main` |
| **Handling Conflicts** | Resolve manually -> `git add file` -> `git rebase --continue` |
| **Bail Out!** | `git rebase --abort` (Stops the rebase and returns to original state) |
| **Pull with Rebase** | `git pull --rebase origin main` (Fetches and rebases instead of merging) |
*⚠️ Golden Rule of Git:* **Never rebase public branches that others are working on!**

### 📦 3. Stashing (Work-In-Progress Management)
If you are halfway through a feature and suddenly need to switch branches for a quick bug fix, you use `git stash` to save your incomplete work without committing it.

| Command | Description |
| :--- | :--- |
| `git stash` / `git stash save "msg"` | Saves modified tracked files to the stash stack. |
| `git stash -u` | Stashes untracked (newly created) files as well. |
| `git stash list` | Lists all saved stashes (e.g., `stash@{0}`, `stash@{1}`). |
| `git stash pop` | Applies the most recent stash AND removes it from the list. |
| `git stash apply stash@{1}` | Applies a specific stash but KEEPS it in the list. |
| `git stash drop stash@{1}` | Deletes a specific stash. |
| `git stash branch new_branch` | Creates a new branch directly from a saved stash! |

### 🏷️ 4. Git Tagging (Milestones & Releases)
Tags are labels applied to specific commits in history (e.g., `v1.0`).

- **Lightweight Tag:** `git tag v1.0` (Just a pointer).
- **Annotated Tag:** `git tag -a v2.0 -m "Release Version 2.0"` (Includes author, date, and message metadata).
- **Tag a past commit:** `git tag -a v0.9 <commit_id>`
- **Push tags to remote:** `git push origin --tags`
- **Delete remote tag:** `git push origin :v0.8-alpha`

### 🍒 5. Cherry-Picking
Sometimes you don't want to merge a whole branch; you just want ONE specific commit from it.
- **Command:** `git cherry-pick <commit_id>`
- **Multiple Commits:** `git cherry-pick <id_1> <id_2>`
- **Cherry-Pick without committing:** `git cherry-pick -n <commit_id>` (Brings the changes into your staging area so you can modify them before committing).
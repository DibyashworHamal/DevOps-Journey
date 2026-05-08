## Day 31: Jenkins Freestyle Projects, Build Triggers & Job Scheduling (Apr 22, 2026)

### 🏗️ 1. Jenkins Freestyle Projects
Freestyle projects are the most basic and flexible way to run jobs in Jenkins.
- **Created a Job:** Navigated to *New Item -> Freestyle Project*.
- **Wrote a Build Script:** Added an `Execute Shell` build step with a simple Bash script (`echo "Hello Jenkins Automation!"`).
- **Workspace:** Every Jenkins job gets an isolated directory on the host server (`/var/lib/jenkins/workspace/<job_name>`) where it executes scripts and stores files.

**Exploring the Job UI:**
- **Status:** The health of the project (Blue/Green = Success, Red = Failed).
- **Changes:** Shows Git commit differences since the last build.
- **Console Output:** The most important debugging tool! Shows real-time terminal output of the build execution.
- **Workspace:** GUI view of the files inside the job's directory.

### ⚙️ 2. Advanced Job Configuration
We explored the settings that make Jenkins jobs enterprise-ready:
- **Discard Old Builds:** Prevents the server from running out of disk space by keeping only a specific number of old build logs/artifacts (e.g., keep only the last 10 builds).
- **GitHub Project:** Links the job directly to a GitHub repository URL for easy access.
- **This Project is Parameterized:** Allows users to input variables (Strings, Dropdowns, Passwords) before running the job (e.g., choosing `ENV=dev` or `ENV=prod`).
- **Execute Concurrent Builds:** Allows multiple instances of the same job to run at the same time without waiting in a queue.
- **Use Custom Workspace:** Forces the job to run in a specific directory path instead of the default Jenkins workspace.

### 🔗 3. Build Triggers (Chaining Jobs)
Automation means jobs should trigger themselves without human intervention.
- **Trigger Builds Remotely:** Exposes an API endpoint so external scripts or Webhooks can start the Jenkins job using a unique Authentication Token.
- **Build After Other Projects are Built (Upstream/Downstream):** 
  - *Example:* Job B runs automatically after Job A finishes.
  - We can set conditions like: *Trigger ONLY if Job A is stable (successful).*

### ⏱️ 4. Scheduling: Cron & Crontab syntax
Jenkins uses standard Linux Cron syntax (`* * * * *`) for scheduling time-based jobs.
- **Syntax Breakdown:** `MINUTE HOUR DOM MONTH DOW` (Minute, Hour, Day of Month, Month, Day of Week).
- *Tool utilized:* [crontab.guru](https://crontab.guru/) - A great UI tool to translate and verify cron schedules.

### 🆚 5. Build Periodically vs. Poll SCM (Crucial Concept)
| Feature | Build Periodically | Poll SCM |
| :--- | :--- | :--- |
| **How it Works** | Triggers the build at the exact scheduled time, **regardless** of whether the code has changed or not. | Checks the GitHub repository at the scheduled time. It triggers a build **ONLY IF** there is a new commit. |
| **Use Case** | Nightly database backups, weekly server reboots, security scans. | Continuous Integration (CI). Compiling code only when developers push updates. |

### 🏁 6. Post-Build Actions
Actions taken *after* the build script finishes executing.
- *Examples:* Sending an Email notification (Success/Failure), archiving artifacts (saving the compiled `.jar` file), or triggering downstream projects.
## Day 70: DevSecOps, SAST vs. DAST & SonarQube Provisioning (Jun 26, 2026)

### 🔒 1. Continuous Security & Continuous Testing
In modern software engineering, we "Shift Left"—meaning we integrate security and testing as early in the Software Development Life Cycle (SDLC) as possible, rather than waiting until the deployment phase.

### ⚔️ 2. Security Testing: SAST vs. DAST
We explored the two primary methodologies for securing applications:
| Feature | SAST (Static Application Security Testing) | DAST (Dynamic Application Security Testing) |
| :--- | :--- | :--- |
| **Approach** | White-Box Testing | Black-Box Testing |
| **How it Works** | Analyzes the raw source code *without* running the application. | Interacts with the *running* application from the outside (like a hacker). |
| **What it finds** | Bad coding practices, hard-coded passwords, syntax vulnerabilities. | SQL injections, Cross-Site Scripting (XSS), runtime server errors. |
| **Tool Example** | **SonarQube**, SonarLint | OWASP ZAP, Burp Suite |

### 🦇 3. What is SonarQube?
SonarQube is the industry-standard open-source platform for Continuous Inspection of code quality.
- **Why we need it:** It automatically detects **Bugs** (code that will crash), **Vulnerabilities** (security holes), and **Code Smells** (messy, unmaintainable code).
- **Architecture Components (Theory Task):**
  1. *SonarQube Server:* Hosts the Web UI, Search Server (Elasticsearch), and Compute Engine.
  2. *Database:* Stores the configuration and the code analysis results (usually PostgreSQL).
  3. *SonarScanner:* The tool that runs on the CI server (like Jenkins) to analyze the code and send results back to the SonarQube server.

### 🛠️ 4. Practical Lab: Provisioning SonarQube on Ubuntu VM
Instead of installing everything manually, I wrote and executed an automated Bash script to set up Java, PostgreSQL, and SonarQube seamlessly.

🔗 **My Custom Installation Script:** [View it here on my GitHub](https://github.com/DibyashworHamal/DevOps-Journey/tree/main/sonarqube)

**Execution Steps:**
```bash
# 1. Provide execution permissions to the script
chmod +x install_sonarqube.sh

# 2. Run the automated installation
sudo ./install_sonarqube.sh
```
*Note:* Analyzed the script in deep detail to understand how it creates a dedicated `sonar` Linux user, configures kernel parameters (`vm.max_map_count`), and integrates PostgreSQL as the backend database.

### 🌐 5. UI Access & Initial Configuration
1. Browsed to `http://<VM-IP>:9000`.
2. Logged in with the default credentials (`admin` / `admin`).
3. **Security First:** Immediately prompted to change the default password.
4. **Dashboard Exploration:** Explored the SonarQube UI, focusing on the Projects dashboard, Quality Gates (Pass/Fail criteria for code), Quality Profiles (rulesets for different languages like Java/JS), and the Issues tracker.
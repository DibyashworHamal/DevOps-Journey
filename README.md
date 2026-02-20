# My DevOps-Journey

Documentation of my learning path at Tech Axis to becoming a DevOps Engineer.

## Day 1: Orientation
- Introduction to the current IT landscape in Nepal.
- Career Roadmap by Er. Sailesh Nepal.

## Day 2: DevOps Fundamentals & Lifecycle (Feb 19, 2026)

### 1. What is DevOps?
DevOps is a set of practices, tools, and a cultural philosophy that automates and integrates the processes between software development (Dev) and IT teams (Ops).
- **Goal:** Shorten the systems development life cycle and provide continuous delivery with high software quality.

### 2. The DevOps Lifecycle (The Infinity Loop)
1.  **Plan:** Define business value and requirements.
2.  **Code:** Design and software development (Git).
3.  **Build:** Automated builds and version control (Maven/Gradle).
4.  **Test:** Continuous testing for quality assurance (JUnit/Selenium).
5.  **Release:** Manage, schedule, and approve releases (Jenkins).
6.  **Deploy:** Automated deployment to production (Docker/Kubernetes).
7.  **Operate:** Manage infrastructure and software (Ansible/Terraform).
8.  **Monitor:** Track performance and end-user experience (Nagios/Prometheus).

### 3. Key Concepts & Terms
- **CI (Continuous Integration):** Developers frequently merge code changes into a central repository where automated builds and tests run.
- **CD (Continuous Deployment):** Code changes are automatically deployed to a production environment after passing tests.
- **Configuration Management:** Managing server settings via code (Infrastructure as Code) to ensure consistency.
- **Configuration Monitoring:** Continuously checking if the system performance matches the desired state.

### 4. Agile vs. DevOps
- **Agile:** Focuses on processes, adaptability, and customer feedback during *development*.
- **DevOps:** Focuses on automation, stability, and delivery during *deployment and operations*.

### 5. Role of a DevOps Engineer
- Bridging the gap between Dev and Ops.
- Automating repetitive tasks.
- Ensuring system reliability and scalability.
- **Challenges:** Handling legacy systems, security integration (DevSecOps), and cultural resistance to change.

###  Next Steps
- **Practical Lab Setup:** Installing Oracle VirtualBox.
- **OS Installation:** Setting up Linux (Ubuntu 24.04.4 LTS) to begin CLI training.

## Day 3: Lab Setup & Linux Networking (Feb 20, 2026)

### Environment Setup
Today, we set up the virtual lab that will be used for the rest of the course.
- **Hypervisor:** Oracle VirtualBox
- **Guest OS:** Ubuntu 24.04.4 LTS ISO
- **Host OS:** Windows

### Networking Concepts: NAT vs. Bridged
One of the most important parts of setting up a VM is networking.
1. **NAT (Network Address Translation):**
   - The VM shares the Host's IP address.
   - Good for browsing the internet from inside the VM.
   - **Downside:** The outside world (and my Host PC) cannot easily talk *in* to the VM.
2. **Bridged Adapter:**
   - The VM connects directly to the Router (Wi-Fi/LAN).
   - IT gets its own unique IP Address on the local network.
   - **Benefit:** I can ping and SSH into the Linux VM directly from my windows Terminal (Powershell/CMD), just like a real production server.

### Essential Linux Commands Executed
| Command | Description |
| :--- | :--- |
| `sudo apt update` | Updates the list of available packages and their versions (does not install anything). |
| `sudo apt upgrade` | Installs the newer versions of the packages you have. |
| `ip a` | Shows IP addresses and network interfaces (Modern replacement for `ifconfig`). |
| `clear` | Clears the terminal screen. |
| `exit` | Logs out of the shell. |
| `sudo poweroff` | Safely shuts down the system. |
| `init 0` | Another way to shut down (Changes system runlevel to 0). |  

### Key Takeaway
Running 'sudo apt update' **before** 'sudo apt upgrade' is mandatory.
You must refresh the catalog before you buy the producths!
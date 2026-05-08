## Day 33: Maven Build Automation & Java Application Packaging (Apr 26, 2026)

### ☕ 1. What is Apache Maven?
Maven is a powerful build automation and project management tool primarily used for Java projects. 
- **Objectives:** To make the build process easy, provide a uniform build system, provide quality project information, and encourage better development practices.
- Instead of manually downloading `.jar` files and managing dependencies, Maven handles it all dynamically over the internet.

### 📄 2. The POM (Project Object Model)
The heart of any Maven project is the `pom.xml` file.
- It contains information about the project and configuration details used by Maven to build the project.
- It manages **Dependencies** (libraries required by the app) and **Plugins** (tools used during the build).

### 🔄 3. Maven Build Lifecycles & Phases
Maven is based on the central concept of a "Build Lifecycle." There are 3 built-in lifecycles:
1. **Default:** Handles your project deployment.
2. **Clean:** Handles project cleaning (removes old compiled files).
3. **Site:** Handles the creation of your project's website documentation.

**The Default Lifecycle Phases:**
*(Note: Running a specific phase executes all the phases that precede it in order).*
1. `validate`: Checks if the project is correct and all necessary information is available.
2. `compile`: Compiles the source code of the project.
3. `test`: Tests the compiled source code using a unit testing framework (e.g., JUnit).
4. `package`: Takes the compiled code and packages it in its distributable format, such as a JAR or WAR.
5. `verify`: Runs checks on results of integration tests to ensure quality criteria are met.
6. `install`: Installs the package into the local repository for use as a dependency in other projects locally.
7. `deploy`: Copies the final package to the remote repository for sharing with other developers and projects.

### 🛠️ 4. Practical Lab: Setting Up a Maven App on Ubuntu
We transitioned from Windows IDEs to pure Linux CLI to prepare for Jenkins automation.

**Step 1: Installation**
```bash
sudo apt update
sudo apt install openjdk-17-jdk maven -y
mvn -version  # Verify Maven installation
```
**Step 2: Generate a Web Application Archetype**
We used Maven's archetype generator to scaffold a barebones Java Web Application.
```bash
mvn archetype:generate -DarchetypeArtifactId=maven-archetype-webapp
```
**Step 3: Testing the Lifecycle Commands**
Navigated into the newly created my-webapp directory containing the pom.xml.
```bash
mvn clean         # Deletes the /target directory
mvn compile       # Compiles Java code
mvn test          # Runs tests
mvn package       # Packages the app into a .war file inside /target
```
Result: A successfully packaged my-webapp.war file, ready to be deployed to a Tomcat server or processed by Jenkins!
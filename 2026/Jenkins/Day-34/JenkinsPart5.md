## Day 34: Apache Tomcat Server & Java Application Deployment (Apr 27, 2026)

### 🐱 1. What is Apache Tomcat?
Apache Tomcat is an open-source implementation of the Jakarta Servlet, Jakarta Server Pages, and other Java technologies. It acts as a Web Server and Servlet Container, allowing us to run Java code (`.war` files) on the web.

### 🛠️ 2. Installing Tomcat 11 on Ubuntu VM
Instead of using `apt`, we manually downloaded the binaries to understand enterprise software installation.
```bash
# 1. Download Tomcat 11 tarball via wget
wget https://downloads.apache.org/tomcat/tomcat-11/v11.x.x/bin/apache-tomcat-11.x.x.tar.gz

# 2. Extract the archive
tar -xzvf apache-tomcat-11.x.x.tar.gz

# 3. Move to /opt directory (Standard Linux location for third-party software)
sudo mv apache-tomcat-11.x.x /opt/tomcat
```
### 📂 3. Tomcat Architecture & Configuration Files
| Directory / File | Description & Purpose|
|------------------|----------------------|
| bin/             | Contains execution scripts. <br> - ./startup.sh : Starts the server in the background.<br> - ./shutdown.sh : Stops the server.<br> - ./catalina.sh start : Core script used to start/stop the Tomcat process. |
| conf/            | Configuration files. <br> - server.xml: Main configuration (port 8080 definitions).<br> - context.xml: Used for DB connection pooling and webapp settings.<br> - catalina.properties: Standard properties for the JVM and Tomcat. |
| lib/             | Contains Java .jar libraries shared across all applications deployed on the server. |
| logs/            | - catalina.out: The most important file! Captures System.out.print from Java apps and server crash errors.<br> - catalina.yyyy-mm-dd.log: Daily engine logs. |
| webapps/         | The deployment directory. This is where we place our .war files to host our applications. |

### 🚀 4. Application Deployment (The "Magic")
We took the my-webapp.war file created by Maven on Day 33 and deployed it to Tomcat.
```bash
# Copy the compiled artifact to Tomcat's deployment directory
cp target/my-webapp.war /opt/tomcat/webapps/

# Start Tomcat
cd /opt/tomcat/bin
./startup.sh
```
**The Magic of webapps/:**

As soon as Tomcat starts, it detects the .war file in the webapps folder, automatically extracts (unzips) it into a directory, and deploys the Java application to the server dynamically!

### 🌐 5. Verification
- **Accessed http:**//<VM_IP>:8080 and successfully saw the default **Tomcat 11 Welcome Page.**
- **Accessed http:**//<VM_IP>:8080/my-webapp and successfully viewed the "Hello World" Java application we built yesterday!
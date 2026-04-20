## Day 25: Dockerizing a Node.js Application: VM vs. Container (Apr 8, 2026)

### 🖥️ 1. The Traditional Way: Running on the Host VM
Before containerizing, we simulated how developers traditionally run applications. This approach pollutes the host OS and leads to dependency conflicts.

**Steps Executed:**
1. Cloned a Node.js application from a GitHub repository.
2. Installed the runtime environment on the Ubuntu VM: `sudo apt install nodejs npm`
3. Inspected the application structure, specifically `package.json`, which lists all required dependencies.
4. Installed app-specific dependencies: `npm install`
5. Ran the application locally: `node app.js` (or `npm start`)
6. *Result:* The app works, but our VM is now permanently modified with Node.js binaries and libraries.

### 🐳 2. The DevOps Way: Containerizing the App
We completely isolated the application from our Host VM using Docker. To do this, we wrote a `Dockerfile`.

**The Dockerfile Instructions We Mastered:**
| Instruction | Purpose | Example |
| :--- | :--- | :--- |
| **`FROM`** | Specifies the base image (the starting environment). | `FROM node:18-alpine` |
| **`LABEL`** | Adds metadata to the image (Author, Version, Description). | `LABEL maintainer="Dibyashwor Hamal"` |
| **`WORKDIR`** | Sets the default working directory *inside* the container. | `WORKDIR /usr/src/app` |
| **`COPY`** | Copies files from the Host VM into the Container image. | `COPY package.json .` |
| **`RUN`** | Executes commands *during the build process* (creates a new image layer). | `RUN npm install` |
| **`EXPOSE`** | Documents the port the application uses (does not actually publish it). | `EXPOSE 3000` |
| **`CMD`** | The default command that executes *when the container starts*. | `CMD ["node", "app.js"]` |

### 🏗️ 3. The Dockerfile Layout
Here is the blueprint we created to dockerize the Node.js app:
```dockerfile
# 1. Base Image
FROM node:18-alpine

# 2. Metadata
LABEL maintainer="Er. Dibyashwor Hamal"
LABEL version="1.0"

# 3. Set Working Directory
WORKDIR /app

# 4. Copy dependency list first (Optimizes Docker layer caching!)
COPY package.json .

# 5. Install dependencies
RUN npm install

# 6. Copy the rest of the application code
COPY . .

# 7. Expose Port
EXPOSE 3000

# 8. Start the application
CMD["npm", "start"]
```

### 4.  Build, Run, and Compare
**Building the Image:**
```
docker image build -t my-node-app:v1 .
```
**Running the Container:**
```
docker container run -d --name node-server -p 8080:3000 my-node-app:v1
```
### 5. Key Engineering Takeaway: VM vs. Container
**i. Natively on VM:** If we needed to run a Python app tomorrow, we'd have to install Python on the VM. Eventually, the VM becomes a messy mix of conflicting libraries.
**ii. Inside Container:** The Node.js runtime exists only inside the container. The host Ubuntu VM remains completely clean. If we delete the container, the app and its environment vanish instantly without leaving a trace. True Isolation.
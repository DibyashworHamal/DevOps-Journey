## Day 27: Multi-Stage Builds, Build Optimization & Docker Registries (Apr 12, 2026)

### 🏗️ 1. Multi-Stage Builds (The Game Changer)
In production, we only want the compiled code and the runtime in our final Docker image. We do *not* want the heavy build tools, source code, or development dependencies. Multi-stage builds solve this by using multiple `FROM` statements in a single `Dockerfile`.

**Practical Implementation (Node.js App):**
```dockerfile
# Stage 1: The Build Environment (Heavy)
FROM node:alpine3.23 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# (If this was React/Angular, we would run 'npm run build' here)

# Stage 2: The Production Environment (Lightweight)
FROM node:alpine3.23
WORKDIR /app
# We ONLY copy the necessary files from the 'builder' stage!
COPY --from=builder /app . 
EXPOSE 3000
CMD ["npm", "start"]
```
Engineering Result: The final image size is drastically reduced because the temporary files from Stage 1 are discarded. This means faster deployments, lower cloud storage costs, and a smaller security attack surface.

### 2. ⏱️ 2. Reducing Build Time (Layer Caching)

Docker builds images layer by layer. If a layer doesn’t change, Docker uses a cached version.

**The Golden Rule:** Always copy package.json and run npm install BEFORE copying the rest of the application code (COPY . .).

**Why?** Source code changes frequently, but dependencies rarely change. If we copy the source code first, Docker busts the cache and reinstalls all node modules every single time we change a single HTML tag! By ordering instructions correctly, we reduced our build time from minutes to milliseconds.

### 3. Docker Registry (Docker Hub)

A registry is a centralized storage and distribution system for Docker images. Today, we took our local image and pushed it to the cloud.
Step-by-Step Push Process:

**1. Login to Docker Hub via CLI:**
```
docker login
# Entered Docker Hub username and password/Personal Access Token
```
**2. Tag the Image:**
Docker needs to know where to push the image. We must tag it with our Docker Hub username.
```
# Syntax: docker tag <local-image> <username>/<repo-name>:<tag>
docker tag my-node-app:latest dibyashwor/my-node-app:v1.0
```
**3. Push to the Registry:**
```
docker push dibyashwor/my-node-app:v1.0
```
**4. Verify:** Checked Docker Hub in the browser and confirmed my custom Node.js application image is now publicly available for any server in the world to pull and run!
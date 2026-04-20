## Day 26: Advanced Docker Instructions & Industry Best Practices (Apr 10, 2026)

### 🐳 1. Docker Instructions Deep Dive
We explored the nuances of advanced Dockerfile instructions to control exactly how our images are built and executed.

| Instruction | Description & Engineering Insight |
| :--- | :--- |
| **`COPY` vs `ADD`** | Both copy files into the image. **Rule of thumb: Always use `COPY`.** Only use `ADD` if you specifically need to extract a `.tar` file automatically or download a file from a URL during the build. |
| **`CMD` vs `ENTRYPOINT`** | `ENTRYPOINT` defines the main executable (e.g., `ENTRYPOINT ["nginx"]`). `CMD` provides the default arguments (e.g., `CMD ["-g", "daemon off;"]`). If a user runs `docker run myapp bash`, it easily overrides `CMD`, but overriding `ENTRYPOINT` requires a specific `--entrypoint` flag. |
| **`HEALTHCHECK`** | Tells Docker how to test if the app is actually functioning (e.g., `HEALTHCHECK CMD curl -f http://localhost/ || exit 1`). Without this, Docker only knows if the *process* is running, not if the web server is actually responding. |
| **`USER`** | Sets the UID to use when running the image. **Security Best Practice:** Never run containers as `root`. Always create a specific user and switch to it using `USER appuser`. |
| **`VOLUME`** | Creates a mount point and marks it as holding externally mounted volumes. Signals that the data here is persistent. |
| **`SHELL`** | Overrides the default shell used for the `RUN` command (useful if you need `/bin/bash` instead of the default `/bin/sh`). |
| **`FROM`, `WORKDIR`, `RUN`** | (Recap) Define base image, set working directory, and execute build-time commands. |

### 🏆 2. Dockerfile Best Practices (Production Standards)
To build images that are lightweight, secure, and fast to build, we follow these industry standards:

#### **A. Image Optimization & Architecture**
- **Use Multi-Stage Builds:** Compile your code (e.g., Java/React) in a heavy "build" stage, then copy ONLY the compiled artifact (`.jar` or `build/` folder) into a tiny, clean production image. This reduces image size by 90%!
- **Choose the Right Base Image:** Use minimal images like `alpine` instead of full Ubuntu.
- **Pin Base Image Versions:** Never use `FROM node:latest`. Always pin the exact version (e.g., `FROM node:18.16.0-alpine`) to prevent future builds from breaking due to upstream updates.
- **Create Reusable Stages:** Keep base environments standard so they can be reused across different microservices.

#### **B. Build Cache & Performance**
- **Leverage Build Cache:** Docker builds layer by layer. If a layer hasn't changed, Docker reuses it. **Always put `COPY package.json` BEFORE `COPY .`** so that changing your source code doesn't force Docker to redownload all npm packages!
- **Sort Multiline Arguments:** When installing packages (`apt-get install`), sort them alphabetically to easily spot duplicates and avoid cache busting.
- **`--pull` & `--no-cache`:** Use `docker build --pull` to ensure you are downloading the freshest base image security patches. Use `--no-cache` to force a clean build when debugging.

#### **C. Container Philosophy**
- **Create Ephemeral Containers:** Containers should be designed to be stopped, destroyed, and rebuilt with minimum setup and configuration. No local data should be trapped inside.
- **Exclude with `.dockerignore`:** Always use a `.dockerignore` file to prevent `.git`, `node_modules`, and secret `.env` files from being copied into the image.
- **Don't Install Unnecessary Packages:** Every extra package (like `vim` or `ping`) increases the image size and the security attack surface.
- **Decouple Applications:** One process per container! Do NOT put your Node.js app and your MySQL database in the same container.
- **Build and Test in CI:** Automate the `docker build` process in Jenkins or GitHub Actions.
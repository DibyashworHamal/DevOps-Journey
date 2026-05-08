## Day 36: Pipeline as Code, Jenkinsfile & End-to-End Docker Deployment (Apr 30, 2026)

### 📜 1. What is a Jenkins Pipeline & Jenkinsfile?
We transitioned from Freestyle Jobs to **Jenkins Pipelines**. 
- **Pipeline:** A suite of plugins that supports implementing and integrating continuous delivery pipelines into Jenkins.
- **Pipeline as Code:** The practice of defining the deployment pipeline through code rather than GUI configurations.
- **Jenkinsfile:** A text file checked into GitHub alongside the source code that defines the entire build, test, and deploy process.

### 🏗️ 2. Pipeline Architecture (Declarative Syntax)
We utilized the modern **Declarative Pipeline** syntax. The basic structure looks like this:
```groovy
pipeline {
    agent any 
    stages {
        stage('Hello World') {
            steps {
                echo 'Hello from Jenkins Pipeline!'
            }
        }
    }
}
```
Engineering Insight: By running this, we were introduced to the Pipeline Stage View in the Jenkins UI, which visualizes the exact duration and success/failure status of every individual stage.

### 🚀 3. The Ultimate CI/CD Jenkinsfile (Maven + Docker + Harbor)
We took our Node.js/Java application, created a Dockerfile, and wrote a comprehensive Jenkinsfile to automate the entire lifecycle in a single click.
```
pipeline {
    agent any
    environment {
        HARBOR_REGISTRY = "harbor.local/library"
        IMAGE_NAME = "my-java-app"
        TAG = "${env.BUILD_ID}" // Dynamically tags images with the Jenkins Build Number
    }
    
    stages {
        stage('1. Checkout SCM') {
            steps {
                // Jenkins automatically pulls the code from the linked GitHub repo
                checkout scm
            }
        }
        
        stage('2. Maven Build & Package') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('3. Archive Artifacts') {
            steps {
                // Saves the .war file on the Jenkins dashboard
                archiveArtifacts artifacts: 'target/*.war', allowEmptyArchive: false
            }
        }
        
        stage('4. Docker Build') {
            steps {
                // Uses the Dockerfile in the repo to build the image
                sh "docker build -t ${HARBOR_REGISTRY}/${IMAGE_NAME}:${TAG} ."
            }
        }
        
        stage('5. Push to Harbor Registry') {
            steps {
                // Assuming Jenkins is authenticated with Harbor
                sh "docker push ${HARBOR_REGISTRY}/${IMAGE_NAME}:${TAG}"
            }
        }
        
        stage('6. Deploy Container') {
            steps {
                // Cleans up old container and runs the new one
                sh "docker rm -f live-app || true"
                sh "docker run -d --name live-app -p 8080:8080 ${HARBOR_REGISTRY}/${IMAGE_NAME}:${TAG}"
            }
        }
    }
}
```
### ✨ 4. The "Single Click" Magic
- Pushed the source code, pom.xml, Dockerfile, and Jenkinsfile to GitHub.
- Created a new Pipeline Job in Jenkins and linked it to the GitHub repo.
- Clicked Build Now.
- Result: Watched the Pipeline Stage View light up green step-by-step. The code was compiled, the .war file was archived, the Docker image - was built and pushed to Harbor, and a live container was spun up. Total time: Seconds. Zero manual intervention.
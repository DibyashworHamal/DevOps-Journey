# 1. Start with the Ubuntu OS
FROM ubuntu:24.04

# Prevent Ubuntu from asking timezone/keyboard questions during installation
ENV DEBIAN_FRONTEND=noninteractive

# 2. Install all dependencies (Java 21, Maven, MySQL)
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openjdk-21-jdk maven mysql-server && \
    rm -rf /var/lib/apt/lists/*
#1. What is /var/lib/apt/lists/?
# When you run apt-get update -y,
# your Ubuntu container reaches out to the official software repositories and downloads the "menu" of all available software, their versions, and their dependencies.
# It stores all these downloaded package indexes (the text files containing the lists) in the /var/lib/apt/lists/ directory. Depending on the base image, this "menu" can easily take up 20MB to 50MB of space.

# 3. Start MySQL in the background and configure the Database and User
# (Docker doesn't use systemctl, so we use 'service mysql start')
RUN service mysql start && \
    mysql -e "CREATE DATABASE event_db;" && \
    mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'adminpassword';" && \
    mysql -e "GRANT ALL PRIVILEGES ON event_db.* TO 'admin'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# 4. Set up the working directory for your app
WORKDIR /dip/app/

# 5. Copy your entire project code from your laptop into the container
#COPY . .
COPY backend/ /dip/app/

# 6. Build the Java Application
RUN mvn clean package -DskipTests

# 7. Create a Startup Script!
# A container can only run ONE main command (CMD). 
# We need it to start MySQL AND run the Java app. So we write a quick bash script!
RUN echo '#!/bin/bash\nservice mysql start\njava -jar target/*.jar' > start.sh && \
    chmod +x start.sh

# 8. Document that the app runs on port 8081
EXPOSE 8081

# 9. When the container starts, run our script!
CMD ["./start.sh"]

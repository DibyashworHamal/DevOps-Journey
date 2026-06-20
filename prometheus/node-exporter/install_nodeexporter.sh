#!/bin/bash

EXPORTER_VERSION="v1.11.1"
EXPORTER_FILE="node_exporter-1.11.1.linux-amd64"

# 1. Download the zipped software from GitHub
wget https://github.com/prometheus/node_exporter/releases/download/"${EXPORTER_VERSION}"/"${EXPORTER_FILE}".tar.gz

# 2. Extract the zip file
tar xvf "${EXPORTER_FILE}".tar.gz

# 3. Go inside the extracted folder
cd "${EXPORTER_FILE}"

# 4. Move the executable engine to the Linux system folder
sudo cp node_exporter /usr/local/bin

# 5. SECURITY: Create a fake "system user" so hackers can't log in
sudo useradd --no-create-home --shell /bin/false node_exporter

# 6. Give the secure user ownership of the engine
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# 7. Go back to the previous folder (where our node_exporter.service file is!)
cd -

# 8. Copy the service file to Linux's systemd folder
sudo cp node_exporter.service /etc/systemd/system/node_exporter.service

# 9. Reload Linux to see the new file, then start the engine!
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter

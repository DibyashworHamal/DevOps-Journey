#!/bin/bash
#1. Define variables so we can easily update the version later!
PROMETHEUS_VERSION="v3.5.4"
PROMETHEUS_FILE="prometheus-3.5.4.linux-amd64"

echo "Step 1: Creating a secure, invisible Linux user for Prometheus..."
sudo useradd --no-create-home --shell /bin/false prometheus

echo "Step 2: Creating configuration and data folders..."
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

echo "Step 3: Giving the prometheus user ownership of those folders..."
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

echo "Step 4: Downloading and extracting Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/"${PROMETHEUS_VERSION}"/"${PROMETHEUS_FILE}".tar.gz
tar xvf "${PROMETHEUS_FILE}".tar.gz
cd "${PROMETHEUS_FILE}"

echo "Step 5: Moving the binary engines to the Linux binaries folder..."
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin

echo "Step 6: Moving the console templates..."
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

echo "Step 7: Moving our default prometheus.yml file..."
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

echo "Step 8: Registering Prometheus as a Background Service..."
cd -
sudo cp prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload

echo "Step 9: Starting the Engine!"
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus

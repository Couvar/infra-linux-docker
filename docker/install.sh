#!/bin/bash

# Sicheres Docker Setup für Debian (root oder sudo nötig)

set -e

echo "[INFO] Pakete und Apt Sources aktualisieren"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "[INFO] Paketliste aktualisieren..."
apt update

echo "[INFO] Docker Engine und Plugins installieren..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[INFO] Docker auf Autostart setzen..."
systemctl enable docker
systemctl start docker

echo "[INFO] Docker Gruppe konfigurieren..."
groupadd -f docker
usermod -aG docker "${SUDO_USER:-$USER}"

echo "[INFO] Testcontainer starten (hello-world)..."
sudo docker run hello-world

echo "[INFO] Installation abgeschlossen."
echo "Bitte ab- und wieder anmelden, damit Docker-Gruppenzugriff wirksam wird."

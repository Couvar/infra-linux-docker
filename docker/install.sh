#!/bin/bash

# Sicheres Docker Setup für Debian (root oder sudo nötig)

set -e

echo "[INFO] System aktualisieren..."
apt update && apt upgrade -y

echo "[INFO] Abhängigkeiten installieren..."
apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https

echo "[INFO] Docker GPG Key hinzufügen..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "[INFO] Docker Repository hinzufügen..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[INFO] Paketliste aktualisieren..."
apt update

echo "[INFO] Docker Engine und Plugins installieren..."
apt install -y docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin

echo "[INFO] Docker auf Autostart setzen..."
systemctl enable docker
systemctl start docker

echo "[INFO] Docker Gruppe konfigurieren..."
groupadd -f docker
usermod -aG docker "${SUDO_USER:-$USER}"

echo "[INFO] Testcontainer starten (hello-world)..."
docker run --rm hello-world

echo "[INFO] Sichere Standard-Netzwerkumgebung einrichten..."
docker network create secure-net || echo "[WARN] Netzwerk 'secure-net' existiert bereits"

echo "[INFO] Installation abgeschlossen."
echo "Bitte ab- und wieder anmelden, damit Docker-Gruppenzugriff wirksam wird."

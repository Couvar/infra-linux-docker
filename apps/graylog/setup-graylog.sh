#!/bin/bash
set -e

# 1. Prüfen, ob Docker & Docker Compose installiert sind
if ! command -v docker &> /dev/null; then
  echo "Docker ist nicht installiert. Bitte zuerst Docker installieren."
  exit 1
fi

if ! command -v docker-compose &> /dev/null; then
  echo "Docker Compose ist nicht installiert. Bitte zuerst Docker Compose installieren."
  exit 1
fi

# 2. Passwort und Hash setzen
read -sp "Gib ein sicheres Passwort für Graylog admin user ein: " ADMIN_PASS
echo
PASSWORD_SECRET=$(openssl rand -hex 16)
PASSWORD_SHA2=$(echo -n "$ADMIN_PASS" | sha256sum | awk '{print $1}')

echo "Generiere .env Datei mit geheimen Variablen..."

cat > .env <<EOF
GRAYLOG_PASSWORD_SECRET=$PASSWORD_SECRET
GRAYLOG_ROOT_PASSWORD_SHA2=$PASSWORD_SHA2
GRAYLOG_HTTP_EXTERNAL_URI=127.0.0.1:9000
EOF

echo "Starte Graylog Stack via Docker Compose..."
docker-compose up -d

echo "Fertig! Graylog läuft jetzt auf http://127.0.0.1:9000"
echo "Login mit Benutzername: admin und deinem eingegebenen Passwort."

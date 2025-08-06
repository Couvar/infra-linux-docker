#!/bin/bash

# Sicherer Debian-Setup für Docker-Host oder Security-Lab
# Achtung: Root-Rechte erforderlich

set -e

echo "[+] System wird aktualisiert..."
apt update && apt upgrade -y

echo "[+] Unattended Upgrades aktivieren..."
apt install -y unattended-upgrades apt-listchanges
dpkg-reconfigure --priority=low unattended-upgrades

echo "[+] Firewall aktivieren (ufw)..."
apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

echo "[+] Wichtige Sicherheitstools installieren..."
apt install -y fail2ban logwatch debsums curl wget vim gnupg lynis sudo

echo "[+] Fail2Ban konfigurieren..."
cp hardening/fail2ban.local /etc/fail2ban/jail.local
systemctl restart fail2ban

echo "[+] SSH absichern..."
cp hardening/sshd_config /etc/ssh/sshd_config
systemctl restart ssh

echo "[+] Root-Login deaktivieren..."
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

echo "[+] Logwatch konfigurieren (tägliche Zusammenfassung)..."
echo "MailTo = root" >> /etc/logwatch/conf/logwatch.conf
echo "Range = yesterday" >> /etc/logwatch/conf/logwatch.conf

echo "[+] AppArmor aktivieren (optional)..."
apt install -y apparmor apparmor-utils
apparmor_status

echo "[+] Abschlusstest mit Lynis..."
lynis audit system --quick

echo "[+] Einrichtung abgeschlossen."

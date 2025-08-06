#!/bin/bash
# Skript zum Anlegen eines neuen Benutzers mit SSH-Key

USERNAME="localadmin"
SSH_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGzW3voGAIx1EzeT4juFRns0hLuADU52MAiV6Gx210t atd\r.krause@W-BS-RKR"

# Prüfe, ob nötige Pakete installiert sind
echo "[*] Überprüfe benötigte Pakete..."

REQUIRED_PACKAGES=("adduser" "login")

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! command -v "${pkg}" >/dev/null 2>&1; then
        echo "[+] Installiere fehlendes Paket: $pkg"
        apt update
        apt install -y "$pkg"
    fi
done

adduser --disabled-password --gecos "" $USERNAME
usermod -aG sudo $USERNAME

mkdir -p /home/$USERNAME/.ssh
echo "$SSH_KEY" > /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

echo "[+] User $USERNAME wurde erstellt und SSH-Key hinzugefügt."

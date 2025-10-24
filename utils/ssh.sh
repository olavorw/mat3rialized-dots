#!/bin/bash

# SSH

# Setup SSH server

set -e

# Install OpenSSH
if ! command -v sshd &>/dev/null; then
  echo "Installing OpenSSH..."
  sudo pacman -S --needed --noconfirm openssh
fi

# Backup original sshd_config
if [ ! -f /etc/ssh/sshd_config.backup ]; then
  echo "Backing up original sshd_config..."
  sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
fi

# Configure SSH
echo "Configuring SSH..."
sudo tee /etc/ssh/sshd_config.d/custom.conf >/dev/null <<'EOF'
# Custom SSH configuration
Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/ssh/sftp-server
EOF

# Enable and start SSH service
echo "Enabling SSH service..."
sudo systemctl enable --now sshd.service

sudo systemctl enable --now fail2ban

# Show status
echo "SSH Status:"
sudo systemctl status sshd.service --no-pager

echo "SSH setup complete"
echo "Note: Password authentication is disabled. Add your public key to ~/.ssh/authorized_keys"

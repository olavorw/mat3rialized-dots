#!/bin/bash

# Setup UFW firewall with SSH only over Tailscale

set -e

# Install UFW if not present
if ! command -v ufw &>/dev/null; then
  echo "Installing UFW..."
  sudo pacman -S --needed --noconfirm ufw
fi

# Reset UFW to default state
echo "Resetting UFW to defaults..."
sudo ufw --force reset

# Set default policies
echo "Setting default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH only from Tailscale network (100.64.0.0/10)
echo "Allowing SSH on port 22 from Tailscale network..."
sudo ufw allow in on tailscale0 to any port 22

# Enable UFW
echo "Enabling UFW..."
sudo ufw --force enable

# Enable UFW service to start on boot
echo "Enabling UFW service..."
sudo systemctl enable ufw.service
sudo systemctl start ufw.service

# Show status
echo "UFW Status:"
sudo ufw status verbose

echo "UFW setup complete"

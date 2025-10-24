#!/bin/bash

# Setup Tailscale

set -e

# Install Tailscale
if ! command -v tailscale &>/dev/null; then
  echo "Installing Tailscale..."
  sudo pacman -S --needed --noconfirm tailscale
fi

# Enable and start tailscaled service
echo "Enabling tailscaled service..."
sudo systemctl enable --now tailscaled.service

# Check if already authenticated
if sudo tailscale status &>/dev/null; then
  echo "Tailscale is already connected"
  sudo tailscale status
else
  echo "Starting Tailscale authentication..."
  sudo tailscale up
fi

echo "Tailscale setup complete"

#!/bin/bash

set -e

if ! command -v ufw &>/dev/null; then
  echo "Installing UFW..."
  sudo pacman -S --needed --noconfirm syncthing
fi

systemctl --user enable --now syncthing.service

sudo ufw allow in on tailscale0 to any port 22000 proto tcp
sudo ufw allow in on tailscale0 to any port 22000 proto udp
sudo ufw allow in on tailscale0 to any port 21027 proto udp

xdg-open http://localhost:8384

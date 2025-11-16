#!/bin/bash

set -e

if ! command -v syncthing &>/dev/null; then
  echo "Installing SyncThingie..."
  sudo pacman -S --needed --noconfirm syncthing
fi

systemctl --user enable --now syncthing.service

# sudo ufw allow in on tailscale0 to any port 22000 proto tcp
# sudo ufw allow in on tailscale0 to any port 22000 proto udp
# sudo ufw allow in on tailscale0 to any port 21027 proto udp
# firewall nftables already does this in the script

xdg-open http://localhost:8384

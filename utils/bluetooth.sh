#!/bin/bash

set -e

if ! command -v ufw &>/dev/null; then
  echo "Installing UFW..."
  sudo pacman -S --needed --noconfirm blueman bluez blue-utils
fi

sudo systemctl enable bluetooth

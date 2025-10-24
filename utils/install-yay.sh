#!/bin/bash

# Install yay AUR helper

set -e

# Check if yay is already installed
if command -v yay &>/dev/null; then
  echo "yay is already installed"
  exit 0
fi

# Install base-devel and git if not present
sudo pacman -S --needed --noconfirm base-devel git

# Clone yay repository
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay

# Build and install
makepkg -si --noconfirm

# Clean up
cd ..
rm -rf yay

echo "yay installed successfully"

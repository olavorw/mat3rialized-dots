#!/bin/bash

# paru best

# Install yay AUR helper

set -e

# Check if yay is already installed
if command -v paru &>/dev/null; then
  echo "its is already installed"
  exit 0
fi

# Install base-devel and git if not present
sudo pacman -S --needed --noconfirm base-devel git

# Clone yay repository
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru

# Build and install
makepkg -si --noconfirm

# Clean up
cd ..
rm -rf paru

echo "yay installed successfully"

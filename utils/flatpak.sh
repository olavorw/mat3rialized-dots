#!/bin/bash

# Install flatpak dependencies

set -e

# Check if flatpak is installed
if ! command -v flatpak &>/dev/null; then
  echo "Installing flatpak..."
  sudo pacman -S --needed --noconfirm flatpak
fi

# Add flathub repository if not already added
if ! flatpak remotes | grep -q flathub; then
  echo "Adding flathub repository..."
  flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
fi

# List of flatpak applications
FLATPAKS=(
  org.kde.krita
  io.github.softfever.OrcaSlicer
  dev.vencord.Vesktop
  com.github.tchx84.Flatseal
  org.gnome.Snapshot
)

echo "Installing flatpak applications..."
for app in "${FLATPAKS[@]}"; do
  flatpak install -y flathub "$app"
done

echo "All flatpak dependencies installed"

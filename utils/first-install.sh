#!/bin/bash

echo "Installing the basics"

# Install AUR helper
echo "Attempting to install yay in 1 second using install-yay.sh in the utils folder"
sleep 1
./paru.sh

# Install dependencies
echo "Installing dependencies in 1 second"
sleep 1
./install-dependencies.sh

# Get the dotfiles copied over
echo "Copying dotfiles over using updater.sh in the root directory of these dots"
../updater.sh

# Install hyprland plugins
echo "Setting up hyprpm (hyprland plugins)"
./hyprplugins.sh

# font uwu
echo "Installing fonts"
./install-sf-pro-fonts.sh

# flatpak
echo "Installing flatpaks"
./flatpak.sh

# set up tailscale
echo "USER ACTION REQUIRED: Set up tailscale!"
./tailscale.sh

# neovim config clone
echo "Cloning neovim config"
./neovim.sh

# Install zsh plugins
echo "Installing zsh plugins"
./zsh.sh

# omz
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# UFW FIrewallified
echo "Activating firewall"
./ufw.sh

# Papirus folders
echo "Setting papirus folder colors"
./papirus.sh

# SSH
echo "Setting up SSH"
./ssh.sh

# Bluetooth
echo "bluetoothing"
./bluetooth.sh

echo "clamav"
./clamav.sh

echo "spto"
./spotify.sh &

# Syncthing
echo "syncing thing"
./syncthing.sh

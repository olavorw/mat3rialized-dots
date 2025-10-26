#!/bin/bash

# bro

if ! command -v git &>/dev/null; then
  echo "Installing gi"
  sudo pacman -S --needed --noconfirm git
fi

echo "cloning neovim config"
git clone "https://github.com/olavorw/nvim.git" "$HOME/.config/nvim"
echo "lazyvim installed"

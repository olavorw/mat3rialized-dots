#!/bin/bash

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy all files and directories from dotfiles root to home
echo "Installing dotfiles from $DOTFILES_DIR to $HOME..."

for item in "$DOTFILES_DIR"/*; do
  # Skip the install script itself
  if [ "$(basename "$item")" = "$(basename "$0")" ]; then
    continue
  fi

  # Skip .git directory
  if [ "$(basename "$item")" = ".git" ]; then
    continue
  fi

  if [ "$(basename "$item")" = "deps.txt" ]; then
    continue
  fi

  # Copy item to home directory
  cp -r "$item" "$HOME/"
  echo "Copied $(basename "$item")"
done

echo "Dotfiles installed successfully!"

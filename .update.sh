#!/bin/bash

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "Dotfiles Installation Script"
echo "========================================"
echo "Source directory: $DOTFILES_DIR"
echo "Target directory: $HOME"
echo ""

# Copy all files and directories from dotfiles root to home
echo "Installing dotfiles..."
echo ""

SKIPPED=0
COPIED=0

shopt -s dotglob nullglob

for item in $DOTFILES_DIR/*; do
  BASENAME="$(basename "$item")"

  # Skip the install script itself
  if [ "$BASENAME" = "$(basename "$0")" ]; then
    echo "[SKIP] $BASENAME (install script)"
    ((SKIPPED++))
    continue
  fi

  # Skip .git directory
  if [ "$BASENAME" = ".git" ]; then
    echo "[SKIP] $BASENAME (git directory)"
    ((SKIPPED++))
    continue
  fi

  if [ "$BASENAME" = ".utils" ]; then
    echo "[SKIP] $BASENAME (utils directory)"
    ((SKIPPED++))
    continue
  fi

  # Copy item to home directory
  echo "[COPY] $BASENAME"
  if cp -rv "$item" "$HOME/" 2>&1 | sed 's/^/       /'; then
    ((COPIED++))
  else
    echo "       ERROR: Failed to copy $BASENAME"
  fi
  echo ""
done

echo "========================================"
echo "Installation Summary"
echo "========================================"
echo "Items copied: $COPIED"
echo "Items skipped: $SKIPPED"
echo "Dotfiles installed successfully!"

#!/bin/bash

# Set papirus-icon-theme

set -e

if ! command -v papirus-folders &>/dev/null; then
  echo "Installing papirus-folders"
  paru -S --needed --noconfirm papirus-folders
fi

echo "Setting color"
papirus-folders -C black
echo "Color set"

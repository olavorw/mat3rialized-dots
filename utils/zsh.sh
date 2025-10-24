#!/bin/bash

# Clone Zsh plugins

set -e

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGIN_DIR="$HOME/.zsh"

# Create plugin directory
mkdir -p "$PLUGIN_DIR"

# Clone zsh-autosuggestions
if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
  echo "Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$PLUGIN_DIR/zsh-autosuggestions"
else
  echo "zsh-autosuggestions already exists"
fi

# Clone zsh-syntax-highlighting
if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
  echo "Cloning zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$PLUGIN_DIR/zsh-syntax-highlighting"
else
  echo "zsh-syntax-highlighting already exists"
fi

echo "Plugins cloned to $PLUGIN_DIR"
echo "Add to your .zshrc:"
echo "source $PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
echo "source $PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

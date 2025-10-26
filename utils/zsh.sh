#!/bin/bash

# Clone Zsh plugins

set -e

ZSH_CUSTOM="${ZSH_CUSTOM:-/.oh-my-zsh/custom}"
PLUGIN_DIR="$HOME/.zsh"

# Create plugin directory
mkdir -p "$PLUGIN_DIR"

git clone "https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

echo "Plugins cloned to $PLUGIN_DIR"
echo "Add to your .zshrc:"
echo "source $PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
echo "source $PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

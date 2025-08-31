#!/bin/bash

# === CONFIG ===
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/Active Random"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

cd "$WALLPAPER_DIR" || exit 1

# === HANDLE SPACES IN NAMES ===
IFS=$'\n'

# === RANDOM SELECTION (same file types as picker) ===
SELECTED_WALL=$(ls *.jpg *.png *.gif *.jpeg 2>/dev/null | shuf -n 1)
[ -z "$SELECTED_WALL" ] && exit 1
SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

echo "Selected wallpaper: $SELECTED_WALL"

# === SET WALLPAPER ===
matugen image "$SELECTED_PATH"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

# === RELOAD COMPONENTS ===
echo "Reloading Hyprland and Waybar..."
hyprctl reload
~/.scripts/wbrestart.sh

echo "--- Theme Update Complete ---"

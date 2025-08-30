#!/bin/bash

# --- CONFIGURATION ---
# Directory where your wallpapers are stored
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/Active"

# 1. Select and set a new wallpaper
WALLPAPER_PATH=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
echo "Wallpaper: $WALLPAPER_PATH"

# 2. Generate all color cache files with matugen
# matugen runs the swww command
echo "Running Matugen"
matugen image "$WALLPAPER_PATH"

# 5. Reload other desktop components
echo "Reloading Hyprland and Waybar..."
hyprctl reload
killall -SIGUSR2 waybar
pkill swaync && swaync &

cp "$WALLPAPER_PATH" ~/.config/hypr/current_wallpaper

echo "--- Theme Update Complete ---"

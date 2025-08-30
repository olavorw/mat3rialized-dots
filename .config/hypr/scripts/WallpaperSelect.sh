#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# 1. Select wallpaper with rofi
WALLPAPER_PATH=$(find "$WALLPAPER_DIR" -type f | rofi -dmenu -i -p "Select Wallpaper")

# Exit if nothing was selected
[ -z "$WALLPAPER_PATH" ] && exit 1

echo "Wallpaper: $WALLPAPER_PATH"

# 2. Generate all color cache files with matugen
echo "Running Matugen"
matugen image "$WALLPAPER_PATH"

# 3. Reload other desktop components
echo "Reloading Hyprland and Waybar..."
hyprctl reload
killall -SIGUSR2 waybar
pkill swaync && swaync &

# 4. Save current wallpaper
cp "$WALLPAPER_PATH" ~/.config/hypr/current_wallpaper

echo "--- Theme Update Complete ---"

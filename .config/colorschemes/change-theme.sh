#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
CYAN='\033[0;36m'

THEME="$1"
THEME_DIR="$HOME/.config/colorschemes/$THEME"

if [ -z "$THEME" ]; then
    echo -e "${YELLOW}Usage: $0 <theme-name>${NC}"
    exit 1
fi

if [ ! -d "$THEME_DIR" ]; then
    echo -e "${YELLOW}Theme '$THEME' not found in $THEME_DIR${NC}"
    exit 1
fi

echo -e "${CYAN}Applying theme: $THEME${NC}"

# Hyprland config
echo -e "${CYAN}-> Updating Hyprland config...${NC}"
cp "$THEME_DIR/hypr/colors.conf" "$HOME/.config/hypr/colors/colors.conf" > /dev/null 2>&1
echo ""

# Waybar style
echo -e "${CYAN}-> Updating Waybar style...${NC}"
cp "$THEME_DIR/waybar/colors.css" "$HOME/.config/waybar/colors/colors.css" > /dev/null 2>&1
echo -e "${CYAN}Restarting Waybar...${NC}"
pkill waybar > /dev/null 2>&1 && ~/.config/waybar/scripts/launch.sh > /dev/null 2>&1 & disown

# Wallpaper
echo -e "${CYAN}-> Updating wallpaper...${NC}"
swww img "$THEME_DIR/wallpaper.jpg" --transition-type center > /dev/null 2>&1
echo ""

# GTK Theme
if [ -f "$THEME_DIR/gtk-theme" ]; then
  GTK_THEME_NAME=$(cat "$THEME_DIR/gtk-theme")
  echo -e "${CYAN}-> Updating GTK theme to '$GTK_THEME_NAME'...${NC}"
  gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_NAME" > /dev/null 2>&1
else
  echo -e "${YELLOW}No gtk-theme file found in $THEME_DIR, skipping GTK theme update.${NC}"
fi
echo ""

GTK4_SRC="$THEME_DIR/gtk-4.0"
GTK4_DST="$HOME/.config/gtk-4.0"

if [[ -d "$GTK4_SRC" ]]; then
  echo -e "${CYAN}-> Linking GTK 4.0 config...${NC}"
  mkdir -p "$GTK4_DST"
  ln -sf "$GTK4_SRC/gtk.css" "$GTK4_DST/gtk.css"
  ln -sf "$GTK4_SRC/gtk-dark.css" "$GTK4_DST/gtk-dark.css"
  ln -sfn "GTK4_SRC/assets" "$GTK4_DST/assets"
else
  echo -e "${YELLOW}No gtk-4.0 directory found in $THEME_DIR, skipping GTK 4.0 config update.${NC}"
fi
echo ""

# Reload Hyprland config
echo -e "${CYAN}-> Reloading Hyprland config...${NC}"
hyprctl reload > /dev/null 2>&1
echo ""

# Terminal theme
echo -e "${CYAN}-> Updating terminal theme...${NC}"
if [ -f "$THEME_DIR/kitty/kitty.conf" ]; then
    cp "$THEME_DIR/kitty/colors.conf" "$HOME/.config/kitty/colors.conf" > /dev/null 2>&1
    echo -e "${CYAN}Kitty theme updated.${NC}"
else
    echo -e "${YELLOW}No terminal theme file found in $THEME_DIR, skipping terminal theme update.${NC}"
fi
pkill -SIGUSR1 kitty > /dev/null 2>&1
echo ""

# SwayNC theme
echo -e "${CYAN}-> Updating SwayNC theme...${NC}"
cp "$THEME_DIR/swaync/colors.css" "$HOME/.config/swaync/colors.css" > /dev/null 2>&1
pkill swaync > /dev/null 2>&1 && swaync > /dev/null 2>&1 & disown
echo ""

# wlogout theme
echo -e "${CYAN}-> Updating wlogout theme...${NC}"
cp "$THEME_DIR/wlogout/colors.css" "$HOME/.config/wlogout/colors.css" > /dev/null 2>&1
echo ""

# Rofi theme
echo -e "${CYAN}-> Updating Rofi theme...${NC}"
cp "$THEME_DIR/rofi/colors.rasi" "$HOME/.local/share/rofi/colors/colors.rasi" > /dev/null 2>&1
echo ""
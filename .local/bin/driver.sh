#!/bin/bash

ROFI_THEME=~/.config/rofi/launchers/type-1/style-3.rasi

main_menu() {
  options="Wifi
Customize
Power
Audio
Configs
  "
  choice=$(echo -e "$options" | rofi -dmenu -i -theme "$ROFI_THEME" -p "Driver Panel")

  case $choice in
  "Wifi")
    ~/.local/bin/wifimenu.sh
    ;;
  "Customize")
    customize_menu
    ;;
  esac
}

customize_menu() {
  options="Wallpaper
Color Scheme
Waybar
  "
  choice=$(echo -e "$options" | rofi -dmenu -i -theme "$ROFI_THEME" -p "Customize")
  case $choice in
  "Wallpaper")
    ~/.local/bin/walset.sh
    ;;
  "Waybar")
    ~/.config/waybar/scripts/select_style.sh
    ;;
  esac
}

main_menu

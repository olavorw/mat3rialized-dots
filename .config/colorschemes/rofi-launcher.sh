#!/bin/bash

THEME_DIR="$HOME/.config/colorschemes"
APPLY_SCRIPT="$THEME_DIR/apply-theme.sh"

# List only non-hidden directories
themes=($(find "$THEME_DIR" -maxdepth 1 -mindepth 1 -type d ! -iname ".*" -exec basename {} \; | sort))

# Show menu
selected=$(printf '%s\n' "${themes[@]}" | rofi -dmenu -theme ~/.config/rofi/launchers/type-7/style-3.rasi -p "Select Colorscheme")

[[ -n "$selected" ]] && bash "$APPLY_SCRIPT" "$selected" > /dev/null 2>&1
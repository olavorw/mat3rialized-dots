#!/bin/bash
IFS=$'\n\t'

# Define directories
waybar_styles="$HOME/.config/waybar/styles"
waybar_style="$HOME/.config/waybar/style.css"
waybar_scripts="$HOME/.config/waybar/scripts"

# Function to display menu options
menu() {
  options=()
  while IFS= read -r file; do
    options+=("$(basename "$file")")
  done < <(find -L "$waybar_styles" -maxdepth 1 -type f -exec basename {} \; | sort)

  printf '%s\n' "${options[@]}"
}

# Apply selected configuration
apply_config() {
  ln -sf "$waybar_styles/$1" "$waybar_style"
  "${waybar_scripts}/launch.sh" &
}

# Main function
main() {
  choice=$(menu | rofi -theme "$HOME/.config/rofi/launchers/type-2/style-1.rasi" -dmenu -p "WB Styles")

  if [[ -z "$choice" ]]; then
    echo "No option selected. Exiting."
    exit 0
  fi

  case $choice in
  "no panel")
    pgrep -x "waybar" && pkill waybar || true
    ;;
  *)
    apply_config "$choice"
    ;;
  esac
}

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
  pkill rofi
  #exit 0
fi

main

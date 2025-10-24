#!/bin/bash
IFS=$'\n\t'

# Define directories
waybar_styles="$HOME/.config/waybar/styles"
waybar_style="$HOME/.config/waybar/style.css"

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
  pkill waybar
  killall -9 waybar
  waybar &
  disown
}

# Main function
main() {
  choice=$(menu | rofi -theme "$HOME/.config/rofi/launchers/type-1/style-3.rasi" -dmenu -p "Styles")

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

#!/bin/bash

# Wallpaper Directory
wallpaper_dir="$HOME/Pictures/Wallpapers"

# Current Directory (to cd back to)
cwd="$(pwd)"

cd "$wallpaper_dir" || exit 1

# Handle filename spaces
IFS=$'\n'

if [ -n "$1" ]; then
  selected_wall="$1"
else
  # Function to browse directories with rofi
  browse_wallpapers() {
    local current_dir="$1"
    local relative_path="$2"

    cd "$current_dir" || return 1

    # Create menu items: directories first, then images
    local items=""

    # Add parent directory option if not in root
    if [ "$current_dir" != "$wallpaper_dir" ]; then
      items+="../ (Go Back)\n"
    fi

    # Add subdirectories
    for dir in */; do
      [ -d "$dir" ] && items+="${dir%/}\n"
    done

    # Add image files (without double formatting)
    for file in *.jpg *.jpeg *.png *.webp; do
      [ -f "$file" ] && items+="$file\n"
    done

    # Show rofi menu with icon formatting
    local selection=$(echo -e "$items" | while read -r item; do
      if [ -f "$item" ]; then
        echo -en "$item\0icon\x1f$PWD/$item\n"
      else
        echo -en "$item\n"
      fi
    done | rofi -dmenu -p "Wallpapers${relative_path:+ ($relative_path)}" -theme "~/.config/rofi/launchers/type-2/style-13.rasi")

    if [ -n "$selection" ]; then
      if [[ "$selection" == "../ (Go Back)" ]]; then
        # Go back to parent directory
        browse_wallpapers "$(dirname "$current_dir")" "$(dirname "$relative_path" 2>/dev/null)"
      elif [ -d "$selection" ]; then
        # Enter subdirectory
        browse_wallpapers "$current_dir/$selection" "${relative_path:+$relative_path/}$selection"
      elif [ -f "$selection" ]; then
        # Image selected
        selected_wall="$current_dir/$selection"
      fi
    fi
  }

  browse_wallpapers "$wallpaper_dir" ""
fi

# If not empty, pass to walset-backend
if [ -n "$selected_wall" ]; then
  notify-send "Changing Theme" "Applying new wallpaper and updating colors, please wait..."

  matugen image "$selected_wall"

  notify-send "Theme Applied" "Wallpaper and theme have been updated successfully"
fi

# Go back to where you came from
cd "$cwd" || exit 1

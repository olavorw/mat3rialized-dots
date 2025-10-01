#!/bin/bash

# === CONFIG ===
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK_PATH="$HOME/.config/themes/current-statics/.current_wallpaper"
CURRENT_DIR="$WALLPAPER_DIR"
ROFI_LAUNCHER="$HOME/.config/rofi/launchers/type-7/style-3.rasi"

# Function to select wallpaper with directory navigation
select_wallpaper() {
  local current_path="$1"

  cd "$current_path" || exit 1

  # Handle spaces in filenames
  IFS=$'\n'

  # Build menu items: directories first, then wallpapers
  local menu_items=()

  # Add parent directory option if not in root wallpaper dir
  if [[ "$current_path" != "$WALLPAPER_DIR" ]]; then
    menu_items+=(".. (Parent Directory)")
  fi

  # Add subdirectories
  for dir in $(find . -maxdepth 1 -type d ! -name "." | sort); do
    local dirname=$(basename "$dir")
    menu_items+=("$dirname")
  done

  # Add wallpaper files
  for file in $(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null); do
    menu_items+=("$file")
  done

  # Create rofi menu with icons for image files
  local selection=""
  if [[ "$current_path" != "$WALLPAPER_DIR" ]]; then
    # In subdirectory - show path in prompt
    local rel_path="${current_path#$WALLPAPER_DIR}"
    selection=$(printf '%s\n' "${menu_items[@]}" |
      while read -r item; do
        if [[ "$item" == ".. (Parent Directory)" ]] || [[ -d "$current_path/$item" ]]; then
          echo "$item"
        else
          echo -en "$item\0icon\x1f$current_path/$item\n"
        fi
      done | rofi -dmenu -p "Wallpapers$rel_path: ")
  else
    # In root directory
    selection=$(printf '%s\n' "${menu_items[@]}" |
      while read -r item; do
        if [[ "$item" == ".. (Parent Directory)" ]] || [[ -d "$current_path/$item" ]]; then
          echo "$item"
        else
          echo -en "$item\0icon\x1f$current_path/$item\n"
        fi
      done | rofi -dmenu -p "Wallpapers: ")
  fi

  [ -z "$selection" ] && exit 1

  # Handle selection
  if [[ "$selection" == ".. (Parent Directory)" ]]; then
    select_wallpaper "$(dirname "$current_path")"
  elif [[ -d "$current_path/$selection" ]]; then
    select_wallpaper "$current_path/$selection"
  else
    # Selected a wallpaper file
    echo "$current_path/$selection"
  fi
}

# === MAIN EXECUTION ===
cd "$WALLPAPER_DIR" || exit 1

SELECTED_PATH=$(select_wallpaper "$WALLPAPER_DIR")
[ -z "$SELECTED_PATH" ] && exit 1

# === SET WALLPAPER ===
matugen image "$SELECTED_PATH"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

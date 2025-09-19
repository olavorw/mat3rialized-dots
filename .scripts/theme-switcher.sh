#!/bin/bash

THEMES_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$HOME/.config/themes/current-statics/.current_theme"
CONFIG_DIR="$HOME/.config"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/All"

# Configuration: folders to copy and backup
INCLUDE_FOLDERS=("hypr" "waybar" "kitty" "swaync" "rofi" "matugen" "btop" "cava" "fastfetch" "wlogout")

# Configuration: specific files/paths to exclude from copying (but still backup)
# Format: "folder/path" or "folder/subfolder/file"
EXCLUDE_FILES=(
  "hypr/configs/monitors.conf"
  "hypr/configs/hyprsunset.conf"
  "hypr/configs/hyprlock.conf"
  "hypr/configs/hypridle.conf"
  # Add more specific exclusions here
)

# Configuration: top-level folders to completely ignore
IGNORE_FOLDERS=("current-statics" ".git" ".github")

# Check if a file/path should be excluded from copying
is_file_excluded() {
  local file_path="$1" # relative path like "hypr/configs/monitors.conf"

  for exclude in "${EXCLUDE_FILES[@]}"; do
    if [[ "$file_path" == "$exclude" ]]; then
      return 0 # true, is excluded
    fi
  done
  return 1 # false, not excluded
}

# Check if top-level folder should be ignored completely
is_folder_ignored() {
  local folder="$1"
  for ignore in "${IGNORE_FOLDERS[@]}"; do
    if [[ "$folder" == "$ignore" ]]; then
      return 0 # true, is ignored
    fi
  done
  return 1 # false, not ignored
}

# Check if folder should be included
should_include_folder() {
  local folder="$1"

  # Check if folder is in include list and not ignored
  for include in "${INCLUDE_FOLDERS[@]}"; do
    if [[ "$folder" == "$include" ]] && ! is_folder_ignored "$folder"; then
      return 0 # true, should include
    fi
  done
  return 1 # false, should not include
}

# Get list of available themes
get_themes() {
  if [[ -d "$THEMES_DIR" ]]; then
    find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | grep -v -E "^(current-statics|\.git|\.github)$" | sort
  else
    echo "No themes found in $THEMES_DIR"
    exit 1
  fi
}

# Show current theme in rofi prompt
get_current_theme() {
  if [[ -f "$CURRENT_THEME_FILE" ]]; then
    cat "$CURRENT_THEME_FILE"
  else
    echo "none"
  fi
}

# Backup current configs
backup_configs() {
  local backup_dir="$CONFIG_DIR/.theme_backups/$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$backup_dir"

  # Only backup if we have a previous theme
  if [[ -f "$CURRENT_THEME_FILE" ]]; then
    echo "Creating backup at $backup_dir"
    for dir in "${INCLUDE_FOLDERS[@]}"; do
      if [[ -d "$CONFIG_DIR/$dir" ]]; then
        echo "  → Backing up $dir/"
        cp -r "$CONFIG_DIR/$dir" "$backup_dir/" 2>/dev/null || true
      fi
    done
  fi
}

# Copy files recursively with exclusions
copy_with_exclusions() {
  local src_dir="$1"
  local dest_dir="$2"
  local base_folder="$3"

  # Create destination directory
  mkdir -p "$dest_dir"

  # Find all files and directories in source
  find "$src_dir" -type f | while read -r file; do
    # Get relative path from the base folder
    local rel_path="${file#$src_dir/}"
    local full_rel_path="$base_folder/$rel_path"

    if ! is_file_excluded "$full_rel_path"; then
      # Create directory structure and copy file
      local dest_file="$dest_dir/$rel_path"
      mkdir -p "$(dirname "$dest_file")"
      cp "$file" "$dest_file" 2>/dev/null || true
    else
      echo "    ✗ Excluding: $rel_path"
    fi
  done
}

# Copy wallpapers from theme
copy_wallpapers() {
  local theme_path="$1"
  local wallpaper_src="$theme_path/wallpapers"

  if [[ -d "$wallpaper_src" ]]; then
    echo "Copying wallpapers..."

    # Create wallpaper destination directory if it doesn't exist
    mkdir -p "$WALLPAPER_DIR"

    if [[ -d "$WALLPAPER_DIR" ]]; then
      local old_count=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \) | wc -l)

      if [[ $old_count -gt 0 ]]; then
        echo "  → Removing $old_count old wallpaper(s)"
        find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \) -delete 2>/dev/null
      fi
    fi

    # Count files to copy
    local file_count=$(find "$wallpaper_src" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \) | wc -l)

    if [[ $file_count -gt 0 ]]; then
      echo "  → Copying $file_count wallpaper(s) to $WALLPAPER_DIR"

      # Copy all image files
      find "$wallpaper_src" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \) -exec cp {} "$WALLPAPER_DIR/" \; 2>/dev/null

      # List what was copied
      find "$wallpaper_src" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \) -exec basename {} \; | while read -r filename; do
        echo "    ✓ $filename"
      done
    else
      echo "  ✗ No image files found in wallpapers folder"
    fi
  else
    echo "No wallpapers folder found in theme"
  fi
}

# Switch theme function
switch_theme() {
  local theme="$1"
  local theme_path="$THEMES_DIR/$theme"

  if [[ ! -d "$theme_path" ]]; then
    echo "Theme '$theme' not found at $theme_path"
    notify-send "Theme Switcher" "Theme '$theme' not found!" -u critical
    exit 1
  fi

  echo "Switching to theme: $theme"

  # Optional backup (uncomment if you want it)
  # backup_configs

  # Copy included folders with file exclusions
  echo "Copying theme configs..."
  for config_dir in "${INCLUDE_FOLDERS[@]}"; do
    if [[ -d "$theme_path/$config_dir" ]]; then
      echo "  → Copying $config_dir/"
      copy_with_exclusions "$theme_path/$config_dir" "$CONFIG_DIR/$config_dir" "$config_dir"
    else
      echo "  ✗ Skipping $config_dir/ (not found in theme)"
    fi
  done

  # Copy wallpapers if they exist
  copy_wallpapers "$theme_path"

  # Handle GTK theme from .gtk_theme file
  local gtk_theme_file="$theme_path/.gtk_theme"
  if [[ -f "$gtk_theme_file" ]] && command -v nwg-look >/dev/null 2>&1; then
    local gtk_theme
    gtk_theme=$(cat "$gtk_theme_file" | head -1 | xargs)
    if [[ -n "$gtk_theme" ]]; then
      echo "Switching GTK theme to: $gtk_theme"
      nwg-look -x -t "$gtk_theme" 2>/dev/null || echo "Warning: GTK theme '$gtk_theme' not found"
    fi
  elif command -v nwg-look >/dev/null 2>&1; then
    echo "No .gtk_theme file found, skipping GTK theme switch"
  fi

  # Save current theme
  echo "$theme" >"$CURRENT_THEME_FILE"

  # Reload services
  reload_services "$theme"
}

# Reload relevant services
reload_services() {
  local theme="$1"

  echo "Reloading services..."

  # Reload Hyprland config
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || echo "Warning: Failed to reload Hyprland"
  fi

  # Restart waybar
  if pgrep waybar >/dev/null; then
    echo "  → Restarting waybar"
    pkill waybar
    sleep 0.5
    waybar &
  fi

  # Restart swaync if running
  if pgrep swaync >/dev/null; then
    echo "  → Restarting swaync"
    pkill swaync
    sleep 0.2
    swaync &
  fi

  echo "✓ Theme '$theme' applied successfully!"
}

# Main logic
if ! command -v rofi >/dev/null 2>&1; then
  echo "Error: rofi not found"
  exit 1
fi

current=$(get_current_theme)
selected=$(get_themes | rofi -dmenu -p "Theme [$current]" -theme-str 'window {width: 400px; height: 300px;}')

if [[ -n "$selected" ]]; then
  switch_theme "$selected"

  # Show notification
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Theme Switcher" "✓ Switched to: $selected" -i preferences-desktop-theme -t 3000
  fi
fi

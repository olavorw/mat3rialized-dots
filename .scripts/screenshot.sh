#!/bin/sh

# The directory where screenshots will be saved.
SAVE_DIR=~/Pictures/Screenshots
mkdir -p "${SAVE_DIR}"

# Create a unique filename using the current date and time.
FILENAME="${SAVE_DIR}/$(date +'%Y-%m-%d_%Hh%Mm%Ss').png"

# Capture a selected area and save it directly to the file.
# The 'if' statement handles the case where you cancel the selection (e.g., by pressing Escape).
if grim -g "$(slurp)" "${FILENAME}"; then
  # If grim successfully saved the file, then copy that file to the clipboard.
  wl-copy <"${FILENAME}"

  # Send a single notification confirming both actions are complete.
  notify-send "Screenshot Taken" "Saved to file and copied to clipboard."
else
  # If you canceled the selection, notify that nothing happened.
  notify-send "Screenshot Canceled"
fi

#!/bin/bash

# Get current keyboard layout from Hyprland
LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' 2>/dev/null)

# Check for active input method
if command -v fcitx5-remote >/dev/null 2>&1; then
  IM_STATE=$(fcitx5-remote)
  CURRENT_IM=$(fcitx5-remote -n 2>/dev/null)
elif command -v ibus >/dev/null 2>&1; then
  CURRENT_IM=$(ibus engine)
else
  CURRENT_IM=""
fi

# Determine display based on input method and layout
case "$CURRENT_IM" in
*mozc*)
  echo '{"text": "あ JP", "tooltip": "Japanese (Mozc)", "class": "japanese"}'
  ;;
*rime* | *pinyin*)
  echo '{"text": "拼 ZH", "tooltip": "Chinese (Rime/Pinyin)", "class": "chinese"}'
  ;;
*chinese* | *hanzi*)
  echo '{"text": "汉 ZH", "tooltip": "Chinese (Hanzi)", "class": "chinese"}'
  ;;
*)
  case "$LAYOUT" in
  *us* | *en*)
    echo '{"text": "EN", "tooltip": "English (US)", "class": "english"}'
    ;;
  *)
    echo '{"text": "EN", "tooltip": "English (Default)", "class": "english"}'
    ;;
  esac
  ;;
esac

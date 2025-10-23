#!/bin/bash

STATE_FILE="/tmp/hypr_gap_state"
WS=$(hyprctl activeworkspace -j | jq '.id')

# Check if current workspace has gaps on
STATE=$(grep -w "$WS" "$STATE_FILE" 2>/dev/null | awk '{print $2}')

if [[ "$STATE" == "1" ]]; then
  # Turn gaps off and radius to 0
  hyprctl keyword decoration:active_opacity 1
  hyprctl keyword decoration:inactive_opacity 1
  sed -i "/^$WS /d" "$STATE_FILE"
  echo "$WS 0" >>"$STATE_FILE"
else
  # Turn gaps on and radius to your desired value (e.g., 10)
  hyprctl keyword decoration:active_opacity 0.9
  hyprctl keyword decoration:inactive_opacity 0.8
  sed -i "/^$WS /d" "$STATE_FILE"
  echo "$WS 1" >>"$STATE_FILE"
fi

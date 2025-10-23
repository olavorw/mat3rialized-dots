#!/bin/bash
# Save as ~/.config/waybar/scripts/protonvpn.sh

# Check for ProtonVPN interface (usually proton0)
VPN_INTERFACE=$(ip link show | grep -o 'proton[0-9]*' | head -n1)

if [ -n "$VPN_INTERFACE" ]; then
  # Get server info from connection
  SERVER=$(nmcli -t -f NAME connection show --active | grep -i proton | head -n1)
  if [ -z "$SERVER" ]; then
    SERVER="Connected"
  fi
  echo "{\"text\": \"󰒄 ${SERVER}\", \"class\": \"connected\", \"tooltip\": \"VPN Active\"}"
else
  echo "{\"text\": \"󰒃\", \"class\": \"disconnected\", \"tooltip\": \"VPN Disconnected\"}"
fi

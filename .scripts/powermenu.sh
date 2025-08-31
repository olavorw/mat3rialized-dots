#!/bin/sh
chosen=$(printf "  Power Off\n  Restart\n  Sleep\n  Lock\n  Log Out" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
"  Power Off") systemctl poweroff ;;
"  Restart") systemctl reboot ;;
"  Sleep") systemctl suspend ;;
"  Lock") swaylock -f -c 000000 ;;
"  Log Out") hyprctl dispatch exit "" ;;
*) exit 1 ;;
esac

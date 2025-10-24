#!/usr/bin/bash
pkill swaync
killall -9 swaync
swaync &
disown
sleep 0.5
notify-send "Swaync Reloaded" "The launch.sh script inside the swaync config has reloaded the notification system"

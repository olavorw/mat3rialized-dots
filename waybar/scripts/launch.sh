pkill waybar
killall -9 waybar
waybar &
disown
notify-send "Waybar reloaded" "The launch.sh script in the waybar configuration directory has reloaded waybar"

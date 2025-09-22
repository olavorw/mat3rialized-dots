#!/bin/bash
# Get id of an active window
active_pid=$(hyprctl activewindow | grep -o 'pid: [0-9]*' | cut -d' ' -f2)

# Close active window
killall -9 $active_pid

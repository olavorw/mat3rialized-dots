#!/bin/bash

echo "hyprland plugins"

hyprpm update

hyprpm add https://github.com/hyprwm/hyprland-plugins

hyprpm enable hyprexpo
hyprpm enable hyprscrolling

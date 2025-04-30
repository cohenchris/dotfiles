#!/bin/bash

# Hyprland
hyprctl reload

# Waybar
pkill waybar
hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME}/waybar/top.jsonc"
hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME}/waybar/bottom.jsonc"

# Hyprsunset
pkill hyprsunset
hyprsunset &

# Hypridle
pkill hypridle
hypridle &

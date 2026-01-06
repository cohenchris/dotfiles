#!/bin/bash
# Custom hyprland-related scripts directory
HYPRLAND_SCRIPTS_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/waybar/scripts"

# Hyprland
hyprctl reload

# Waybar
pkill waybar
${HYPRLAND_SCRIPTS_DIR}/waybar.sh

# Hyprsunset
pkill hyprsunset
hyprsunset &

# Hypridle
pkill hypridle
hypridle &

# Hyprpaper
pkill hyprpaper
hyprpaper &

sleep 0.1
set-wallpaper random

${HYPRLAND_SCRIPTS_DIR}/speedtest.sh refresh

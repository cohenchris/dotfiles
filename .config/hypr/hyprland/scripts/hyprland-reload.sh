#!/usr/bin/env bash
# Custom hyprland-related scripts directory
HYPRLAND_SCRIPTS_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/waybar/scripts"

# Hyprland
hyprctl reload

# Dunst
pkill dunst
dunst &

# Hyprpaper
pkill hyprpaper
hyprpaper &

# Hypridle
pkill hypridle
hypridle &

# Waybar
pkill waybar
${HYPRLAND_SCRIPTS_DIR}/waybar.sh

# Hyprsunset
pkill hyprsunset
hyprsunset &

sleep 0.1
SET_WALLPAPER random

# hyprpolkitagent
pkill hyprpolkitagent
/usr/lib/hyprpolkitagent/hyprpolkitagent &

# Battery monitor
pkill BATTERY_MONITOR
BATTERY_MONITOR &

# swayosd-server
pkill swayosd-server
swayosd-server &
${HYPRLAND_SCRIPTS_DIR}/speedtest.sh refresh

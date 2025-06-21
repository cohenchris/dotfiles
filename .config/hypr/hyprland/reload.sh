#!/bin/bash

# Hyprland
hyprctl reload

# Waybar
pkill waybar
${XDG_CONFIG_HOME:-${HOME}/.config}/waybar/scripts/waybar.sh

# Hyprsunset
pkill hyprsunset
hyprsunset &

# Hypridle
pkill hypridle
hypridle &

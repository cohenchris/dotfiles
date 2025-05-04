#!/bin/bash

if [ -e "/sys/class/power_supply" ]; then
  # No battery information means we're on a desktop
  SYSTEM_TYPE="desktop"
else
  # Battery information means we're on a laptop
  SYSTEM_TYPE="laptop"
fi

hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME}/waybar/${SYSTEM_TYPE}/top.jsonc"
hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME}/waybar/${SYSTEM_TYPE}/bottom.jsonc"

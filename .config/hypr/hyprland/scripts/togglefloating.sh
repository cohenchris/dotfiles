#!/usr/bin/env bash

is_floating=$(hyprctl activewindow -j | jq -r '.floating')

# Toggle floating mode
hyprctl dispatch togglefloating

# Resize + center window if it is now floating (was not initially floating)
if [ "${is_floating}" = "false" ]; then
  hyprctl dispatch resizeactive exact 1400 800
  hyprctl dispatch centerwindow
fi

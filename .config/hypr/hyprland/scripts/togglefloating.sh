#!/usr/bin/env bash

is_floating=$(hyprctl activewindow -j | jq -r '.floating')

# Toggle floating mode
hyprctl dispatch 'hl.dsp.window.float()'

# Resize + center window if it is now floating (was not initially floating)
if [ "${is_floating}" = "false" ]; then
  hyprctl dispatch 'hl.dsp.window.resize({ x = 1400, y = 800 })'
  hyprctl dispatch 'hl.dsp.window.center()'
fi

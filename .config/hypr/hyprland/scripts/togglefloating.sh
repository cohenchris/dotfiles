#!/usr/bin/env bash

is_floating=$(hyprctl activewindow -j | jq -r '.floating')

# Toggle floating mode
hyprctl dispatch 'hl.dsp.window.float()'

# Resize + center window if it is now floating (was not initially floating)
if [ "${is_floating}" = "false" ]; then
  # Scale the default floating size to the focused monitor's logical
  # resolution (physical size / scale), matching the "large_floating_popup"
  # ratio in hyprland/rules.lua, so this looks right on any screen size.
  read -r resize_x resize_y <<< "$(hyprctl monitors -j | jq -r '
    [.[] | select(.focused)][0] |
    ((.width / .scale) * 0.7 | floor) as $x |
    ((.height / .scale) * 0.7 | floor) as $y |
    "\($x) \($y)"
  ')"

  hyprctl dispatch "hl.dsp.window.resize({ x = ${resize_x}, y = ${resize_y} })"
  hyprctl dispatch 'hl.dsp.window.center()'
fi

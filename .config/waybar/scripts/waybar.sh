#!/bin/bash

hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME}/waybar/top.jsonc"
hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME}/waybar/bottom.jsonc"

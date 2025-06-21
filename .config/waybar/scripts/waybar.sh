#!/bin/bash

hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME:-${HOME}/.config}/waybar/top.jsonc"
hyprctl dispatch exec "waybar -c ${XDG_CONFIG_HOME:-${HOME}/.config}/waybar/bottom.jsonc"

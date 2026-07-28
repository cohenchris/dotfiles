#!/usr/bin/env bash

WAYBAR_CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/waybar"

hyprctl dispatch "hl.dsp.exec_cmd(\"waybar -c ${WAYBAR_CONFIG_DIR}/top.jsonc\")"
hyprctl dispatch "hl.dsp.exec_cmd(\"waybar -c ${WAYBAR_CONFIG_DIR}/bottom.jsonc\")"

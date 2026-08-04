#!/usr/bin/env bash
# Toggles the shared usage/temperature display mode used by the CPU, GPU, and
# memory waybar modules. Those scripts only ever read system-monitor-mode;
# this script is the sole place that writes it.

mode_file="${XDG_CACHE_HOME:-${HOME}/.local/cache}/system-monitor-mode"

system_monitor_toggle() {
  local mode
  mode=$(cat "${mode_file}" 2>/dev/null)
  [[ "${mode}" != "usage" ]] && mode="temp"

  if [[ "${mode}" == "temp" ]]; then
    echo "usage" > "${mode_file}"
  else
    echo "temp" > "${mode_file}"
  fi

  # Ask waybar to re-run the cpu/gpu/memory modules immediately instead of
  # waiting for their next interval
  pkill -RTMIN+9 waybar
}

if [[ "${1}" == "toggle" ]]; then
  system_monitor_toggle
else
  echo "USAGE: system-monitor.sh [toggle]"
  exit 1
fi

#!/usr/bin/env bash
# GPU waybar module, sourced from glances. Glances already abstracts over
# Nvidia/AMD/Intel/ARM GPUs, so this script is vendor-agnostic and works on
# any machine glances supports without needing to detect the GPU type itself.
# Assumes a single GPU.

gpu_icon="󰨇"

mode_file="${XDG_CACHE_HOME:-${HOME}/.local/cache}/system-monitor-mode"

mode=$(cat "${mode_file}" 2>/dev/null)
[[ "${mode}" != "usage" ]] && mode="temp"

json=$(glances --stdout-json gpu \
  --disable-plugin all --enable-plugin gpu \
  --disable-check-update \
  -t 0.1 --stop-after 1 2>/dev/null)

gpu_count=$(jq -r '.gpu | length' <<< "${json}")
[[ "${gpu_count}" -eq 0 ]] && exit 0

gpu_name=$(jq -r '.gpu[0].name' <<< "${json}")
gpu_use_percent=$(jq -r '.gpu[0].proc | select(. != null) | round' <<< "${json}")
gpu_temp=$(jq -r '.gpu[0].temperature | select(. != null) | round' <<< "${json}")
gpu_mem_percent=$(jq -r '.gpu[0].mem | select(. != null) | round' <<< "${json}")
gpu_fan_speed=$(jq -r '.gpu[0].fan_speed | select(. != null) | round' <<< "${json}")

# Tooltip formatting: always show every metric, NA for anything the GPU doesn't report
waybar_tooltip_info="Name:\t${gpu_name}"
usage_tooltip="\nUsage:\t${gpu_use_percent:-NA}%"
temp_tooltip="\nTemp:\t${gpu_temp:-NA}°C"
mem_tooltip="\nVRAM:\t${gpu_mem_percent:-NA}%"
fan_tooltip="\nFans:\t${gpu_fan_speed:-NA}%"

# Threshold-based class, matching whichever metric is currently displayed
if [[ "${mode}" == "temp" ]]; then
  if [[ -n "${gpu_temp}" ]]; then
    if [ "${gpu_temp}" -ge "90" ]; then
      waybar_class="critical"
    elif [ "${gpu_temp}" -ge "80" ]; then
      waybar_class="warning"
    fi
  fi
else
  if [[ -n "${gpu_use_percent}" ]]; then
    if [ "${gpu_use_percent}" -ge "90" ]; then
      waybar_class="critical"
    elif [ "${gpu_use_percent}" -ge "80" ]; then
      waybar_class="warning"
    fi
  fi
fi

# Final waybar text/tooltip (mode toggled via system-monitor.sh)
if [[ "${mode}" == "temp" ]]; then
  toggle_message="Usage"
  if [[ -n "${gpu_temp}" ]]; then
    waybar_text="${gpu_icon}  $(printf '%2s' ${gpu_temp})°C"
  else
    waybar_text="${gpu_icon}  NA°C"
  fi
else
  toggle_message="Temp"
  if [[ -n "${gpu_use_percent}" ]]; then
    waybar_text="${gpu_icon}  $(printf '%2d' ${gpu_use_percent})%"
  else
    waybar_text="${gpu_icon}  NA%"
  fi
fi

waybar_tooltip="<big>GPU</big>\t(󰳽 for ${toggle_message})\n\n${waybar_tooltip_info}${usage_tootip}${temp_tooltip}${mem_tooltip}${fan_tooltip}"

echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"

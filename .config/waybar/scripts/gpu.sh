#!/usr/bin/env bash
# GPU waybar module, sourced from glances. Glances already abstracts over
# Nvidia/AMD/Intel/ARM GPUs, so this script is vendor-agnostic and works on
# any machine glances supports without needing to detect the GPU type itself.

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

gpu_names=$(jq -r '[.gpu[].name] | unique | join(", ")' <<< "${json}")
gpu_use_percent=$(jq -r '[.gpu[].proc | select(. != null)] | if length > 0 then (add / length | round) else empty end' <<< "${json}")
gpu_temp=$(jq -r '[.gpu[].temperature | select(. != null)] | if length > 0 then (add / length | round) else empty end' <<< "${json}")
gpu_mem_percent=$(jq -r '[.gpu[].mem | select(. != null)] | if length > 0 then (add / length * 10 | round / 10) else empty end' <<< "${json}")
gpu_fan_speed=$(jq -r '[.gpu[].fan_speed | select(. != null)] | if length > 0 then (add / length | round) else empty end' <<< "${json}")

# Per-GPU breakdown for the active metric (machines with multiple GPUs get one line each)
if [[ "${mode}" == "temp" ]]; then
  per_gpu_tooltip=$(jq -r '.gpu[] | select(.temperature != null) | "\(.name):\t\(.temperature)°C"' <<< "${json}" | sed ':a;N;$!ba;s/\n/\\n/g')
else
  per_gpu_tooltip=$(jq -r '.gpu[] | select(.proc != null) | "\(.name):\t\(.proc)%"' <<< "${json}" | sed ':a;N;$!ba;s/\n/\\n/g')
fi

# Tooltip formatting (only include lines for data the GPU actually reports)
info_tooltip="Name:\t${gpu_names}"
mem_tooltip="" fan_tooltip=""
[[ -n "${gpu_mem_percent}" ]] && mem_tooltip="\nMem:\t${gpu_mem_percent}%"
[[ -n "${gpu_fan_speed}" ]] && fan_tooltip="\nFan:\t${gpu_fan_speed}%"

# Temperature-based classes
if [[ -n "${gpu_temp}" ]]; then
  if [ "${gpu_temp}" -ge "90" ]; then
    waybar_class="critical"
  elif [ "${gpu_temp}" -ge "80" ]; then
    waybar_class="warning"
  fi
fi

# Final waybar text/tooltip (mode toggled via system-monitor.sh)
if [[ "${mode}" == "temp" && -n "${gpu_temp}" ]]; then
  waybar_text="${gpu_icon}  $(printf '%2s' ${gpu_temp})°C"
else
  waybar_text="${gpu_icon}  $(printf '%2d' ${gpu_use_percent:-0})%"
fi

waybar_tooltip="<big>GPU</big> (click to toggle)\n\n${info_tooltip}${mem_tooltip}${fan_tooltip}\n\n${per_gpu_tooltip}"

echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"

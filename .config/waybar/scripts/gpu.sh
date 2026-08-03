#!/usr/bin/env bash
# GPU waybar module, sourced from glances. Glances already abstracts over
# Nvidia/AMD/Intel/ARM GPUs, so this script is vendor-agnostic and works on
# any machine glances supports without needing to detect the GPU type itself.

gpu_icon="󰨇"

query_gpu() {
  glances --stdout-json gpu \
    --disable-plugin all --enable-plugin gpu \
    -t 0.1 --stop-after 1 2>/dev/null
}

# gpu_waybar()
#
# Captures GPU information from glances for use in a waybar module.
# Custom waybar modules require input as JSON.
gpu_waybar() {
  local json
  json=$(query_gpu)

  local gpu_count
  gpu_count=$(jq -r '.gpu | length' <<< "${json}")
  [[ "${gpu_count}" -eq 0 ]] && exit 0

  local gpu_names gpu_use_percent gpu_temp gpu_mem_percent gpu_fan_speed
  gpu_names=$(jq -r '[.gpu[].name] | unique | join(", ")' <<< "${json}")
  gpu_use_percent=$(jq -r '[.gpu[].proc | select(. != null)] | if length > 0 then (add / length | round) else empty end' <<< "${json}")
  gpu_temp=$(jq -r '[.gpu[].temperature | select(. != null)] | if length > 0 then (add / length | round) else empty end' <<< "${json}")
  gpu_mem_percent=$(jq -r '[.gpu[].mem | select(. != null)] | if length > 0 then (add / length * 10 | round / 10) else empty end' <<< "${json}")
  gpu_fan_speed=$(jq -r '[.gpu[].fan_speed | select(. != null)] | if length > 0 then (add / length | round) else empty end' <<< "${json}")

  # Tooltip formatting (only include lines for data the GPU actually reports)
  local info_tooltip="Name:\t${gpu_names}"
  local usage_tooltip="Usage:\t${gpu_use_percent:-N/A}%"
  local temperature_tooltip="" mem_tooltip="" fan_tooltip=""
  [[ -n "${gpu_temp}" ]] && temperature_tooltip="\nTemp:\t${gpu_temp}°C"
  [[ -n "${gpu_mem_percent}" ]] && mem_tooltip="\nMem:\t${gpu_mem_percent}%"
  [[ -n "${gpu_fan_speed}" ]] && fan_tooltip="\nFan:\t${gpu_fan_speed}%"

  # Temperature-based classes
  local waybar_class=""
  if [[ -n "${gpu_temp}" ]]; then
    if [ "${gpu_temp}" -ge "90" ]; then
      waybar_class="critical"
    elif [ "${gpu_temp}" -ge "80" ]; then
      waybar_class="warning"
    fi
  fi

  # Final waybar text/tooltip
  local waybar_text="${gpu_icon}  $(printf '%2d' ${gpu_use_percent:-0})%"
  [[ -n "${gpu_temp}" ]] && waybar_text="${waybar_text} / $(printf '%2s' ${gpu_temp})°C"
  local waybar_tooltip="<big>GPU</big>\n\n${info_tooltip}\n\n${usage_tooltip}${temperature_tooltip}${mem_tooltip}${fan_tooltip}"

  echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"
}

# gpu_monitor()
#
# Opens glances' own dashboard, which already covers GPU/CPU/memory for
# whatever hardware is present, in place of a vendor-specific tool.
gpu_monitor() {
  notify NORMAL "${gpu_icon}  Monitoring GPU..."
  TERMINAL --title "GPU" glances
}


if [[ "${1}" == "waybar" ]]; then
  gpu_waybar

elif [[ "${1}" == "monitor" ]]; then
  gpu_monitor

else

  # Invalid command, print help message
  echo "USAGE: gpu.sh [waybar,monitor]"
  exit 1

fi

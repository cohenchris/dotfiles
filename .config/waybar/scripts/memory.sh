#!/usr/bin/env bash
# Memory waybar module, sourced from glances (machine-agnostic; works on
# any system glances supports instead of parsing `free`/`sensors` directly).

memory_icon=" "

mode_file="${XDG_CACHE_HOME:-${HOME}/.local/cache}/system-monitor-mode"

mode=$(cat "${mode_file}" 2>/dev/null)
[[ "${mode}" != "usage" ]] && mode="temp"

json=$(glances --stdout-json mem,sensors \
  --disable-plugin all --enable-plugin mem,sensors \
  --disable-check-update \
  -t 0.1 --stop-after 1 2>/dev/null)

ram_available=$(jq -r '.mem.available / 1073741824 * 10 | round / 10' <<< "${json}")
ram_used=$(jq -r '.mem.used / 1073741824 * 10 | round / 10' <<< "${json}")
ram_use_percent=$(jq -r '.mem.percent' <<< "${json}")
rounded_ram_use_percent=$(jq -r '.mem.percent | round' <<< "${json}")

# RAM temperature (optional; jc42 DIMM sensors or cros_ec ddr_ sensors, if present)
mapfile -t ram_temps < <(jq -r '
  [.sensors[] | select(.label | test("jc42"; "i") or test("ddr"; "i"))]
  | .[].value
' <<< "${json}")

rounded_ram_temp_average=$(
  printf '%s\n' "${ram_temps[@]}" |
  awk '{ sum += $1; count++ }
       END { if (count > 0) printf "%d", sum / count }'
)
rounded_ram_temp_average=${rounded_ram_temp_average:-0}

# Tooltip formatting
ram_usage_tooltip=$(printf "Used:         %s GB\nAvailable:    %s GB\nUsage:        %s%%" \
  "${ram_used}" "${ram_available}" "${ram_use_percent}" | sed ':a;N;$!ba;s/\n/\\n/g')
ram_temp_tooltip=$(
  for i in "${!ram_temps[@]}"; do
    printf "DIMM%d Temp:   %s°C\n" "$((i + 1))" "${ram_temps[i]}"
  done | sed ':a;N;$!ba;s/\n/\\n/g'
)

# Temperature-based classes
if [ "${rounded_ram_temp_average}" -ge "55" ]; then
  waybar_class="critical"
fi

# Final waybar text/tooltip (mode toggled via system-monitor.sh)
if [[ "${mode}" == "temp" ]]; then
  waybar_text="${memory_icon} $(printf '%2s' ${rounded_ram_temp_average})°C"
  if [ "${#ram_temps[@]}" -gt 0 ]; then
    waybar_tooltip="<big>MEMORY</big>  (󰳽 for Usage)\n\n${ram_temp_tooltip}"
  else
    waybar_tooltip="<big>MEMORY</big>  (󰳽 for Usage)\n\nNo RAM temperature sensors found"
  fi
else
  waybar_text="${memory_icon} $(printf '%2d' ${rounded_ram_use_percent})%"
  waybar_tooltip="<big>MEMORY</big>  (󰳽 for Temp)\n\n${ram_usage_tooltip}"
fi

echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"

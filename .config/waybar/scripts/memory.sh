#!/usr/bin/env bash
# Memory/swap waybar module, sourced from glances (machine-agnostic; works on
# any system glances supports instead of parsing `free`/`sensors` directly).

memory_icon=" "

json=$(glances --stdout-json mem,memswap,sensors \
  --disable-plugin all --enable-plugin mem,memswap,sensors \
  -t 0.1 --stop-after 1 2>/dev/null)

ram_total=$(jq -r '.mem.total / 1073741824 * 10 | round / 10' <<< "${json}")
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

# Swap usage
swap_total=$(jq -r '.memswap.total / 1073741824 * 10 | round / 10' <<< "${json}")
swap_used=$(jq -r '.memswap.used / 1073741824 * 10 | round / 10' <<< "${json}")
swap_use_percent=$(jq -r '.memswap.percent' <<< "${json}")

# Tooltip formatting
ram_usage_tooltip="RAM Usage:    ${ram_used} GB / ${ram_total} GB  (${ram_use_percent}%)"
ram_temp_tooltip=$(
  for i in "${!ram_temps[@]}"; do
    printf "DIMM%d Temp:   %s°C\n" "$((i + 1))" "${ram_temps[i]}"
  done | sed ':a;N;$!ba;s/\n/\\n/g'
)
swap_usage_tooltip="Swap Usage:   ${swap_used} GB / ${swap_total} GB  (${swap_use_percent}%)"

# Temperature-based classes
if [ "${rounded_ram_temp_average}" -ge "55" ]; then
  waybar_class="critical"
fi

# Final waybar text/tooltip
waybar_text="${memory_icon} $(printf '%2d' ${rounded_ram_use_percent})% / $(printf '%2s' ${rounded_ram_temp_average})°C"
waybar_tooltip="<big>MEMORY</big>\n\n${ram_usage_tooltip}\n${ram_temp_tooltip}\n\n${swap_usage_tooltip}"

echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"

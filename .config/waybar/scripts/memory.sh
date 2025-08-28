#!/bin/bash

memory_icon=" "

read -r _ total used _ <<< $(free -m | awk '/^Mem:/ {print $1, $2, $3, $4}')
ram_total=$(awk "BEGIN {printf \"%.1f\", $total / 1024}")
ram_used=$(awk "BEGIN {printf \"%.1f\", $used / 1024}")
ram_use_percent=$(awk "BEGIN {printf \"%.1f\", ($used / $total) * 100}")
rounded_ram_use_percent=$(awk "BEGIN {printf \"%d\", ($used / $total) * 100}")

# RAM temperature (optional, may require lm-sensors and a supported system)
mapfile -t ram_temps < <(sensors | awk '
/^jc42/ {in_jc42=1; next}
in_jc42 && /^Adapter:/ {next}
in_jc42 && /temp1:/ {
  match($2, /\+([0-9.]+)°C/, m)
  if (m[1] != "") print m[1]
  in_jc42=0
}')

ram_temp_dimm1="${ram_temps[0]}"
ram_temp_dimm2="${ram_temps[1]}"
ram_temp_dimm3="${ram_temps[2]}"
ram_temp_dimm4="${ram_temps[3]}"
rounded_ram_temp_average=$(awk "BEGIN {printf \"%d\", (${ram_temp_dimm1} + ${ram_temp_dimm2} + ${ram_temp_dimm3} + ${ram_temp_dimm4}) / 4}")

# Swap usage
read -r _ sw_total sw_used _ <<< $(free -m | awk '/^Swap:/ {print $1, $2, $3, $4}')
swap_total=$(awk "BEGIN {printf \"%.1f\", $sw_total / 1024}")
swap_used=$(awk "BEGIN {printf \"%.1f\", $sw_used / 1024}")
swap_use_percent=$(awk "BEGIN {printf \"%.1f\", ($sw_used / $sw_total) * 100}")

# Handle division by zero (e.g., no swap)
if [ "${sw_total}" -eq 0 ]; then
  swap_use_percent="0.0"
fi

# Tooltip formatting
ram_usage_tooltip="RAM Usage:    ${ram_used} GB / ${ram_total} GB  (${ram_use_percent}%)"
ram_temp_tooltip="DIMM1 Temp:   ${ram_temp_dimm1}°C\nDIMM2 Temp:   ${ram_temp_dimm2}°C\nDIMM3 Temp:   ${ram_temp_dimm3}°C\nDIMM4 Temp:   ${ram_temp_dimm4}°C"
swap_usage_tooltip="Swap Usage:   ${swap_used} GB / ${swap_total} GB  (${swap_use_percent}%)"

# Temperature-based classes
if [ "${rounded_ram_temp_average}" -ge "55" ]; then
  waybar_class="critical"
fi

# Final waybar text/tooltip
waybar_text="${memory_icon} $(printf '%2d' ${rounded_ram_use_percent})% / $(printf '%2s' ${rounded_ram_temp_average})°C"
waybar_tooltip="<big>MEMORY</big>\n\n${ram_usage_tooltip}\n${ram_temp_tooltip}\n\n${swap_usage_tooltip}"

echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"

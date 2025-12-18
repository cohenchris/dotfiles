#!/bin/bash

memory_icon=" "

read -r _ total used _ <<< $(free -m | awk '/^Mem:/ {print $1, $2, $3, $4}')
ram_total=$(awk "BEGIN {printf \"%.1f\", $total / 1024}")
ram_used=$(awk "BEGIN {printf \"%.1f\", $used / 1024}")
ram_use_percent=$(awk "BEGIN {printf \"%.1f\", ($used / $total) * 100}")
rounded_ram_use_percent=$(awk "BEGIN {printf \"%d\", ($used / $total) * 100}")

# RAM temperature (optional, may require lm-sensors and a supported system)
mapfile -t ram_temps < <(
  sensors | awk '
    # --- jc42 RAM sensors ---
    /^jc42/ { in_jc42 = 1; next }
    in_jc42 && /^Adapter:/ { next }
    in_jc42 && /temp1:/ {
      if (match($2, /\+([0-9.]+)°C/, m)) {
        print m[1]
      }
      in_jc42 = 0
    }

    # --- cros_ec RAM sensor ---
    /^ddr_/ {
      if (match($2, /\+([0-9.]+)°C/, m)) {
        print m[1]
      }
    }
  '
)

rounded_ram_temp_average=$(
  printf '%s\n' "${ram_temps[@]}" |
  awk '{ sum += $1; count++ }
       END { if (count > 0) printf "%d", sum / count }'
)


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
ram_temp_tooltip=$(
  for i in "${!ram_temps[@]}"; do
    printf "DIMM%d Temp:   %s°C\n" "$((i + 1))" "${ram_temps[i]}"
  done
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

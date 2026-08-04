#!/usr/bin/env bash
# CPU usage/temperature waybar module, sourced from glances (machine-agnostic;
# works on any system glances supports instead of parsing /proc/stat + sensors).

cpu_icon=" "

mode_file="${XDG_CACHE_HOME:-${HOME}/.local/cache}/system-monitor-mode"

mode=$(cat "${mode_file}" 2>/dev/null)
[[ "${mode}" != "usage" ]] && mode="temp"

json=$(glances --stdout-json cpu,percpu,sensors \
  --disable-plugin all --enable-plugin cpu,percpu,sensors \
  --disable-check-update \
  -t 0.1 --stop-after 1 2>/dev/null)

cpu_use_average=$(jq -r '.cpu.total | round' <<< "${json}")

mapfile -t cpu_usages < <(jq -r '.percpu | sort_by(.cpu_number)[].total | round' <<< "${json}")

mapfile -t cpu_temps < <(jq -r '
  [.sensors[] | select(.label | test("^Core [0-9]+$"))]
  | sort_by(.label | capture("^Core (?<n>[0-9]+)$").n | tonumber)
  | .[].value
' <<< "${json}")

# Prefer the package-level sensor for the average; fall back to the mean of
# the per-core sensors, then to AMD's package sensor (Tctl), if a machine
# doesn't expose "Package id 0" (Intel-only label).
cpu_temp_average=$(jq -r '
  ([.sensors[] | select(.label == "Package id 0")] | .[0].value) //
  ([.sensors[] | select(.label | test("^Core [0-9]+$")) | .value] | if length > 0 then (add / length) else null end) //
  ([.sensors[] | select(.label == "Tctl")] | .[0].value)
  // 0
  | (. + 0.5 | floor)
' <<< "${json}")

# Machines without per-core temp sensors (e.g. AMD, no coretemp-style
# "Core N" labels) get the package-level average repeated for every core.
if [ "${#cpu_temps[@]}" -eq 0 ]; then
  for ((i=0; i<${#cpu_usages[@]}; i++)); do
    cpu_temps+=("${cpu_temp_average}")
  done
fi

# Determine the number of cores to display (minimum of usage and temp arrays)
num_cores_usage=${#cpu_usages[@]}
num_cores_temps=${#cpu_temps[@]}
num_cores=$((num_cores_usage < num_cores_temps ? num_cores_usage : num_cores_temps))

# Build per-core tooltip lines for the active mode
tooltip_lines=()
for ((i=0; i<num_cores; i++)); do
  core_num=$((i))

  if [[ "${mode}" == "temp" ]]; then
    temp=${cpu_temps[i]}

    # Format temperature to remove decimal if it's a whole number
    temp_formatted=$(awk -v t="${temp}" 'BEGIN {
      if (t == int(t))
        printf "%.0f", t
      else
        printf "%.1f", t
    }')

    tooltip_lines+=("Core $(printf "%02d" ${core_num}):    $(printf "%2s" ${temp_formatted})°C")
  else
    usage=${cpu_usages[i]}

    tooltip_lines+=("Core $(printf "%02d" ${core_num}):    $(printf "%3d" ${usage})%")
  fi
done

# Add header
if [[ "${mode}" == "temp" ]]; then
  tooltip_header="CORE ##:     TEMP\n──────────────────\n"
else
  tooltip_header="CORE ##:     USE\n──────────────────\n"
fi
tooltip_lines="${tooltip_header}"${tooltip_lines}

# Temperature-based classes
if [ "${cpu_temp_average}" -ge "90" ]; then
  waybar_class="critical"
elif [ "${cpu_temp_average}" -ge "80" ]; then
  waybar_class="warning"
fi

# Final waybar text/tooltip (mode toggled via system-monitor.sh)
if [[ "${mode}" == "temp" ]]; then
  waybar_text="${cpu_icon} $(printf '%2s' ${cpu_temp_average})°C"
else
  waybar_text="${cpu_icon} $(printf '%2d' ${cpu_use_average})%"
fi

waybar_tooltip="<big>CPU</big> (click to toggle)\n\n"$(printf "%s\n" "${tooltip_lines[@]}" | sed ':a;N;$!ba;s/\n/\\n/g')
echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"

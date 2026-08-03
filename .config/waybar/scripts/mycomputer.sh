#!/usr/bin/env bash
# System info waybar module, sourced from glances.

mycomputer_icon=""

json=$(glances --stdout-json system,uptime,processcount,containers \
  --disable-plugin all --enable-plugin system,uptime,processcount,containers \
  --disable-check-update \
  -t 0.1 --stop-after 1 2>/dev/null)

hostname=$(jq -r '.system.hostname' <<< "${json}")
kernel_version=$(jq -r '.system.os_version' <<< "${json}")
distro_name=$(jq -r '.system.linux_distro' <<< "${json}")
uptime=$(jq -r '.uptime' <<< "${json}")
process_count=$(jq -r '.processcount.total' <<< "${json}")
container_count=$(jq -r '.containers | length' <<< "${json}")

# Final waybar text/tooltip (labels padded to a fixed width so values line up)
waybar_text="${mycomputer_icon}"
waybar_tooltip=$(printf "%-12s%s\n" \
  "Hostname:" "${hostname}" \
  "Distro:" "${distro_name}" \
  "Kernel:" "${kernel_version}" \
  "Uptime:" "${uptime}" \
  "Processes:" "${process_count}" \
  "Containers:" "${container_count}" \
  | sed ':a;N;$!ba;s/\n/\\n/g')
waybar_tooltip="<big>SYSTEM</big>\n\n${waybar_tooltip}"

echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\"}"

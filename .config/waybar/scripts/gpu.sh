#!/bin/bash

# gpu_waybar()
#
# This function will capture various GPU information for use in a waybar module
# Custom waybar modules requires input as JSON
function gpu_waybar()
{
  # No GPU, no waybar module
  nvidia-smi > /dev/null 2>&1
  [[ $? -ne 0 ]] && exit 1

  # General Information
  gpu_icon="󰨇"
  gpu_name="$(nvidia-smi --query-gpu=name --format=noheader,nounits)"
  gpu_driver_version="$(nvidia-smi --query-gpu=driver_version --format=noheader,nounits)"
  gpu_cuda_version=$(nvidia-smi --version | awk -F': ' '/CUDA Version/ {print $2}')

  # Power
  gpu_power_used="$(nvidia-smi --query-gpu=power.draw --format=noheader,nounits)"
  gpu_power_used=$(awk "BEGIN {printf \"%.1f\", ${gpu_power_used}}")
  gpu_power_total="$(nvidia-smi --query-gpu=power.max_limit --format=noheader,nounits)"
  gpu_power_total=$(awk "BEGIN {printf \"%.1f\", ${gpu_power_total}}")
  gpu_power_use_percent=$(awk "BEGIN {printf \"%.1f\", (${gpu_power_used} / ${gpu_power_total}) * 100}")

  # VRAM
  gpu_vram_total="$(nvidia-smi --query-gpu=memory.total --format=noheader,nounits)"
  gpu_vram_total=$(awk "BEGIN {printf \"%.1f\", ${gpu_vram_total} / 1024}")
  gpu_vram_used="$(nvidia-smi --query-gpu=memory.used --format=noheader,nounits)"
  gpu_vram_used=$(awk "BEGIN {printf \"%.1f\", ${gpu_vram_used} / 1024}")
  gpu_vram_use_percent="$(nvidia-smi --query-gpu=utilization.memory --format=noheader,nounits)"

  # Usage
  gpu_use_percent="$(nvidia-smi --query-gpu=utilization.gpu --format=noheader,nounits)"

  # Temperature
  gpu_temp="$(nvidia-smi --query-gpu=temperature.gpu --format=noheader,nounits)"

  # Tooltip formatting
  info_tooltip="Name:\t${gpu_name}\nDriver:\t${gpu_driver_version}\nCUDA:\t${gpu_cuda_version}"
  usage_tooltip="Usage:\t${gpu_use_percent}%"
  temperature_tooltip="Temp:\t${gpu_temp}°C"
  vram_tooltip="VRAM:\t${gpu_vram_used} GB / ${gpu_vram_total} GB  (${gpu_vram_use_percent}%)"
  power_tooltip="Power:\t${gpu_power_used} W / ${gpu_power_total} W  (${gpu_power_use_percent}%)"

  # Temperature-based classes
  if [ "${gpu_temp}" -ge "90" ]; then
    waybar_class="critical"
  elif [ "${gpu_temp}" -ge "80" ]; then
    waybar_class="warning"
  fi

  # Final waybar text/tooltip
  waybar_text="${gpu_icon}  $(printf '%2d' ${gpu_use_percent})% / $(printf '%2s' ${gpu_temp})°C"
  waybar_tooltip="<big>GPU</big>\n\n${info_tooltip}\n\n${usage_tooltip}\n${temperature_tooltip}\n${vram_tooltip}\n${power_tooltip}"

  echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"
}


# centered_nvidia_smi()
#
# This function will capture the output of the command "nvidia-smi" and print it horizontally and vertically centered.
function centered_nvidia_smi()
{
  # Capture nvidia-smi output into an array
  mapfile -t output < <(nvidia-smi | tail -n +2)

  local num_lines=${#output[@]}
  local top_padding=$(( (LINES - num_lines) / 2 ))

  # Print top padding (blank lines)
  for ((i=0; i<top_padding; i++)); do
    echo
  done

  # Print each line centered horizontally
  for line in "${output[@]}"; do
    printf "%*s\n" $(( (${#line} + COLUMNS) / 2 )) "$line"
  done
}


if [[ "${1}" == "waybar" ]]; then
  # Return waybar widget/tooltip JSON
  gpu_waybar
elif [[ "${1}" == "watch" ]]; then
  # Open a centered nvidia-smi window to monitor GPU
  export -f centered_nvidia_smi
  notify NORMAL "󰨇  Watching GPU..."
  TERMINAL --title "GPU" bash -c 'watch --no-title centered_nvidia_smi'
else
  echo "USAGE: gpu.sh [waybar,watch]"
  exit 1
fi

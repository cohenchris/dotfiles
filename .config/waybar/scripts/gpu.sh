#!/bin/bash

gpu_icon="󰨇"

# Name
gpu_name="$(nvidia-smi --query-gpu=name --format=noheader,nounits)"

# Driver version
gpu_driver_version="$(nvidia-smi --query-gpu=driver_version --format=noheader,nounits)"

# CUDA version
gpu_cuda_version=$(nvidia-smi --version | awk -F': ' '/CUDA Version/ {print $2}')


# Power
gpu_power_used="$(nvidia-smi --query-gpu=power.draw --format=noheader,nounits)"
gpu_power_total="$(nvidia-smi --query-gpu=power.max_limit --format=noheader,nounits)"
gpu_power_use_percent=$(awk "BEGIN {printf \"%.1f\", (${gpu_power_used} / ${gpu_power_total}) * 100}")


# VRAM
gpu_vram_total="$(nvidia-smi --query-gpu=memory.total --format=noheader,nounits)"
gpu_vram_total=$(awk "BEGIN {printf \"%.2f\", ${gpu_vram_total} / 1024}")
gpu_vram_used="$(nvidia-smi --query-gpu=memory.used --format=noheader,nounits)"
gpu_vram_used=$(awk "BEGIN {printf \"%.2f\", ${gpu_vram_used} / 1024}")
gpu_vram_use_percent="$(nvidia-smi --query-gpu=utilization.memory --format=noheader,nounits)"

# GPU Usage
gpu_use_percent="$(nvidia-smi --query-gpu=utilization.gpu --format=noheader,nounits)"

# Temperature
gpu_temp="$(nvidia-smi --query-gpu=temperature.gpu --format=noheader,nounits)"


# Tooltip formatting
info_tooltip="Name:\t${gpu_name}\nDriver:\t${gpu_driver_version}\nCUDA:\t${gpu_cuda_version}"
usage_tooltip="Usage:\t${gpu_use_percent}%"
temperature_tooltip="Temp:\t${gpu_temp}°C"
vram_tooltip="VRAM:\t${gpu_vram_used} GB / ${gpu_vram_total} GB  (${gpu_vram_use_percent}%)"
power_tooltip="Power:\t${gpu_power_used} W / ${gpu_power_total} W  (${gpu_power_use_percent}%)"


# Final waybar text/tooltip
waybar_text="${gpu_icon} $(printf '%3d' ${gpu_use_percent})% / $(printf '%2s' ${gpu_temp})°C"
waybar_tooltip="<big>GPU</big>\n\n${info_tooltip}\n\n${usage_tooltip}\n${temperature_tooltip}\n${vram_tooltip}\n${power_tooltip}"

echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\"}"

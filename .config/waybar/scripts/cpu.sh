#!/usr/bin/env bash
# Function to get CPU usage per core
get_cpu_usage() {
  # Initialize the array
  cpu_usages=()
  
  # Read initial CPU stats
  local stats1=$(cat /proc/stat | grep "^cpu[0-9]")
  
  # Wait 1 second
  sleep 1
  
  # Read CPU stats again
  local stats2=$(cat /proc/stat | grep "^cpu[0-9]")
  
  # Convert to arrays
  local -a lines1
  local -a lines2
  readarray -t lines1 <<< "$stats1"
  readarray -t lines2 <<< "$stats2"
  
  # Process each CPU core
  for ((i=0; i<${#lines1[@]}; i++)); do
    # Parse first measurement
    read -a fields1 <<< "${lines1[i]}"
    local user1=${fields1[1]}
    local nice1=${fields1[2]}
    local system1=${fields1[3]}
    local idle1=${fields1[4]}
    local iowait1=${fields1[5]}
    local irq1=${fields1[6]}
    local softirq1=${fields1[7]}
    
    # Parse second measurement
    read -a fields2 <<< "${lines2[i]}"
    local user2=${fields2[1]}
    local nice2=${fields2[2]}
    local system2=${fields2[3]}
    local idle2=${fields2[4]}
    local iowait2=${fields2[5]}
    local irq2=${fields2[6]}
    local softirq2=${fields2[7]}
    
    # Calculate differences
    local user_diff=$((user2 - user1))
    local nice_diff=$((nice2 - nice1))
    local system_diff=$((system2 - system1))
    local idle_diff=$((idle2 - idle1))
    local iowait_diff=$((iowait2 - iowait1))
    local irq_diff=$((irq2 - irq1))
    local softirq_diff=$((softirq2 - softirq1))
    
    # Calculate total and active time
    local total_diff=$((user_diff + nice_diff + system_diff + idle_diff + iowait_diff + irq_diff + softirq_diff))
    local active_diff=$((total_diff - idle_diff))
    
    # Calculate usage percentage
    if [ $total_diff -gt 0 ]; then
      local usage=$((active_diff * 100 / total_diff))
    else
      local usage=0
    fi
    
    # Store in array
    cpu_usages+=($usage)
  done
}

# Function to get CPU temperatures per core
get_cpu_temps() {
  # CPU usage per core
  # Extract all "Core N:" lines and grab core ID and temperature
  mapfile -t cpu_temp_lines < <(sensors | awk '/^Core [0-9]+:/ {
    gsub(/[^0-9.+]/, " ")
    if (match($0, /([0-9]+) +\+([0-9.]+)/)) {
      core = substr($0, RSTART, RLENGTH)
      split(core, parts, /[^0-9.]+/)
      print parts[1] "\t" parts[2]
    }
  }')
  
  # Initialize tooltip and temperature array
  cpu_temps=()
  tooltip_lines=()
  cpu_temp_sum=0
  
  for line in "${cpu_temp_lines[@]}"; do
    core_id=$(awk '{print $1}' <<< "$line")
    temp=$(awk '{print $2}' <<< "$line")
    cpu_temps+=("$temp")
    cpu_temp_sum=$(awk -v a="${cpu_temp_sum}" -v b="${temp}" 'BEGIN {print a + b}')
  done
  
  cpu_temp_average=$(awk -v sum="${cpu_temp_sum}" -v count="${#cpu_temps[@]}" 'BEGIN {printf "%.1f", sum / count}')
  # Round value
  cpu_temp_average=$(awk "BEGIN {print int(${cpu_temp_average}+ 0.5)}")
}

# Function to calculate average CPU usage
calculate_cpu_average() {
  local total=0
  local count=${#cpu_usages[@]}
  
  for usage in "${cpu_usages[@]}"; do
    total=$((total + usage))
  done
  
  if [ $count -gt 0 ]; then
    cpu_use_average=$((total / count))
  else
    cpu_use_average=0
  fi
}

# Get CPU usage for all cores
get_cpu_usage

# Get CPU temperatures
get_cpu_temps

# Calculate CPU usage average
calculate_cpu_average

# Determine the number of cores to display (minimum of usage and temp arrays)
num_cores_usage=${#cpu_usages[@]}
num_cores_temps=${#cpu_temps[@]}
num_cores=$((num_cores_usage < num_cores_temps ? num_cores_usage : num_cores_temps))

# Build tooltip lines in the requested format
tooltip_lines=()
for ((i=0; i<num_cores; i++)); do
  core_num=$((i))
  usage=${cpu_usages[i]}
  temp=${cpu_temps[i]}
  
  # Format temperature to remove decimal if it's a whole number
  temp_formatted=$(awk -v t="${temp}" 'BEGIN {
    if (t == int(t)) 
      printf "%.0f", t
    else 
      printf "%.1f", t
  }')
  
  tooltip_lines+=("Core $(printf "%02d" ${core_num}):    $(printf "%3d" ${usage})% / $(printf "%2s" ${temp_formatted})°C")
done

# Add header
tooltip_lines="CORE ##:     USE \/ TEMP\n───────────────────────\n"${tooltip_lines}

# Temperature-based classes
if [ "${cpu_temp_average}" -ge "90" ]; then
  waybar_class="critical"
elif [ "${cpu_temp_average}" -ge "80" ]; then
  waybar_class="warning"
fi

cpu_icon=" "
# Final waybar text/tooltip
waybar_text="${cpu_icon} $(printf '%2d' ${cpu_use_average})% / $(printf '%2s' ${cpu_temp_average})°C"

waybar_tooltip="<big>CPU</big>\n\n"$(printf "%s\n" "${tooltip_lines[@]}" | sed ':a;N;$!ba;s/\n/\\n/g')
echo "{\"text\": \"${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\", \"class\": \"${waybar_class}\"}"

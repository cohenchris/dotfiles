#!/usr/bin/env bash

# Default screen temperature (no filter)
DEFAULT_TEMP=6000
# Preferred default orange intensity of the night light
PREFERRED_TEMP=2500
# Interval to increase the orange intensity of the night light
UP_INTERVAL=-500
# Interval to decrease the orange intensity of the night light
DOWN_INTERVAL=+500


# Invalid number of commands
if [[ $# -ne 1 ]]; then
  echo "Usage: night-light.sh [reset|default|up|down]"
  exit 1
fi


# Restart hyprsunset if not running
HYPRSUNSET_PID=$(ps -aux | grep hyprsunset | grep -v grep | awk '{print $2}') 
if [[ -z "${HYPRSUNSET_PID}" ]]; then
  echo "Hyprsunset is not running, starting an instance..."
  hyprsunset &
fi


# Handle command
cmd="$1"

if [[ "${cmd}" == "reset" ]]; then
  # Remove night light filter (default screen temperature)
  hyprctl hyprsunset temperature "${DEFAULT_TEMP}"

elif [[ "${cmd}" == "default" ]]; then
  # Preferred default night light temperature
  hyprctl hyprsunset temperature "${PREFERRED_TEMP}"

elif [[ "${cmd}" == "up" ]]; then
  # Increase night light orange intensity
  hyprctl hyprsunset temperature "${UP_INTERVAL}"

elif [[ "${cmd}" == "down" ]]; then
  # Decrease night light orange intensity
  hyprctl hyprsunset temperature "${DOWN_INTERVAL}"

else
  # Invalid command
  echo "Usage: night-light.sh [reset|default|up|down]"
  exit 1
fi

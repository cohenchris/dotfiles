#!/bin/bash

# Must be running in a graphical environment
if [ -z "${WAYLAND_DISPLAY}" ]; then
  exit
fi


speedtest_cachefile="${XDG_CACHE_HOME}/speedtest_results.txt"


function run_speedtest()
{
  results=$(speedtest-cli --simple)
  echo "${results}" > ${speedtest_cachefile}
}


if [[ "$1" == "refresh" ]]; then
  # Refresh the speedtest results
  run_speedtest

elif [[ "$1" == "print" ]]; then
  # If cached results file does not exist, run speedtest
  [[ ! -f "${speedtest_cachefile}" ]] && run_speedtest

  # Print speedtest results
  results=$(cat "${speedtest_cachefile}")

  # Extract download and upload speeds using grep and sed
  download=$(echo "${results}" | grep '^Download:' | awk '{print int($2)}')
  upload=$(echo "${results}" | grep '^Upload:' | awk '{print int($2)}')

  if [[ -z ${upload} || -z ${download} ]]; then
    upload="?"
    download="?"
  fi

  echo "󰇚 ${download} Mb/s / 󰕒 ${upload} Mb/s"

else
  # Invalid argument passed
  echo "Usage: speedtest.sh [refresh,print]"
  exit
fi


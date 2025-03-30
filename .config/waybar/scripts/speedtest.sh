#!/bin/bash

speedtest_cachefile="${XDG_CACHE_HOME}/speedtest_results.txt"

if [[ "$1" == "refresh" || ! -f "${speedtest_cachefile}" ]]; then
  # If there is no cache file OR the user has explicitly asked to refresh the results, perform a speedtest
  results=$(speedtest-cli --simple)
  echo "${results}" > ${speedtest_cachefile}
else
  # Use cached results
  results=$(cat "${speedtest_cachefile}")
fi

# Extract download and upload speeds using grep and sed
download=$(echo "${results}" | grep '^Download:' | awk '{print int($2)}')
upload=$(echo "${results}" | grep '^Upload:' | awk '{print int($2)}')

if [[ -z ${upload} || -z ${download} ]]; then
  upload="?"
  download="?"
fi

echo "󰇚 ${download} Mb/s / 󰕒 ${upload} Mb/s"

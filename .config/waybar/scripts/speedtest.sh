#!/bin/bash

results=$(speedtest-cli --simple)

# Extract download and upload speeds using grep and sed
download=$(echo "$results" | grep '^Download:' | awk '{print int($2)}')
upload=$(echo "$results" | grep '^Upload:' | awk '{print int($2)}')

if [[ -z ${upload} || -z ${download} ]]; then
  upload="?"
  download="?"
fi

echo "󰕒 ${upload} Mb/s / 󰇚 ${download} Mb/s"

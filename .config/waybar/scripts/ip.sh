#!/usr/bin/env bash

mode_file="${XDG_CACHE_HOME:-${HOME}/.local/cache}/ip_mode"

if [[ "$1" == "toggle" ]]; then
  mode=$(cat "${mode_file}" 2>/dev/null)

  if [[ "${mode}" == "internal" ]]; then
    echo "external" > "${mode_file}"
  else
    echo "internal" > "${mode_file}"
  fi

  # Ask waybar to re-run this module immediately instead of waiting for the next interval
  pkill -RTMIN+8 waybar

  exit 0
fi

mode=$(cat "${mode_file}" 2>/dev/null)
[[ "${mode}" != "internal" ]] && mode="external"

if [[ "${mode}" == "internal" ]]; then
  # Get internal IP address (assuming you want to display the first non-loopback interface)
  internal_ip=$(hostname -i | awk '{print $1}')

  if [[ "${internal_ip}" == "" ]]; then
    internal_ip="?"
  fi

  echo "  ${internal_ip}"
else
  # Get external IP address using curl
  external_ip=$(dig +short txt ch whoami.cloudflare @1.0.0.1)

  # Handle external IP dig failure gracefully
  [[ $? -ne 0 ]] && external_ip="?"

  # Remove quotes from external IP string
  external_ip=${external_ip//\"/}

  echo "  ${external_ip}"
fi

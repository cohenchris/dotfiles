#!/bin/bash

# Get external IP address using curl
external_ip=$(wget -4 -qO - https://icanhazip.com)

if [[ "${external_ip}" == "" ]]; then
  external_ip="?"
fi

# Get internal IP addresses (assuming you want to display the first non-loopback interface)
internal_ip=$(hostname -i | awk '{print $1}')

if [[ "${internal_ip}" == "" ]]; then
  internal_ip="?"
fi

# Format and print
echo "  ${external_ip} /   ${internal_ip}"

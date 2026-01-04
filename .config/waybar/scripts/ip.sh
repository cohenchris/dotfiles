#!/bin/bash

# Get external IP address using curl
external_ip=$(dig +short txt ch whoami.cloudflare @1.0.0.1)

# Remove quotes from external IP string
external_ip=${external_ip//\"/}

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

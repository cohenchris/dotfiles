#!/bin/bash

# Get external IP address using curl
external_ip=$(wget -4 -qO - http://icanhazip.com)

# Get internal IP addresses (assuming you want to display the first non-loopback interface)
internal_ip=$(hostname -i | awk '{print $1}')

# Format and print
echo "󱂇  ${external_ip} / 󰦉  ${internal_ip}"

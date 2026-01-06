#!/bin/bash

# Based on https://github.com/HarHarLinks/wireguard-rofi-waybar/tree/main

connection_name=""
connection_ip=""

# Check for an active Wireguard VPN connection
while read -r name uuid type device
do
  if [[ "${type}" == "wireguard" ]]
  then
    while read -r key value
    do
      if [[ "${key}" == "ipv4.addresses:" ]]; then
        connection_name="${name}"
        connection_ip="${value}"
      fi
    done < <(nmcli connection show "${name}")
  fi
done < <(nmcli connection show)

# Print connection info in JSON format for waybar
waybar_text=""
waybar_tooltip=""

if [[ "${connection_name}" == "" ]]; then
#  connection_icon=" 󱦚 "
  connection_icon=" "
  connection_status="Disconnected"
  connection_tooltip_status="<span color='#c84b4b'>${connection_status}</span>"
  connection_name="N/A"
  connection_ip="N/A"
else
#  connection_icon=" 󰦝 "
  connection_icon=""
  connection_status="Connected"
  connection_tooltip_status="<span color='#00c000'>${connection_status}</span>"
fi

waybar_text="${connection_icon}"
waybar_tooltip="<big>Wireguard VPN ${connection_tooltip_status}</big>\n\nConnection Name:\t${connection_name}\nIP Address:\t${connection_ip}"

echo "{\"text\": \"${waybar_icon}${waybar_text}\", \"tooltip\": \"${waybar_tooltip}\"}"

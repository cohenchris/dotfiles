#!/bin/bash

# Based on https://github.com/HarHarLinks/wireguard-rofi-waybar/tree/main

# nmcli WireGuard abstraction layer for use with my waybar module and rofi custom menu script
#
# requires nmcli on your path
# install to the same directory as wireguard-rofi.sh
#
# usage: ./wireguard.sh [short|menu|toggle NAME]
# no argument:   print current connections
# toggle NAME:   toggle connection NAME

connected=()
available=()

function get_conns {
	while read -r name uuid type device
	do
		if [[ $type != "wireguard" ]]
		then
			continue
		fi

		if [[ $device != "--" ]]
		then
			while read -r key value
			do
				if [[ $key != "ipv4.addresses:" ]]
				then
					continue
				fi
				connected+=("$name: $value")
			done < <(nmcli connection show $name)
		else
			available+=("$name")
		fi
  done < <(nmcli connection show)
}

function get_vpn_info {
	local first="yes"
	local array_print="$1[@]"
	local array_print=("${!array_print}")
	local text=""
	local tooltip=""
	if [ "${#array_print[@]}" -le 0 ]
	then
		return
	fi

  for c in "${array_print[@]}"
  do
    if [[ "$first" != "yes" ]]
    then
        text="$text | "
        tooltip="$tooltip\n"
    fi
    if [[ "$2" == "short" ]]
    then
      text="$text$(echo -n $c | sed -E 's/^(.+): ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]+)$/\1/')"
    else
      text="$text$c"
    fi
    tooltip="$tooltip$c"
    first="no"
  done
  echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\"}"
}

function array_contains {
	local array_has="$1[@]"
	local array_has=("${!array_has}")
	local element="$2"
	for e in "${array_has[@]}"
	do
		if [[ "$e" == *"$element"* ]]
		then
			echo "yes"
			return
		fi
	done
	echo "no"
}

function toggle_vpn_connection()
{
	get_conns

	if [[ "$(array_contains connected $conn)" == "yes" ]]
	then
		nmcli connection down "$conn"
	elif [[ "$(array_contains available $conn)" == "yes" ]]
	then
		nmcli connection up "$conn"
	else
		echo "err: connection not found"
		exit 1
	fi
}

# Parse and handle arguments
if [ "$1" == "info" ]; then
  get_vpn_info connected
elif [ "$1" == "toggle" ]; then
  toggle_vpn_connection "$2"
else
  echo "Invalid argument - choose one of [info, toggle]."
  exit 1
fi

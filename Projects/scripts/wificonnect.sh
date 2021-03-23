#!/bin/bash

nmcli device wifi list

read -p "Which network to connect? "
network=$REPLY

read -sp "Password for $network: "
pass=$REPLY

echo
nmcli device wifi connect "$network" password "$pass"

unset pass network

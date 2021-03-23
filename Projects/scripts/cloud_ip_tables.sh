#!/bin/sh
ip rule add from 192.168.1.99 table 128
ip route add table 128 to 192.168.1.0/24 dev wlp2s0
ip route add table 128 default via 192.168.1.1

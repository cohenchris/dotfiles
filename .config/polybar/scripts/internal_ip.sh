#!/bin/sh

local_ip=$(hostname -i | awk '{print $1}')

echo "  /  $local_ip    "

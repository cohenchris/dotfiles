#!/bin/bash

status=$(mullvad status | cut -d " " -f 1)
if [ $status == "Connected" ]; then
  echo "  "
else
  echo " "
fi

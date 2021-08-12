#!/bin/bash

status=$(mullvad status | cut -d " " -f 3)
if [ $status == "Connected" ]; then
  echo "  "
else
  echo " "
fi

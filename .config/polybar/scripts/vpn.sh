#!/bin/bash

status=$(piactl get connectionstate)
if [ $status == "Connected" ]; then
  echo "  "
else
  echo " "
fi

#!/usr/bin/env bash

rfkill --output TYPE,SOFT | grep wlan
has_wlan=$?

if [[ "${has_wlan}" -eq 1 ]]; then
  # No WLAN device, continue
  notify CRITICAL "󰀝  No WLAN device found" "Cannot toggle airplane mode"
  exit 1
fi

rfkill --output TYPE,SOFT | grep wlan | grep unblocked
is_unblocked=$?

if [[ "${is_unblocked}" -eq 0 ]]; then
  notify GOOD "󰀝  Airplane mode disabled" "Network connectivity restored"
else
  notify CRITICAL "󰀝  Airplane mode enabled" "Network connectivity killed"
fi

rfkill toggle wlan

#!/usr/bin/env bash


rfkill list | grep -q "Soft blocked: no"
is_blocked=$?

if [[ "${is_blocked}" -eq 0 ]]; then
  notify CRITICAL "󰀝  Airplane mode enabled" "Network connectivity killed"
  rfkill block all
else
  notify GOOD "󰀝  Airplane mode disabled" "Network connectivity restored"
  rfkill unblock all
fi

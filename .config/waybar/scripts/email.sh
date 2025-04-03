#!/bin/bash

unread_messages_count=$(notmuch search 'tag:unread' | wc -l)

if [[ "${unread_messages_count}" -eq 0 ]]; then
  email_icon="󰪱"
else
  email_icon="󰛏"
fi

printf "%s  %03s unread messages" "${email_icon}" "${unread_messages_count}"

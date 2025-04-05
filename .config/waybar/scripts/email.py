#!/usr/bin/env python

import subprocess
import datetime
import json
from html import escape
from datetime import datetime

waybar_json_data = {}

unread_messages_count = subprocess.check_output("notmuch search 'tag:unread' | wc -l", shell=True).decode("utf-8").strip()

if unread_messages_count == 0:
  email_icon = "󰪱"
else:
  email_icon = "󰛏"

waybar_json_data['text'] = f"{email_icon}  {unread_messages_count} unread messages"

email_preview_output = subprocess.check_output("notmuch search --format=json 'tag:unread'", shell=True). decode("utf-8").strip()

email_preview_json = json.loads(email_preview_output)

tooltip_text = ""

# Parse email data to construct a tooltip
for i, entry in enumerate(email_preview_json):
  # Only display up to 10 messages
  if i == 10:
    break

  formatted_entry = ""

  # Parse sender
  sender = entry["authors"]

  # Parse and convert date and time received
  received_at = entry["date_relative"]
  received_date = received_at.split()[0]
  received_time = received_at.split()[1]
  dt = datetime.strptime(received_time, "%H:%M")
  received_time = dt.strftime("%I:%M %p")

  # Parse subject
  subject = entry["subject"]
  
  # Format received data into something nicer to read
  formatted_entry += f"<span color='#c84b4b'><b>  {sender}</b></span>\n"
  formatted_entry += f"<span color='#ffcc66'>󰛮  {received_date} at {received_time}</span>\n"
  formatted_entry += f"<span color='#ffffff'>󰇮  {subject}</span>\n\n"
  tooltip_text += formatted_entry

waybar_json_data['tooltip'] = tooltip_text.strip()

print(json.dumps(waybar_json_data))

#!/usr/bin/env python3

import subprocess
import datetime
import json
import html
from datetime import datetime

waybar_json_data = {}

unread_messages_count = subprocess.check_output("notmuch search 'tag:unread' | wc -l", shell=True).decode("utf-8").strip()

if unread_messages_count == "0":
  email_icon = "󰪱"
  email_text = "No Messages"
else:
  email_icon = "󰛏"
  email_text = f"{unread_messages_count} New"

waybar_json_data['text'] = f"{email_icon}  {email_text}"

email_preview_output = subprocess.check_output("notmuch search --format=json 'tag:unread'", shell=True). decode("utf-8").strip()

email_preview_json = json.loads(email_preview_output)

tooltip_text = ""

# Parse email data to construct a tooltip
for i, entry in enumerate(email_preview_json):
  # Only display up to 10 messages
  if i == 10:
    break

  formatted_entry = ""

  # Sender
  email_id = entry["query"][0]
  sender = subprocess.check_output(f"notmuch address {email_id}", shell=True).decode("utf-8").strip()

  # Parse and convert email receipt date/time
  try:
      received_at = entry["date_relative"]
      received_date = received_at.split()[0]
      received_time = received_at.split()[1]
      dt = datetime.strptime(received_time, "%H:%M")
      received_time = dt.strftime("%I:%M %p")
      receipt = f"{received_date} at {received_time}"
  except:
      receipt = entry["date_relative"]

  # Parse subject
  subject = entry["subject"] if entry["subject"] else "*No Subject*"

  # Escape special HTML characters to properly encode text
  sender = html.escape(sender)
  receipt = html.escape(receipt)
  subject = html.escape(subject)
  
  # Format received data into something nicer to read
  formatted_entry += f"<span color='#c84b4b'><b>  {sender}</b></span>\n"
  formatted_entry += f"<span color='#ffcc66'>󰛮  {receipt}</span>\n"
  formatted_entry += f"<span color='#ffffff'>󰇮  {subject}</span>\n\n"
  tooltip_text += formatted_entry

if email_preview_json == []:
  tooltip_text += f"Inbox is empty!"

waybar_json_data['tooltip'] = tooltip_text.strip()

print(json.dumps(waybar_json_data))

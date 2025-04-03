#!/usr/bin/env python

import subprocess
import datetime
import json
from html import escape

# Day-of-week labels that is part of what khal prints out for its headers
dow_headers = ["Today,", "Tomorrow,", "Sunday,", "Monday,", "Tuesday,", "Wednesday,", "Thursday,", "Friday,", "Saturday,"]

waybar_json_data = {}

# Taskbar text should display the time
time_now = datetime.datetime.now().strftime("%I:%M %p")
waybar_json_data['text'] = f"󰥔  {time_now}"

# Tooltip text should display 1 week's worth of appointments
today = datetime.date.today().strftime("%m/%d/%Y")

khal_command="khal list --format '{start-time} - {title}' " + today + " 7d"
khal_output = subprocess.check_output(khal_command, shell=True).decode("utf-8")

tooltip_text = []

# Iterate through each line in the command output to clean/format it
for line in khal_output.split("\n"):
  formatted_line = ""

  split_line = line.split("-")
  
  if len(split_line) == 0 or split_line[0] == "":
    # Blank line, do nothing
    pass
  elif len(split_line) == 1:
    # Found day-of-week header, make it larger and red
    line = line.replace(",", "")
    formatted_line = f"\n<span color='#c84b4b'><b>{line}</b></span>"
  elif split_line[0] == " ":
    # Found an all-day event
    # All-day events don't have a starting time, so the beginning of the line will be " -"
    # Clean this up by adding "All Day" where the time would normally be
    formatted_line = f"<span color='#ffcc66'>All Day\t</span> {split_line[1]}"
  else:
    # Normal line, append with no change
    time = split_line[0]
    event = split_line[1]
    formatted_line = f"<span color='#ffcc66'>{time}</span> {event}"
  
  tooltip_text.append(formatted_line)

waybar_json_data['tooltip'] = "\n".join(tooltip_text).strip()

print(json.dumps(waybar_json_data))

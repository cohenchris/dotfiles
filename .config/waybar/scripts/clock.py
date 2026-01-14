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

khal_command="khal list --format '{start-time} - {title} - {location}' " + today + " 4d"
khal_output = subprocess.check_output(khal_command, shell=True).decode("utf-8")

tooltip_text = []

# Iterate through each line in the command output to clean/format it
for line in khal_output.split("\n"):
  formatted_line = ""

  split_line = line.split("-")

  if len(split_line) == 1:
    if any(dow in line for dow in dow_headers):
      # Found day-of-week header, make it larger and red
      split_line = line.split(',')
      line = split_line[0].ljust(11, ' ') + split_line[1]
      formatted_line = f"\n<span color='#c84b4b'><b> {line}</b></span>"
    else:
     # Location data extended across lines, exclude this extra data
     continue
  else:
    parsed_event_time = split_line[0] if len(split_line) >= 1 else ""
    parsed_event_name = split_line[1] if len(split_line) >= 2 else ""
    parsed_event_location = split_line[2] if len(split_line) >= 3 else ""

    # Found an all-day event
    # All-day events don't have a starting time, so the beginning of the line will be " -"
    # Clean this up by adding "All Day" where the time would normally be

    # Time string
    if not parsed_event_time.strip():
      display_event_time = f"<span color='#ffcc66'>󰔠 All Day</span>    "
    else:
      display_event_time = f"<span color='#ffcc66'>󰔠 {parsed_event_time}</span>  "

    # Event string
    if not parsed_event_name.strip():
      display_event_name = "<No Event Name>"
    else:
      display_event_name = parsed_event_name.strip()

    # Location string
    if not parsed_event_location.strip():
      display_event_location = ""
    else:
      display_event_location = f"\n              <span color='turquoise'>{parsed_event_location}</span>"

    formatted_line = f"{display_event_time}{display_event_name}{display_event_location}"

  tooltip_text.append(formatted_line)

waybar_json_data['tooltip'] = "\n".join(tooltip_text).strip()

print(json.dumps(waybar_json_data))

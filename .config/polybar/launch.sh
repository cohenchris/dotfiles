#!/bin/bash

res=$(xrandr | grep 'Screen 0' | cut -d , -f 2 | cut -d ' ' -f 5)

if [ $res -gt 1080 ]; then
  # 1440p
  export BAR_HEIGHT=30
  export TERMINUS="Terminus (TTF):size=14:style=Bold;3"
else
  # Not 1440p
  export BAR_HEIGHT=25
  export TERMINUS="Terminus (TTF):size=12:style=Bold;0"
fi

# Background color (ARGB)
export BACKGROUND_COLOR=#55000000

# Network Interfaces
export ETH=$(ip -o addr show up scope global | grep enp | awk '{print $2}')
export WLAN=$(ip -o addr show up scope global | grep wlan | awk '{print $2}')

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar top &
polybar bottom &

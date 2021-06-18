#!/bin/bash

res=$(xrandr | grep 'Screen 0' | cut -d , -f 2 | cut -d ' ' -f 5)
if [ $res -le 1080 ]; then
  HIDPI=0
else
  HIDPI=1;
fi

# Change settings based on whether or not the screen is HIDPI 4k
if [ $HIDPI -eq 1 ]; then
  # HIDPI
  export BAR_HEIGHT=65
  export UNIFONT="Unifont:size=20:style=Bold;0"
  export FONTAWESOME="FontAwesome:size=30:style=Bold;0"
  export TERMINUS="Terminus:size=30:style=Bold;0"
  export MATERIALICONS="MaterialIcons:size=30:style=Bold;0"
  export TOP_LEFT="i3 xwindow"
  export TOP_CENTER=" "
else
  # Normal
  export BAR_HEIGHT=33
  export UNIFONT="Unifont:size=10:style=Bold;0"
  export FONTAWESOME="FontAwesome:size=15:style=Bold;0"
  export TERMINUS="Terminus:size=15:style=Bold;0"
  export MATERIALICONS="MaterialIcons:size=15:style=Bold;0"
  export TOP_LEFT="i3"
  export TOP_CENTER="xwindow"
fi

# Background color (ARGB)
export BACKGROUND_COLOR=#55000000

# Network Interfaces
export ETH=$(ifconfig | grep enp | cut -d : -f 1)
export WLAN=$(ifconfig | grep wlp | cut -d : -f 1)

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar top &
polybar bottom &

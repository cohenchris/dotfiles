#!/bin/bash

cd ~/.config/wallpapers

WALLPAPER=$(find -type f | shuf -n 1)

xwallpaper --focus "${WALLPAPER}"

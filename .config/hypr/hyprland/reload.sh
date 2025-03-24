#!/bin/bash

pkill waybar
hyprctl dispatch exec waybar
hyprctl reload

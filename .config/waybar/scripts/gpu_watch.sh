#!/bin/bash
columns="$(tput cols)"
nvidia-smi | while read i; do
   printf "%*s\n" $(( (${#i} + columns) / 2)) "$i"
done


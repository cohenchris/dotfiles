# add custom scripts/backup scripts to PATH
PATH=$PATH:/home/chris/.local/backup:/home/chris/.local/bin

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start x server
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

#
# ~/.bash_profile
#

PATH=$PATH:/home/chris/.config/backup:/home/chris/.config/bin

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx


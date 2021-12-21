# add custom scripts/backup scripts to PATH
PATH=$PATH:/home/chris/.local/backup:/home/chris/.local/bin

# Defaults
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="firefox"

# Clean up ~
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export NOTMUCH_CONFIG="{$XDG_CONFIG_HOME:-$HOME/.config}/notmuch.conf"
export PASSWORD_STORE_DIR=~/.config/password-store
export LESSHISTFILE=/dev/null
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export MBSYNCRC="${XDG_CONFIG_HOME:-$HOME/.config}/mbsync.conf"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# Source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start x server
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# Autorandr
autorandr -c

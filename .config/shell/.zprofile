# add custom scripts/backup scripts to PATH
PATH=$PATH:/home/phrog/.local/backup:/home/phrog/.local/bin/personal:/home/phrog/.local/bin

# Defaults
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="google-chrome-stable"
export SHELL="zsh"

# Clean up ~
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/pythonrc"

export XAUTHORITY="${XDG_RUNTIME_DIR:-/run/user/1000}/Xauthority" # This line will break some DMs.
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch/config"
export PASSWORD_STORE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/password-store"
export LESSHISTFILE=/dev/null
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export MBSYNCRC="${XDG_CONFIG_HOME:-$HOME/.config}/isync/mbsyncrc"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export DOCKER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/docker"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/nv"
export VSCODE_PORTABLE="${XDG_DATA_HOME:-$HOME/.local/share}/vscode"

# Source zshrc
[[ -f ~/.config/shell/.zshrc ]] && . ~/.config/shell/.zshrc

# Start x server
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx /usr/bin/i3

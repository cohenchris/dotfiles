# add custom scripts/backup scripts to PATH
declare -a paths=(
  "$HOME/.local/backup"
  "$HOME/.local/bin/personal"
  "$HOME/.local/bin"
)
CUSTOM_PATHS=$(IFS=:; echo "${paths[*]}")
export PATH="$CUSTOM_PATHS:$PATH"

# Default programs
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="brave"
export SHELL="zsh"

# Clean up ~
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOAD_HOME="$HOME/Downloads"
export XDG_RUNTIME_HOME="/run/user/1000"

export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
#export XAUTHORITY="${XDG_RUNTIME_HOME}/Xauthority"
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME}/notmuch/config"
export PASSWORD_STORE_DIR="${XDG_CONFIG_HOME}/password-store"
export LESSHISTFILE=/dev/null
export HISTFILE="${XDG_DATA_HOME}/history"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME}/android"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export MBSYNCRC="${XDG_CONFIG_HOME}/isync/mbsyncrc"
export GOPATH="${XDG_DATA_HOME}/go"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export VSCODE_PORTABLE="${XDG_DATA_HOME}/vscode"

# Source zshrc
[[ -f ~/.config/shell/.zshrc ]] && . ~/.config/shell/.zshrc

# Start x server
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx /usr/bin/i3

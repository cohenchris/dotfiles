# Define custom PATH
declare -a paths=(
  "${HOME}/.local/backup"
  "${HOME}/scripts/bin"
  "${HOME}/scripts/system"
  "${HOME}/.local/bin"
)
CUSTOM_PATHS=$(IFS=:; echo "${paths[*]}")
export PATH="${CUSTOM_PATHS}:${PATH}"

# Default programs
export EDITOR="nvim"
export TERMINAL="foot"
export BROWSER="zen-browser"
export SHELL="zsh"
export LAUNCHER="fuzzel"
export FILE_BROWSER="${TERMINAL} lf"
export SCREENSHOT="grim -g $(slurp)"
export TASK_MANAGER="${TERMINAL} glances"
export MAIL_CLIENT="${TERMINAL} neomutt"
export SCREEN_LOCKER="hyprlock"
export BLUETOOTH_DEVICE_SELECTOR="dmenu-bluetooth"
export DMENU_BLUETOOTH_LAUNCHER="${LAUNCHER}"
export WIFI_SELECTOR="wifi-selector"
export PDF_VIEWER="zathura"
export IMAGE_VIEWER="imv"

# Clean up ~

# User-specific config files
export XDG_CONFIG_HOME="${HOME}/.config"
# User-specific non-essential (cached) data
export XDG_CACHE_HOME="${HOME}/.cache"
# User-specific data files
export XDG_DATA_HOME="${HOME}/.local/share"

# Configs
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME}/notmuch/config"
export PASSWORD_STORE_DIR="${XDG_CONFIG_HOME}/password-store"
export MBSYNCRC="${XDG_CONFIG_HOME}/isync/mbsyncrc"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"

# Cache
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export LESSHISTFILE="${XDG_CACHE_HOME}/less_history"

# Data
export MAILDIR="${XDG_DATA_HOME}/mail"
export NOTMUCH_DATABASE="${MAILDIR}"
export HISTFILE="${XDG_DATA_HOME}/history"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GOPATH="${XDG_DATA_HOME}/go"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export VSCODE_PORTABLE="${XDG_DATA_HOME}/vscode"


# Source zshrc
[[ -f ~/.config/shell/.zshrc ]] && . ~/.config/shell/.zshrc

# Start hyprland WM
[[ -z ${WAYLAND_DISPLAY} && ${XDG_VTNR} -eq 1 ]] && exec /usr/bin/hyprland

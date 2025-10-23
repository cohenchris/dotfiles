#####################################################################################
#                               CLEAN UP ~                                          #
#####################################################################################
                                                                                    #
# https://wiki.archlinux.org/title/XDG_Base_Directory                               #
export XDG_CONFIG_HOME="${HOME}/.config"                                            # config files
export XDG_CACHE_HOME="${HOME}/.local/cache"                                        # cached data
export XDG_DATA_HOME="${HOME}/.local/share"                                         # application data
export TRASH_DIR="${HOME}/.local/trash"                                             # trash
                                                                                    #
# CONFIGS                                                                           #
export PASSWORD_STORE_DIR="${XDG_CONFIG_HOME}/password-store"                       # pass
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"                                    # docker
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"                                      # wget
export MBSYNC_CONFIG="${XDG_CONFIG_HOME}/mail/mbsyncrc"                             # email remote sync
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME}/mail/notmuch.conf"                        # email indexing
export NEOMUTT_CONFIG="${XDG_CONFIG_HOME}/mail/neomutt/neomuttrc"                   # neomutt email client
                                                                                    #
# CACHE                                                                             #
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"                                       # cuda nv cache
export LESSHISTFILE="${XDG_CACHE_HOME}/less_history"                                # less command history
export HISTFILE="${XDG_DATA_HOME}/history"                                          # shell command history
export PYTHON_HISTORY="${XDG_CACHE_HOME}/python_history"                            # python command history
                                                                                    #
# DATA                                                                              #
export MAILDIR="${XDG_DATA_HOME}/mail"                                              # email data
export NOTMUCH_DATABASE="${MAILDIR}"                                                # notmuch database
export CARGO_HOME="${XDG_DATA_HOME}/cargo"                                          # cargo files
export GOPATH="${XDG_DATA_HOME}/go"                                                 # go files
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"                                           # GPG data
                                                                                    #
#####################################################################################
#                            DEFAULT PROGRAMS                                       #
#####################################################################################
                                                                                    #
export EDITOR="nvim"                                                                # text editor 
export DMENU_BLUETOOTH_LAUNCHER="fuzzel"                                            # use fuzzel instead of dmenu for dmenu-bluetooth

export TERMINAL="foot"                                                              # terminal emulator
export BROWSER="zen-browser"                                                        # web browser
export SHELL="zsh"                                                                  # terminal shell
export LAUNCHER="fuzzel"                                                            # application launcher
export CALENDAR="eval ${TERMINAL} --title \"Calendar\" khal interactive"            # calendar
export PDF_VIEWER="zathura"                                                         # pdf viewer
export IMAGE_VIEWER="swayimg"                                                       # image viewer
export FILE_BROWSER="eval ${TERMINAL} --title \"File Browser\" lf-wrapper"          # file browser
export TASK_MANAGER="${TERMINAL} glances"                                           # task manager
export BLUETOOTH_MENU="dmenu-bluetooth"                                             # bluetooth device selection menu
export WIFI_MENU="wifi-menu"                                                        # wifi selection menu
export VPN_MENU="vpn-menu"                                                          # VPN selection menu
export MAIL_CLIENT="${TERMINAL} neomutt -F ${NEOMUTT_CONFIG}"                       # email client
export AUDIO_MANAGER="pavucontrol"                                                  # audio management
                                                                                    #
#####################################################################################

# Define custom PATH
declare -a paths=(
  "${HOME}/.local/backup"
  "${HOME}/scripts/bin"
  "${HOME}/scripts/system"
  "${HOME}/.local/bin"
)
CUSTOM_PATHS=$(IFS=:; echo "${paths[*]}")
export PATH="${CUSTOM_PATHS}:${PATH}"

# Source ZSH config file
[[ -f "${XDG_CONFIG_HOME}/shell/.zshrc" ]] && . "${XDG_CONFIG_HOME}/shell/.zshrc"

# Start hyprland WM
[[ -z "${WAYLAND_DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && exec /usr/bin/hyprland

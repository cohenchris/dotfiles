#############################################################################
#                               CLEAN UP ~                                  #
#############################################################################
                                                                            #
# https://wiki.archlinux.org/title/XDG_Base_Directory                       #
export XDG_CONFIG_HOME="${HOME}/.config"                                    # config files
export XDG_CACHE_HOME="${HOME}/.cache"                                      # cached data
export XDG_DATA_HOME="${HOME}/.local/share"                                 # application data
                                                                            #
# CONFIGS                                                                   #
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"                   # python
export PASSWORD_STORE_DIR="${XDG_CONFIG_HOME}/password-store"               # pass
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"                            # docker
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"                              # wget
export MBSYNC_CONFIG="${XDG_CONFIG_HOME}/mail/mbsyncrc"                     # email remote sync
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME}/mail/notmuch.conf"                # email indexing
export NEOMUTT_CONFIG="${XDG_CONFIG_HOME}/mail/neomutt/neomuttrc"           # neomutt email client
                                                                            #
# CACHE                                                                     #
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"                               # cuda nv cache
export LESSHISTFILE="${XDG_CACHE_HOME}/less_history"                        # less command history
export HISTFILE="${XDG_DATA_HOME}/history"                                  # shell history
                                                                            #
# DATA                                                                      #
export MAILDIR="${XDG_DATA_HOME}/mail"                                      # email data
export NOTMUCH_DATABASE="${MAILDIR}"                                        # notmuch database
export CARGO_HOME="${XDG_DATA_HOME}/cargo"                                  # cargo files
export GOPATH="${XDG_DATA_HOME}/go"                                         # go files
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"                                   # GPG data
                                                                            #
#############################################################################
#                            DEFAULT PROGRAMS                               #
#############################################################################
                                                                            #
export EDITOR="nvim"                                                        # text editor 
export TERMINAL="foot"                                                      # terminal emulator
export BROWSER="zen-browser"                                                # web browser
export SHELL="zsh"                                                          # terminal shell
export LAUNCHER="fuzzel"                                                    # application launcher
export CALENDAR="khal"                                                      # calendar
export PDF_VIEWER="zathura"                                                 # pdf viewer
export IMAGE_VIEWER="imv"                                                   # image viewer
export FILE_BROWSER="${TERMINAL} lf"                                        # file browser
export SCREENSHOT="grim -g $(slurp)"                                        # screenshot utility
export TASK_MANAGER="${TERMINAL} glances"                                   # task manager
export SCREEN_LOCKER="hyprlock"                                             # screen locker
export BLUETOOTH_SELECTOR="dmenu-bluetooth"                                 # bluetooth device selector
export WIFI_SELECTOR="wifi-selector"                                        # wifi network selector
export MAIL_CLIENT="${TERMINAL} neomutt -F ${NEOMUTT_CONFIG}"               # email client
                                                                            #
#############################################################################

# Define custom PATH
declare -a paths=(
  "${HOME}/.local/backup"
  "${HOME}/scripts/bin"
  "${HOME}/scripts/system"
  "${HOME}/.local/bin"
)
CUSTOM_PATHS=$(IFS=:; echo "${paths[*]}")
export PATH="${CUSTOM_PATHS}:${PATH}"

# Source zshrc
[[ -f ~/.config/shell/.zshrc ]] && . ~/.config/shell/.zshrc

# Start hyprland WM
[[ -z ${WAYLAND_DISPLAY} && ${XDG_VTNR} -eq 1 ]] && exec /usr/bin/hyprland

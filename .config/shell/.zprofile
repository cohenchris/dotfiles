#####################################################################################
#                               CLEAN UP ~                                          #
#####################################################################################
                                                                                    #
# https://wiki.archlinux.org/title/XDG_Base_Directory                               #
export XDG_CONFIG_HOME="${HOME}/.config"                                            # config files
export XDG_CACHE_HOME="${HOME}/.local/cache"                                        # cached data
export XDG_DATA_HOME="${HOME}/.local/share"                                         # application data
export XDG_TRASH_DIR="${HOME}/.local/trash"                                         # trash
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
# HANDLERS                                                                          #
export EDITOR="nvim"                                                                # text editor 
export SHELL="zsh"                                                                  # terminal shell
export DMENU_BLUETOOTH_LAUNCHER="fuzzel"                                            # use fuzzel instead of dmenu for dmenu-bluetooth
                                                                                    #
#####################################################################################

# Define custom PATH
declare -a paths=(
  "${HOME}/.local/backup"
  "${HOME}/scripts/bin"
  "${HOME}/scripts/system"
  "${HOME}/.local/defaults"
)
CUSTOM_PATHS=$(IFS=:; echo "${paths[*]}")
export PATH="${CUSTOM_PATHS}:${PATH}"

# Source ZSH config file
[[ -f "${XDG_CONFIG_HOME}/shell/.zshrc" ]] && . "${XDG_CONFIG_HOME}/shell/.zshrc"

# Start hyprland WM
[[ -z "${WAYLAND_DISPLAY}" && "${XDG_VTNR}" -eq 1 ]] && exec /usr/bin/hyprland

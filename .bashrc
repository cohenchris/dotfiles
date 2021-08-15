case $- in
    *i*) ;;
      *) return;;
esac


# HISTORY
HISTCONTROL=ignoreboth    # de-duplicate and omit lines starting with spaces
shopt -s histappend       # append to history file, don't overwrite
HISTSIZE=1000             # max history size
HISTFILESIZE=2000         # max history file size

# update window size (LINES and COLUMNS) after each command
shopt -s checkwinsize

# terminal prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u\[\033[00;37m\]@\[\033[01;37m\]\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\$ '

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


###################
##### ALIASES #####
###################
# Basics
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# SSH
alias pihole="ssh pi@192.168.24.1"                # pi-hold dns adblocker   192.168.24.1
alias sd="ssh pi@192.168.24.2"                    # sd pi vpn               192.168.24.2
alias mediaserver="ssh phrog@192.168.24.3"        # media server            192.168.24.3
alias cloud="ssh chris@192.168.24.4"              # nextcloud server        192.168.24.4
alias stl="ssh pi@192.168.2.1"                    # stl pi vpn              192.168.2.1

# Misc
alias val="valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --track-origins=yes"

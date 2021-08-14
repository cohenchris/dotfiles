case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u\[\033[00;37m\]@\[\033[01;37m\]\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ANDROID_HOME="/usr/lib/android-sdk"

###################
##### ALIASES #####
###################

# LaTeX
alias texcreate="~/Projects/scripts/tex/texcreate.sh"
alias texedit="~/Projects/scripts/tex/texedit.sh"

# SSH
alias pihole="ssh pi@192.168.24.1"                # pi-hold dns adblocker   192.168.24.1
alias sd="ssh pi@192.168.24.2"                    # sd pi vpn               192.168.24.2
alias mediaserver="ssh phrog@192.168.24.3"        # media server            192.168.24.3
alias cloud="ssh chris@192.168.24.4"              # nextcloud server        192.168.24.4
alias stl="ssh pi@192.168.2.1"                    # stl pi vpn              192.168.2.1
alias vps="ssh root@chriscohen.dev"               # virtual private server  chriscohen.dev

# Maintenance
alias update="yes | sudo apt-get update; yes | sudo apt-get --with-new-pkgs upgrade; yes | sudo apt-get autoremove;"
alias updatevim="vim +PluginInstall +qall"
alias backup="~/Projects/backup/backup_script.sh"

# Misc
alias wifi="~/Projects/scripts/wifi.sh"
alias val="valgrind --leak-check=full --show-leak-kinds=all --track-fds=yes --track-origins=yes"
alias shortcuts="~/Projects/scripts/shortcuts.sh"
alias earbuds="~/Projects/scripts/earbuds.sh"
alias mountsd="udisksctl mount -b /dev/mmcblk0; mkdir ~/sdcard; ln -s /media/${USER}/disk ~/sdcard"
alias unmountsd="unlink ~/sdcard/disk; udisksctl unmount -b /dev/mmcblk0p1; rm -r ~/sdcard"
alias occ="docker-compose exec --user www-data nextcloud php occ"

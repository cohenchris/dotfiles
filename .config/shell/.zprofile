# profile file. Runs on login. Environmental variables are set here.

# add custom scripts/backup scripts to PATH
PATH=$PATH:/home/chris/.local/backup:/home/chris/.local/bin/personal

# Defaults
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="brave"
export SHELL="zsh"

# Clean up ~
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/pythonrc"

#export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/xinitrc"
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
#export MYVIMRC="${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"

# Source zshrc
[[ -f ~/.config/shell/.zshrc ]] && . ~/.config/shell/.zshrc

# Start x server
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx /usr/bin/i3

# Autorandr
autorandr -c

# This is the list for lf icons:
export LF_ICONS="di=📁:\
  fi=📃:\
  tw=🤝:\
  ow=📂:\
  ln=⛓:\
  or=❌:\
  ex=🎯:\
  *.txt=✍:\
  *.mom=✍:\
  *.me=✍:\
  *.ms=✍:\
  *.png=🖼:\
  *.webp=🖼:\
  *.ico=🖼:\
  *.jpg=📸:\
  *.jpe=📸:\
  *.jpeg=📸:\
  *.gif=🖼:\
  *.svg=🗺:\
  *.tif=🖼:\
  *.tiff=🖼:\
  *.xcf=🖌:\
  *.html=🌎:\
  *.xml=📰:\
  *.gpg=🔒:\
  *.css=🎨:\
  *.pdf=📚:\
  *.djvu=📚:\
  *.epub=📚:\
  *.csv=📓:\
  *.xlsx=📓:\
  *.tex=📜:\
  *.md=📘:\
  *.r=📊:\
  *.R=📊:\
  *.rmd=📊:\
  *.Rmd=📊:\
  *.m=📊:\
  *.mp3=🎵:\
  *.opus=🎵:\
  *.ogg=🎵:\
  *.m4a=🎵:\
  *.flac=🎼:\
  *.wav=🎼:\
  *.mkv=🎥:\
  *.mp4=🎥:\
  *.webm=🎥:\
  *.mpeg=🎥:\
  *.avi=🎥:\
  *.mov=🎥:\
  *.mpg=🎥:\
  *.wmv=🎥:\
  *.m4b=🎥:\
  *.flv=🎥:\
  *.zip=📦:\
  *.rar=📦:\
  *.7z=📦:\
  *.tar.gz=📦:\
  *.z64=🎮:\
  *.v64=🎮:\
  *.n64=🎮:\
  *.gba=🎮:\
  *.nes=🎮:\
  *.gdi=🎮:\
  *.1=ℹ:\
  *.nfo=ℹ:\
  *.info=ℹ:\
  *.log=📙:\
  *.iso=📀:\
  *.img=📀:\
  *.bib=🎓:\
  *.ged=👪:\
  *.part=💔:\
  *.torrent=🔽:\
  *.jar=♨:\
  *.java=♨:\
  "

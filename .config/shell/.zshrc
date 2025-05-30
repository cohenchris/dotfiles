# Color terminal + custom color prompt
autoload -U colors && colors  # Load colors
PS1="%B%{$fg[red]%}%n%{$fg[white]%}@%{$fg[white]%}%M:%~%{$fg[white]%}%{$reset_color%}$%b "

# Lines configured by zsh-newuser-install
HISTFILE=${XDG_DATA_HOME}/zsh/zhist
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch notify
stty stop undef     # disable ctrl-s to freeze terminal
bindkey -v
bindkey '^R' history-incremental-search-backward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '${XDG_CONFIG_HOME}/shell/.zshrc'

autoload -Uz compinit
autoload -Uz tetriscurses # :)
compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}
# End of lines added by compinstall

# Aliases
[ -f "${XDG_CONFIG_HOME}/shell/aliasrc" ] && source ${XDG_CONFIG_HOME}/shell/aliasrc

# Keyboard fixes
[ -f "${XDG_CONFIG_HOME}/shell/keyboardrc" ] && source ${XDG_CONFIG_HOME}/shell/keyboardrc

# User-specific data
[ -f "${XDG_CONFIG_HOME}/user" ] && source ${XDG_CONFIG_HOME}/user

# Plugins
source ${XDG_DATA_HOME}/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ${XDG_DATA_HOME}/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ${XDG_DATA_HOME}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ${XDG_DATA_HOME}/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh

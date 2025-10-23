# color terminal + custom color prompt
autoload -U colors && colors  # Load colors
PS1="%B%{$fg[red]%}%n%{$fg[white]%}@%{$fg[white]%}%M:%~%{$fg[white]%}%{$reset_color%}$%b "

# history management
HISTFILE=${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/zhist
HISTSIZE=1000
SAVEHIST=1000

# disable ctrl+s to freeze terminal
stty stop undef

# autocd        - change directories by typing the name without cd
# beep          - audible beep when things go wrong
# extendedglob  - advanced globbing patterns
# nomatch       - if a glob pattern doesn't exist, throw error
# notify        - send message when background job finishes
setopt autocd beep extendedglob nomatch notify

# use vim keybinds
bindkey -v

# ctrl+r reverse search
bindkey '^R' history-incremental-search-backward

# tetris!!
autoload -Uz tetriscurses

# load default programs
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/defaultsrc" ] && source ${XDG_CONFIG_HOME:-${HOME}/.config}/shell/defaultsrc

# load shell aliases
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliasrc" ] && source ${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliasrc

# load shell plugins
source ${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh

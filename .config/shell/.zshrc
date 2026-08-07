# color terminal + custom color prompt
autoload -U colors && colors  # Load colors
PS1="%B%{$fg[red]%}%n%{$fg[white]%}@%{$fg[white]%}%M:%~%{$fg[white]%}%{$reset_color%}$%b "

# history management
HISTFILE=${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/zhist
[ -d "${HISTFILE:h}" ] || mkdir -p "${HISTFILE:h}"
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

# load shell aliases
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliasrc" ] && source ${XDG_CONFIG_HOME:-${HOME}/.config}/shell/aliasrc

# load keyboard modifications
[ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/shell/keyboardrc" ] && source ${XDG_CONFIG_HOME:-${HOME}/.config}/shell/keyboardrc

# load shell plugins (install if missing)
() {
  local plugin_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/plugins"
  local -A plugin_repos=(
    fast-syntax-highlighting     https://github.com/zdharma-continuum/fast-syntax-highlighting.git
    zsh-autosuggestions          https://github.com/zsh-users/zsh-autosuggestions.git
    zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search.git
  )
  local name
  for name in "${(@k)plugin_repos}"; do
    [ -d "${plugin_dir}/${name}" ] || git clone --quiet --depth=1 "${plugin_repos[$name]}" "${plugin_dir}/${name}"
  done

  source "${plugin_dir}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  source "${plugin_dir}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
  source "${plugin_dir}/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
}

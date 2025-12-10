# Completion System
# Add zsh-completions to fpath
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
fi

zmodload zsh/complist
autoload -Uz compinit

compinit

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# Vi Mode
bindkey -v
export KEYTIMEOUT=1
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Menu Selection Bindings (vim-style)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Filter history by current input
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# completions
#
autoload -Uz compinit
compinit

# case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# menu selection
zstyle ':completion:*' menu select

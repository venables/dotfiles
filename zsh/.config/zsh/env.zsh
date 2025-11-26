# environment variables
export GPG_TTY=$(tty)

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# History
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

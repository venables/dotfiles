alias ll="ls -la"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# git
alias g="git"
alias ga='git add'
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gl='git l'
alias gla='git la'
alias gp='git push'
alias gs='git status -sb'
alias gshow='git show'

# editor
# neovim - opens current dir if no args, otherwise passes args
n() { nvim "${@:-.}"; }



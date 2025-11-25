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
alias gdc='git diff --cached'
alias gl='git l'
alias gla='git la'
alias gp='git push'
alias gs='git status -sb'
alias gshow='git show'

# ai tools
alias cc="claude"
alias oc="opencode"

# editor
n() { nvim "${@:-.}"; }

# eza (`ls` replacement)
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh --group-directories-first --icons=auto'
  alias la='eza -lah --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --icons --git'
  alias lta='eza --tree --level=2 --icons --git -a'
fi

# bat
if command -v bat &>/dev/null; then
  alias cat="bat --style=plain --paging=never"
  alias less="bat --style=plain"
fi

# fzf
if command -v fzf &>/dev/null && command -v bat &>/dev/null; then
  alias f='fzf'
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
fi

if command -v zoxide &>/dev/null; then
  alias cd="z"
fi

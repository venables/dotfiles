# Aliases
# =======
alias g='git'
alias ga='git add '
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m '
alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff'
alias gl='git l'
alias gla='git la'
alias gpush='git push'
alias gs='git status -sb'
alias gshow='git show'
alias m='vim .'

# Colors
# ======
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export GREP_OPTIONS='--color=auto'
autoload -U colors
colors

# Prompt
# ======
setopt PROMPT_SUBST
parse_git_branch() {
  branch="$(git symbolic-ref HEAD 2>/dev/null)" || return
  echo "@${branch#refs/heads/}"
}
PROMPT=$'%{${fg[cyan]}%}%B%~%b%{${fg[yellow]}%}$(parse_git_branch)%{${fg[default]}%} '

# Tab Completion
# ==============
autoload -Uz compinit && compinit

# Tab completion
# ==============
fpath=(/usr/local/share/zsh-completions $fpath)

# Editor
# ======
export VISUAL="code"
export EDITOR=vim
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

# Path Updates
# ============
export PATH=/usr/local/bin:$PATH:~/.config/yarn/global/node_modules/.bin # homebrew first, yarn last

# asdf
# ====
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

export PATH="/usr/local/sbin:$PATH"
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

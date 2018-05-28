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
alias git='hub'
alias foreman='nf'
alias f='[ -e Procfile.local ] && foreman start --procfile Procfile.local || foreman start'

alias vim='mvim'
alias m='vim .'

alias sys="neofetch"

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
autoload -U compinit
compinit

# Tab completion
# ==============
fpath=(~/.zsh/completion $fpath)

# Editor
# ======
export VISUAL="code" # "mvim -f"
export EDITOR="$VISUAL"
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

# Ruby
# ====
# eval "$(rbenv init -)"

# Path Updates
# ============
export PATH=/usr/local/bin:$PATH:~/.config/yarn/global/node_modules/.bin # homebrew first, yarn last

# asdf
# ====
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

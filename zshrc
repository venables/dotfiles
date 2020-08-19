# Aliases: Ruby
alias be="bundle exec"
alias f="[ -f Procfile.dev ] && foreman start -f Procfile.dev || foreman start"

# Aliases: Node
alias fix-gyp="sudo rm -rf  /Library/Developer/CommandLineTools; xcode-select --install"

# Aliases: Git
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

# Aliases: File Associations
alias -s {css,js,ts,html,md,json,rb,rake}=code

# Aliases: Misc
alias dev="cd ~/dev/"

# Enable Colors
autoload colors zsh/terminfo
colors

# Prompt
setopt PROMPT_SUBST
parse_git_branch() {
 branch="$(git symbolic-ref HEAD 2>/dev/null)" || return
 echo "@${branch#refs/heads/}"
}
PROMPT=$'%{${fg[cyan]}%}%B%~%b%{${fg[magenta]}%}$(parse_git_branch)%{${fg[default]}%} '

# Assume `cd` when typing a directory
setopt auto_cd

# Editor
# ======
export VISUAL="vim"
export EDITOR=vim

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  . $(brew --prefix asdf)/asdf.sh

  autoload -Uz compinit
  compinit
fi

export PATH="/usr/local/sbin:$PATH"

# Rubocop-Daemon
# https://github.com/fohte/rubocop-daemon
# export RUBOCOP_DAEMON_USE_BUNDLER=true
export PATH="/usr/local/bin/rubocop-daemon-wrapper:$PATH"

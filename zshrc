## znap
## https://github.com/marlonrichert/zsh-snap
source ~/.dotfiles/.plugins/znap/znap.zsh

## Prompt
## ======
znap prompt sindresorhus/pure

## Plugins
## =======
znap source asdf-vm/asdf
znap source marlonrichert/zsh-autocomplete
ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions
ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting

## Integrate iTerm2
## https://iterm2.com/documentation-shell-integration.html
## ================
znap eval iterm2 'curl -fsSL https://iterm2.com/shell_integration/zsh'


## Enable Colors
## =============
# autoload colors zsh/terminfo
# colors

## Prompt
## ======
# setopt PROMPT_SUBST
# parse_git_branch() {
#   branch="$(git symbolic-ref HEAD 2>/dev/null)" || return
#   echo "@${branch#refs/heads/}"
# }
# PROMPT=$'%{${fg[cyan]}%}%B%~%b%{${fg[magenta]}%}$(parse_git_branch)%{${fg[default]}%} '

## Editor
## ======
export VISUAL="vim"
export EDITOR=vim

## Aliases: Git
## ============
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

## zsh completions & asdf
## ======================
# if type brew &>/dev/null; then
#   FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
#   . $(brew --prefix asdf)/libexec/asdf.sh

#   autoload -Uz compinit
#   compinit
# fi

## Enable gpg daemon
## =================
export GPG_TTY=$(tty)

# bun completions
[ -s "/Users/matt/.bun/_bun" ] && source "/Users/matt/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Postgres@15
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"

# pnpm
export PNPM_HOME="/Users/matt/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

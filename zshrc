# Use nvim as the default vim
alias vim="nvim"
alias m='vim .'
alias be="bundle exec"
alias f="foreman start"

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

# Fix typos
setopt correctall
alias git status='nocorrect git status'

# Editor
# ======
export VISUAL="vim"
export EDITOR=vim
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Setup antigen plugin manager
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "chriskempson/base16-shell", use:"scripts/base16-default-dark.sh", defer:0
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "mafredri/zsh-async", defer:0
zplug "zsh-users/zsh-syntax-highlighting", defer:2 # Should be loaded 2nd last.
zplug "zsh-users/zsh-history-substring-search", defer:3 # Should be loaded last.
zplug "junegunn/fzf", use:"shell/*.zsh"
zplug load

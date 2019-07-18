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
zplug "kiurchv/asdf.plugin.zsh"
zplug load

BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

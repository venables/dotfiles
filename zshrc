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
export EDITOR="$VISUAL"
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

# Terminal.app
# ============
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then

    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL, including
        # the host name to disambiguate local vs. remote paths.

        # Percent-encode the pathname.
        local url_path=''
        {
            # Use LC_CTYPE=C to process text byte-by-byte. Ensure that
            # LC_ALL isn't set, so it doesn't interfere.
            local i ch hexch LC_CTYPE=C LC_ALL=
            for ((i = 1; i <= ${#PWD}; ++i)); do
                ch="$PWD[i]"
                if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
                    url_path+="$ch"
                else
                    printf -v hexch "%02X" "'$ch"
                    url_path+="%$hexch"
                fi
            done
        }

        printf '\e]7;%s\a' "file://$HOST$url_path"
    }

    # Register the function so it is called at each prompt.
    autoload add-zsh-hook
    add-zsh-hook precmd update_terminal_cwd
fi

# Path Updates
# ============
export PATH=/usr/local/bin:$PATH:~/.config/yarn/global/node_modules/.bin # homebrew first, yarn last

clear

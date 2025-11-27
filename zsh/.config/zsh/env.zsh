# environment variables
export GPG_TTY=$(tty)

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# History
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS     # don't record duplicate commands
setopt HIST_IGNORE_SPACE    # ignore commands starting with space
setopt HIST_VERIFY          # show command before executing from history
setopt HIST_REDUCE_BLANKS   # remove extra whitespace from commands
setopt SHARE_HISTORY        # share history across all sessions
setopt APPEND_HISTORY       # append to history file

# Directory navigation
setopt AUTO_CD              # type directory name to cd into it
setopt AUTO_PUSHD           # automatically push dirs to stack
setopt PUSHD_IGNORE_DUPS    # don't push duplicate dirs

# Completion
setopt AUTO_MENU            # show completion menu on tab

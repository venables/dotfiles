# =============================================================================
# Environment
# =============================================================================

export GPG_TTY=$(tty)

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# npm
export NPM_CONFIG_PREFIX="$HOME/.npm-global"

# telemetry
export DISABLE_TELEMETRY=1

# pager
export PAGER="less"
export MANPAGER="less"

# History
export HISTFILE="$HOME/.zsh_history"
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

# =============================================================================
# PATH
# =============================================================================

typeset -U path  # unique entries only

if [[ -z "${HOMEBREW_PREFIX:-}" ]] && command -v brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
fi

path=(
  "/Applications/Obsidian.app/Contents/MacOS" # obsidian
  "$NPM_CONFIG_PREFIX/bin"        # global npm packages
  "$HOME/.bun/bin"                # bun
  "$HOME/.opencode/bin"           # opencode CLI
  "$HOME/.local/bin"              # user-local binaries
  "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/libpq/bin" # psql command
  $path
)

# =============================================================================
# Tools
# =============================================================================

# Starship
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Mise
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# Yazi (Shell Wrapper)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# =============================================================================
# Settings
# =============================================================================

# Completion System
# Add zsh-completions to fpath
if [[ -n "$HOMEBREW_PREFIX" ]]; then
  FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
fi

zmodload zsh/complist
autoload -Uz compinit

# Only rebuild completion dump once per day; otherwise use cache
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# Vi Mode
bindkey -v
export KEYTIMEOUT=1
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Menu Selection Bindings (vim-style)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Filter history by current input
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# =============================================================================
# Aliases
# =============================================================================

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
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git fetch --all --prune'
alias gg='lazygit'
alias gl='git l'
alias gla='git la'
alias glw='git worktree list'
alias gp='git push'
alias gs='git status -sb'
alias gshow='git show'
alias gw='git worktree'
alias gwl='git wl'
alias gwa='git wa'
alias gwr='git wr'
alias gcl='git claude'
alias goc='git oc'

# ai tools
alias cc='claude --dangerously-skip-permissions'
alias ccw='cc --worktree'
alias co='codex'
alias oc='opencode'
alias claw='openclaw'

# editors
n() { nvim "${@:-.}"; }
e() { zed "${@:-.}"; }

# git worktree + claude combo (wt + claude)
wtc() { wt "$@"; cc; }

# eza (ls replacement)
alias ls='eza -a --group-directories-first --icons=auto'
alias ll='eza -lh --group-directories-first --icons=auto'
alias la='eza -lah --group-directories-first --icons=auto'
alias lt='eza --tree --level=2 --icons --git'
alias lta='eza --tree --level=2 --icons --git -a'

# bat
alias cat='bat --style=plain --paging=never'
alias less='bat --style=plain'

# fzf
alias f='fzf'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# zoxide
alias cd='z'

# glow (markdown viewer)
alias md='glow -t'

# =============================================================================
# Plugins
# =============================================================================

# Plugins (requires brew)
if command -v brew &>/dev/null; then
  BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

  # Zsh Autosuggestions
  if [ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    bindkey '^?' backward-delete-char
  fi

  # Zsh Syntax Highlighting (must be last)
  if [ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi

  # venables/tap/wt
  if [ -f "$BREW_PREFIX/share/wt/wt.sh" ]; then
    source "$BREW_PREFIX/share/wt/wt.sh"
  fi
fi

# Cached completions (regenerate with: regen-completions)
_COMP_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"

# openclaw
if command -v openclaw &>/dev/null; then
  [[ -f "$_COMP_CACHE/openclaw.zsh" ]] && source "$_COMP_CACHE/openclaw.zsh"
fi

# Entire CLI
if command -v entire &>/dev/null; then
  [[ -f "$_COMP_CACHE/entire.zsh" ]] && source "$_COMP_CACHE/entire.zsh"
fi

# Regenerate cached completions
regen-completions() {
  mkdir -p "$_COMP_CACHE"
  echo "Regenerating completions..."
  command -v openclaw &>/dev/null && openclaw completion --shell zsh > "$_COMP_CACHE/openclaw.zsh" && echo "  openclaw done"
  command -v entire &>/dev/null && entire completion zsh > "$_COMP_CACHE/entire.zsh" && echo "  entire done"
  echo "Done. Restart your shell to pick up changes."
}

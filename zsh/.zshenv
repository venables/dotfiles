# =============================================================================
# .zshenv — sourced for ALL zsh invocations
# =============================================================================
# Runs for: interactive, non-interactive, login, and script shells (in that
# order, before .zprofile/.zshrc). Keep this minimal and fast — it runs for
# every `zsh -c 'cmd'`, SSH non-interactive command, and `#!/usr/bin/env zsh`
# script.
#
# Put things here only if they need to exist for non-interactive shells:
#   - PATH entries
#   - EDITOR/VISUAL/PAGER (used by git, gh, crontab, etc.)
#   - Env vars read by tools invoked over SSH or from scripts
#
# Interactive-only setup (aliases, prompt, keybindings, plugins) belongs in
# .zshrc. One-time login setup belongs in .zprofile.
# =============================================================================

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------
# Must run before any PATH manipulation that references $HOMEBREW_PREFIX.
# Sets PATH, MANPATH, INFOPATH, HOMEBREW_PREFIX, HOMEBREW_CELLAR, etc.

if [[ -z "${HOMEBREW_PREFIX:-}" ]] && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# -----------------------------------------------------------------------------
# Core environment
# -----------------------------------------------------------------------------

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="less"

export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export DISABLE_TELEMETRY=1

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
# `typeset -U` keeps entries unique (first occurrence wins). User-specific
# dirs come first so they override Homebrew/system binaries.

typeset -U path PATH

path=(
  "/Applications/Obsidian.app/Contents/MacOS"             # obsidian CLI
  "$NPM_CONFIG_PREFIX/bin"                                # global npm packages
  "$HOME/.bun/bin"                                        # bun
  "$HOME/.opencode/bin"                                   # opencode CLI
  "$HOME/.local/bin"                                      # user-local binaries
  "$HOME/.local/share/mise/shims"                         # mise-managed runtimes (non-interactive)
  "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/libpq/bin"       # psql
  $path
)

# -----------------------------------------------------------------------------
# OrbStack
# -----------------------------------------------------------------------------
# Sets DOCKER_HOST and adds docker/kubectl shims. Needed in .zshenv so that
# `ssh host 'docker ps'` and scripts can reach the OrbStack daemon.

[[ -f "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null

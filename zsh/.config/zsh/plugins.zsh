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


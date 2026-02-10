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

# openclaw
if command -v openclaw &>/dev/null; then
  source <(openclaw completion --shell zsh)
fi

# Entire CLI shell completion
if command -v entire &>/dev/null; then
  source <(entire completion zsh)
fi


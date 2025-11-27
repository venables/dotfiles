# Plugins (requires brew)
if command -v brew &>/dev/null; then
  BREW_PREFIX=$(brew --prefix)
  
  # Zsh Autosuggestions
  if [ -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^?' backward-delete-char
  fi

  # Zsh Syntax Highlighting (must be last)
  if [ -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
fi

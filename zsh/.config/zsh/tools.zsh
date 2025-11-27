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

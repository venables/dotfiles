# starship prompt
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# mise
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

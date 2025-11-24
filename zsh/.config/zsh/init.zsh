# starship prompt
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# mise
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi


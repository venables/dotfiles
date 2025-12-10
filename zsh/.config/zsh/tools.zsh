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

# Atuin (shell history)
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
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

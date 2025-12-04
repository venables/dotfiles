# homebrew
if command -v brew &>/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# orbstack
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

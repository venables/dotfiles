#!/usr/bin/env bash

echo "Creating symlinks..."

# get the root directory (one level up from script location)
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
# silence the login prompt
touch $HOME/.hushlogin

# git
ln -sf "$ROOT_DIR/dotfiles/git/gitconfig"         "$HOME/.gitconfig"
ln -sf "$ROOT_DIR/dotfiles/git/gitconfig-catena"  "$HOME/.gitconfig-catena"
ln -sf "$ROOT_DIR/dotfiles/git/gitignore"         "$HOME/.gitignore"
touch "$HOME/.gitconfig-local"
touch "$HOME/.gitconfig-catena-local"

# zsh
ln -sf "$ROOT_DIR/dotfiles/zsh/zshrc"     "$HOME/.zshrc"

# starship
mkdir -p "$HOME/.config"
ln -sf "$ROOT_DIR/dotfiles/config/starship.toml" "$HOME/.config/starship.toml"

# tool-versions
ln -sf "$ROOT_DIR/dotfiles/tool-versions" "$HOME/.tool-versions"

# ghostty
mkdir -p "$HOME/.config/ghostty"
ln -sf "$ROOT_DIR/dotfiles/config/ghostty/config" "$HOME/.config/ghostty/config"

# nvim
ln -sf "$ROOT_DIR/dotfiles/config/nvim" "$HOME/.config/nvim"

# vscode (if installed)
if [ -d "$HOME/Library/Application Support/Code" ]; then
  ln -sf "$ROOT_DIR/dotfiles/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
fi

# cursor
mkdir -p "$HOME/Library/Application Support/Cursor/User"
ln -sf "$ROOT_DIR/dotfiles/vscode/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"

# zed
mkdir -p "$HOME/.config/zed"
ln -sf "$ROOT_DIR/dotfiles/config/zed/settings.json" "$HOME/.config/zed/settings.json"

# claude
mkdir -p "$HOME/.config/claude"
ln -sf "$ROOT_DIR/dotfiles/claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$ROOT_DIR/dotfiles/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# gnupg
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"
ln -sf "$ROOT_DIR/dotfiles/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"

# gh-dash
mkdir -p "$HOME/.config/gh-dash"
ln -sf "$ROOT_DIR/dotfiles/config/gh-dash/config.yml" "$HOME/.config/gh-dash/config.yml"

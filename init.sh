#!/bin/bash

# Install homebrew
if ! [ -x "$(command -v brew)" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install system dependencies
brew install \
  git \
  heroku \
  vim \
  zsh \
  zsh-completions

# Install databases
brew install postgresql redis

# Install vim-plug
./scripts/vim.sh

# Set zsh as our shell
./scripts/zsh.sh

# Symlink dotfiles
./scripts/symlink.sh	


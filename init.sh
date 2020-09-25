#!/bin/bash

# Install homebrew
if ! [ -x "$(command -v brew)" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap heroku/brew

# Install system dependencies
brew install \
  git \
  heroku \
  vim \
  zsh \
  zsh-completions

# Install databases
brew install postgresql redis

# Ruby, NodeJS
brew install \
  asdf
  coreutils \
  gpg

asdf plugin-add ruby
asdf plugin-add nodejs
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'

# Install vim-plug
./scripts/vim.sh

# Set zsh as our shell
./scripts/zsh.sh

# Symlink dotfiles
./scripts/symlink.sh


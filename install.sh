#!/usr/bin/env bash

# get the root directory of this repo
DIR="$( cd "$( dirname "$0" )" && pwd )"

# symlink all dotfiles to ~
ln -sf $DIR/.vimrc ~/.vimrc
ln -sf $DIR/.zshrc ~/.zshrc

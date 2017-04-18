#!/usr/bin/env bash

# get the root directory of this repo
DIR="$( cd "$( dirname "$0" )" && pwd )"

# symlink all dotfiles to ~
ln -sf $DIR/.gitconfig ~/.gitconfig
ln -sf $DIR/.vimrc ~/.vimrc
ln -sf $DIR/.zshrc ~/.zshrc

# symlink bin files
ln -s $DIR/bin/db /usr/local/bin/db
ln -s $DIR/bin/git-cleanup /usr/local/bin/git-cleanup
ln -s $DIR/bin/git-sync /usr/local/bin/git-sync
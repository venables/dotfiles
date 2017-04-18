#!/usr/bin/env bash

# get the root directory of this repo
DIR="$( cd "$( dirname "$0" )" && pwd )"

# symlink all dotfiles to ~
ln -sf $DIR/.agignore ~/.agignore
ln -sf $DIR/.gitconfig ~/.gitconfig
ln -sf $DIR/.hushlogin ~/.hushlogin
ln -sf $DIR/.vimrc ~/.vimrc
ln -sf $DIR/.vimrc ~/.config/nvim/init.vim
ln -sf $DIR/.zshrc ~/.zshrc

# symlink bin files
ln -sf $DIR/bin/db /usr/local/bin/db
ln -sf $DIR/bin/git-cleanup /usr/local/bin/git-cleanup
ln -sf $DIR/bin/git-sync /usr/local/bin/git-sync

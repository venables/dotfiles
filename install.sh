#!/usr/bin/env bash

# Get the root directory of this repo
DIR="$( cd "$( dirname "$0" )" && pwd )"

# Symlink all dotfiles to ~/
ln -sf $DIR/.agignore ~/.agignore
ln -sf $DIR/.gitconfig ~/.gitconfig
ln -sf $DIR/.hushlogin ~/.hushlogin
ln -sf $DIR/.vimrc ~/.vimrc
ln -sf $DIR/.vimrc ~/.config/nvim/init.vim
ln -sf $DIR/.zshrc ~/.zshrc

# Symlink bin files
ln -sf $DIR/bin/db /usr/local/bin/db
ln -sf $DIR/bin/git-cleanup /usr/local/bin/git-cleanup
ln -sf $DIR/bin/git-sync /usr/local/bin/git-sync

# Install plug-vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

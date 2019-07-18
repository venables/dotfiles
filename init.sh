#!/bin/bash

# Install homebrew
if ! [ -x "$(command -v brew)" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install system dependencies
brew install \
  ag \
  fzf \
  git \
  heroku \
  python3 \
  reattach-to-user-namespace \
  tmux \
  yarn \
  zplug \
  zsh \
  zsh-completions

# Install databases
brew install postgresql redis

# Install Applications from homebrew
brew tap caskroom/cask
brew cask install iterm2

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install asdf
brew install asdf gnupg
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

asdf install nodejs 12.6.0
asdf global nodejs 12.6.0
asdf install ruby 2.6.3
asdf global ruby 2.6.3

# Install neovim
brew install neovim/neovim/neovim

# Add Neovim language support
pip3 install pynvim
pip3 install neovim
gem install neovim
yarn global add neovim

# Set zsh as our shell
sudo echo "/usr/local/bin/zsh" >> /etc/shells
chsh -s /usr/local/bin/zsh

# Cleanup
rm -rf ~/.vim ~/.vimrc ~/.zshrc ~/.tmux ~/.tmux.conf ~/.config/nvim 2> /dev/null

# Symlink dotfiles
mkdir -p ~/.config ~/.config/nvim
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim

ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/gitignore ~/.gitignore
ln -sf ~/.dotfiles/hushlogin ~/.hushlogin
ln -sf ~/.dotfiles/zshenv ~/.zshenv

ln -sf ~/.dotfiles/bin/db /usr/local/bin/db
ln -sf ~/.dotfiles/bin/git-cleanup /usr/local/bin/git-cleanup
ln -sf ~/.dotfiles/bin/git-sync /usr/local/bin/git-sync

# iTerm Settings & Colors
rm -rf ~/.config/base16-shell
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.dotfiles/resources/iterm"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true


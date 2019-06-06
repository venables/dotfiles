# .dotfiles

## Installation

### 1. Clone the repo
```sh
git clone git@github.com:venables/dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

### 2. Install following packages:

```
ag
asdf
git
postgresql
redis
vim
yarn
zsh
zsh-completions
```

### 3. Add zsh to /etc/shells

```
sudo echo "/usr/local/bin/zsh" >> /etc/shells
chsh -s /usr/local/bin/zsh
```

### 4. Link dotfiles and scripts

```
ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/gitignore ~/.gitignore
ln -sf ~/.dotfiles/hushlogin ~/.hushlogin
ln -sf ~/.dotfiles/vimrc ~/.vimrc
ln -sf ~/.dotfiles/zshrc ~/.zshrc

ln -sf ~/.dotfiles/bin/db /usr/local/bin/db
ln -sf ~/.dotfiles/bin/git-cleanup /usr/local/bin/git-cleanup
ln -sf ~/.dotfiles/bin/git-sync /usr/local/bin/git-sync
```

### 5. Install nodejs, ruby from asdf

```
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
brew install gnupg
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
```

### 6. Set up vim

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### 7. Other:

#### iTerm Settings:

```
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.dotfiles/resources/iterm"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
```

#### Set up VSCode

```
mkdir -p ~/Library/Application\ Support/Code/User/
ln -sf ~/.dotfiles/resources/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

#### Set up '/work' directory
```
mkdir -p ~/dev
sudo ln -s ~/dev /work
```

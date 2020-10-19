ln -sf ~/.dotfiles/zshrc ~/.zshrc

ln -sf ~/.dotfiles/vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -sf ~/.dotfiles/vimrc ~/.config/nvim/init.vim
ln -sf ~/.dotfiles/vimrc ~/.vimrc
ln -sf ~/.dotfiles/gvimrc ~/.gvimrc
ln -sf ~/.dotfiles/gitattributes ~/.gitattributes
ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/gitignore ~/.gitignore
ln -sf ~/.dotfiles/hushlogin ~/.hushlogin
ln -sf ~/.dotfiles/gemrc ~/.gemrc
ln -sf ~/.dotfiles/irbrc ~/.irbrc

ln -sf ~/.dotfiles/bin/db /usr/local/bin/db
ln -sf ~/.dotfiles/bin/git-cleanup /usr/local/bin/git-cleanup
ln -sf ~/.dotfiles/bin/git-sync /usr/local/bin/git-sync
ln -sf ~/.dotfiles/bin/fix-rubocop /usr/local/bin/fix-rubocop

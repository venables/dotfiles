# Set zsh as our shell
sudo echo "/opt/homebrew/bin/zsh" >> /etc/shells
chsh -s /opt/homebrew/bin/zsh

# Install znap
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.dotfiles/.plugins/znap

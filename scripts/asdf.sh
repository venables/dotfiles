#!/usr/bin/env bash

echo "Setting up ASDF..."

# Install plugins listed in ~/.tool-versions
while read plugin version; do asdf plugin add $plugin; done <~/.tool-versions

# Install all plugins and versions listed in ~/.tool-versions
asdf install

# Install nodejs
# asdf plugin add nodejs
# asdf install nodejs latest
# asdf set nodejs latest --home

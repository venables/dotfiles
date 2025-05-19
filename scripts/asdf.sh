#!/usr/bin/env bash

# Install latest nodejs LTS
asdf plugin add nodejs
asdf cmd nodejs update-nodebuild
NODEJS_LTS=$(asdf cmd nodejs resolve lts --latest-available)
asdf install nodejs "$NODEJS_LTS"

touch "$HOME/.tool-versions"
sed -i '' "s/^nodejs.*/nodejs $NODEJS_LTS/" "$HOME/.tool-versions"

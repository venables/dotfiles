#!/usr/bin/env bash

# Install nodejs
asdf plugin add nodejs
asdf install nodejs latest
asdf set nodejs latest --home

# Install bun
asdf plugin add bun
asdf install bun latest
asdf set bun latest --home

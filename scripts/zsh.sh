#!/usr/bin/env bash

# Set the default shell to zsh, installed by brew
if ! grep -q "/opt/homebrew/bin/zsh" "/etc/shells"; then
  echo "/opt/homebrew/bin/zsh" | sudo tee -a "/etc/shells"
  chsh -s "/opt/homebrew/bin/zsh"
fi

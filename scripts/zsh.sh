#!/usr/bin/env bash

if ! grep -q "/opt/homebrew/bin/zsh" "/etc/shells"; then
  echo "/opt/homebrew/bin/zsh" | sudo tee -a "/etc/shells"
  chsh -s "/opt/homebrew/bin/zsh"
fi

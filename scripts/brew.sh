#!/usr/bin/env bash

echo "Setting up Homebrew..."

# Install xcode command line tools
if [ ! -x /opt/homebrew/bin/brew ]; then
  echo "Homebrew not found. Installing Homebrew..."
  xcode-select --install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew found. Updating..."
  /opt/homebrew/bin/brew update
fi

# Install packages from Brewfile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle

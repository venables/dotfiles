#!/usr/bin/env bash

# Install xcode command line tools
if [ ! -x /opt/homebrew/bin/brew ]; then
  echo "Homebrew not found. Installing Homebrew..."
  xcode-select --install
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew found. Updating..."
  /opt/homebrew/bin/brew update
fi

# Load Homebrew environment for the rest of the setup scripts
eval "$(/opt/homebrew/bin/brew shellenv)"

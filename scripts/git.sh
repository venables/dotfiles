#!/usr/bin/env bash

# Set git configuration
git config --global gpg.program $(which gpg)

# Github CLI Extensions
gh extension install dlvhdr/gh-dash
gh extension install seachicken/gh-poi

#!/usr/bin/env bash

set -e

echo ""
echo "█░█ █▀▀▀ █▀▀▄ █▀▀█ █▀▀▄ █░░░ █▀▀▀ █▀▀▀"
echo "█░█ █▀▀▀ █░░█ █▄▄█ █▀▀▄ █░░░ █▀▀▀ ▀▀▀█"
echo "▀▀░ ▀▀▀▀ ▀░░▀ ▀░░▀ ▀▀▀░ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀"
echo ""

./scripts/brew.sh
./scripts/symlink.sh
./scripts/llms.sh
./scripts/mise.sh
./scripts/zsh.sh

echo "✨ Installation complete!"

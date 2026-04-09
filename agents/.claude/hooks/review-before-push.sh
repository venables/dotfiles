#!/usr/bin/env bash

# Open editor for review before pushing
# <https://github.com/affaan-m/everything-claude-code>

echo '[hook] Review changes before push...' >&2
# Uncomment your preferred editor:
# zed . 2>/dev/null
# code . 2>/dev/null
# cursor . 2>/dev/null
nvim . 2>/dev/null
echo '[hook] Press Enter to continue with push or Ctrl+C to abort...' >&2

read -r

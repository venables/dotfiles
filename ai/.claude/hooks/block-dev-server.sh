#!/bin/bash
# =============================================================================
# block-dev-server.sh - PreToolUse hook
# Blocks dev server commands when not running inside tmux
#
# Why: Dev servers are long-running processes that capture stdout. If Claude
# starts one outside tmux, you lose access to the server logs and can't easily
# kill it. Running in tmux lets you detach/reattach and manage the process.
# =============================================================================

# Read the JSON input from Claude Code
input=$(cat)

# Check if we're running inside a tmux session
# TMUX env var is set when inside tmux
if [ -z "$TMUX" ]; then
  # Not in tmux - block the command and explain why
  echo "BLOCK: Dev servers should be started in a tmux session" >&2
  echo "Run 'tmux new -s dev' first, then start the dev server" >&2
  exit 2  # Exit code 2 = block the tool use
fi

# In tmux - allow the command to proceed
echo "$input"

#!/bin/bash
# =============================================================================
# tmux-reminder.sh - PreToolUse hook
# Reminds user to use tmux for potentially long-running commands
#
# Why: Commands like npm install, test suites, docker builds, etc. can take
# a while. If you're not in tmux and the connection drops, you lose the output.
# This is a soft reminder (doesn't block), unlike block-dev-server.sh.
# =============================================================================

# Read the JSON input from Claude Code
input=$(cat)

# Check if we're running inside tmux
if [ -z "$TMUX" ]; then
  # Not in tmux - remind but don't block
  echo "[Hook] TIP: Consider running long commands in tmux" >&2
fi

# Always allow the command to proceed (this is just a reminder)
echo "$input"

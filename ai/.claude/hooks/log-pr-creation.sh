#!/bin/bash
# =============================================================================
# log-pr-creation.sh - PostToolUse hook
# Logs PR URL and provides next steps after gh pr create
#
# Why: After creating a PR, you typically want to review it in the browser
# or share it with teammates. This hook captures the PR URL from gh output
# and provides helpful next-step commands.
# =============================================================================

# Read the JSON input from Claude Code (contains tool output)
input=$(cat)

# Extract the command that was run
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Only process gh pr create commands
if [[ "$command" == *"gh pr create"* ]]; then
  # Extract stdout from the tool result (contains the PR URL)
  stdout=$(echo "$input" | jq -r '.tool_result.stdout // ""')

  # Look for a GitHub PR URL in the output
  pr_url=$(echo "$stdout" | grep -oE 'https://github.com/[^/]+/[^/]+/pull/[0-9]+' | head -1)

  if [ -n "$pr_url" ]; then
    # Extract PR number from URL for the review command
    pr_number=$(echo "$pr_url" | grep -oE '[0-9]+$')

    echo "" >&2
    echo "[Hook] PR created: $pr_url" >&2
    echo "[Hook] To review: gh pr view $pr_number --web" >&2
    echo "[Hook] To check CI: gh pr checks $pr_number" >&2
  fi
fi

# Always pass through input
echo "$input"

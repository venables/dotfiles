#!/bin/bash
# =============================================================================
# warn-console-log.sh - PostToolUse hook
# Warns about console.log statements in edited JS/TS files
#
# Why: console.log is useful for debugging but shouldn't be committed.
# This catches them early, right after editing, so they can be removed
# before the code review phase.
# =============================================================================

# Read the JSON input from Claude Code
input=$(cat)

# Extract the file path that was edited
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Only check if file exists
if [ -n "$file_path" ] && [ -f "$file_path" ]; then
  # Search for console.log with line numbers
  # -n: show line numbers
  # 2>/dev/null: suppress errors (e.g., binary files)
  # || true: don't fail if grep finds nothing
  console_logs=$(grep -n "console\.log" "$file_path" 2>/dev/null || true)

  # If we found any console.log statements, warn the user
  if [ -n "$console_logs" ]; then
    echo "[Hook] WARNING: console.log found in $file_path" >&2
    # Show first 5 occurrences with line numbers
    echo "$console_logs" | head -5 >&2
    echo "[Hook] Remove console.log before committing" >&2
  fi
fi

# Always pass through input (PostToolUse hooks don't block)
echo "$input"

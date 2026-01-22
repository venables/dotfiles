#!/bin/bash
# =============================================================================
# audit-console-log.sh - Stop hook
# Final audit for console.log in all modified files before session ends
#
# Why: This is a last-chance safety net. Even if individual file warnings were
# missed during editing, this catches any remaining console.logs across ALL
# modified files before the session ends.
# =============================================================================

# Read input from Claude Code
input=$(cat)

# Check if we're in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
  # Get all JS/TS files that have been modified compared to HEAD
  # This includes staged, unstaged, and untracked changes
  modified_files=$(git diff --name-only HEAD 2>/dev/null | grep -E '\.(ts|tsx|js|jsx)$' || true)

  # Only proceed if there are modified JS/TS files
  if [ -n "$modified_files" ]; then
    has_console=false

    # Loop through each modified file
    while IFS= read -r file; do
      # Verify file still exists (might have been deleted)
      if [ -f "$file" ]; then
        # Check for console.log presence
        if grep -q "console\.log" "$file" 2>/dev/null; then
          echo "[Hook] WARNING: console.log found in $file" >&2
          has_console=true
        fi
      fi
    done <<< "$modified_files"

    # Provide actionable guidance if any were found
    if [ "$has_console" = true ]; then
      echo "[Hook] Remove console.log statements before committing" >&2
    fi
  fi
fi

# Always pass through input
echo "$input"

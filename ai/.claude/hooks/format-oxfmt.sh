#!/bin/bash
# =============================================================================
# format-oxfmt.sh - PostToolUse hook
# Auto-formats JS/TS files with oxfmt after editing
#
# Why: Consistent formatting reduces noise in diffs and code review.
# Running oxfmt automatically after each edit ensures code is always
# formatted without manual intervention.
# =============================================================================

# Read the JSON input from Claude Code
input=$(cat)

# Extract the file path that was edited
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Only format if file exists (might have been a failed edit)
if [ -n "$file_path" ] && [ -f "$file_path" ]; then
  # Check if oxfmt is available
  if command -v oxfmt >/dev/null 2>&1; then
    # Run oxfmt in-place, limit output to avoid noise
    # --write: modify file in place
    # head -5: only show first 5 lines of output (usually just the filename)
    oxfmt "$file_path" 2>&1 | head -5 >&2
  fi
fi

# Always pass through input
echo "$input"

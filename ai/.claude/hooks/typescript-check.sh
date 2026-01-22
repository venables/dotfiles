#!/bin/bash
# =============================================================================
# typescript-check.sh - PostToolUse hook
# Runs TypeScript type checking after editing .ts/.tsx files
#
# Why: Catch type errors immediately after editing rather than waiting for
# the build step. This provides faster feedback and helps Claude fix issues
# while the context is fresh.
# =============================================================================

# Read the JSON input from Claude Code
input=$(cat)

# Extract the file path that was edited
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Only check if file exists
if [ -n "$file_path" ] && [ -f "$file_path" ]; then
  # Check if tsc (TypeScript compiler) is available
  if command -v tsc >/dev/null 2>&1; then
    # Run tsc on just this file
    # --noEmit: only type-check, don't generate output files
    # 2>&1: capture both stdout and stderr
    # head -20: limit output to avoid flooding the terminal
    tsc_output=$(tsc --noEmit "$file_path" 2>&1 | head -20)

    # Only show output if there are errors
    if [ -n "$tsc_output" ]; then
      echo "[Hook] TypeScript errors in $file_path:" >&2
      echo "$tsc_output" >&2
    fi
  fi
fi

# Always pass through input (don't block on type errors)
echo "$input"

#!/bin/bash
# =============================================================================
# block-doc-files.sh - PreToolUse hook
# Blocks creation of random .md/.txt documentation files
#
# Why: Claude tends to create lots of small documentation files that fragment
# knowledge. This hook enforces consolidation - docs should go in README.md,
# CLAUDE.md, AGENTS.md, or CONTRIBUTING.md rather than scattered files like
# "api-notes.md" or "implementation-details.txt".
#
# Note: The matcher in settings.json already excludes the allowed files,
# so this script only runs for files that should be blocked.
# =============================================================================

# Read the JSON input from Claude Code
input=$(cat)

# Extract the file path being written
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Block with helpful guidance
echo "BLOCK: Creating standalone doc file: $file_path" >&2
echo "Add this content to README.md or CLAUDE.md instead" >&2
exit 2  # Exit code 2 = block the tool use

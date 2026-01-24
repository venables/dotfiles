#!/usr/bin/env bash

declare -A formatters=(
  # JavaScript/TypeScript (oxfmt)
  ["ts"]="oxfmt"
  ["tsx"]="oxfmt"
  ["js"]="oxfmt"
  ["jsx"]="oxfmt"
  ["md"]="oxfmt"
  ["mdx"]="oxfmt"
  ["json"]="oxfmt"
  ["jsonc"]="oxfmt"
  ["yaml"]="oxfmt"
  ["yml"]="oxfmt"
  ["toml"]="oxfmt"
  ["html"]="oxfmt"
  ["css"]="oxfmt"
  # Python (add formatter when ready)
  # ["py"]="ruff format"
)

file_path=$(jq -r '.tool_input.file_path')
extension="${file_path##*.}"

# Run formatter if one exists for this extension
if [[ -n "${formatters[$extension]}" ]]; then
  ${formatters[$extension]} "$file_path"
fi

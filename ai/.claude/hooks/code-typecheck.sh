#!/usr/bin/env bash

declare -A typecheckers=(
  ["ts"]="tsc --noEmit"
  ["tsx"]="tsc --noEmit"
  # ["py"]="pyright"
)

file_path=$(jq -r '.tool_input.file_path')
extension="${file_path##*.}"

# Run typechecker if one exists for this extension
if [[ -n "${typecheckers[$extension]}" ]]; then
  ${typecheckers[$extension]} "$file_path"
fi

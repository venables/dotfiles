#!/usr/bin/env bash

tsc_extensions="ts tsx"
# pyright_extensions="py"

file_path=$(jq -r '.tool_input.file_path')
extension="${file_path##*.}"

if [[ " $tsc_extensions " == *" $extension "* ]]; then
  if [ -f "tsconfig.json" ]; then
    oxlint --type-aware --type-check .
  else
    oxlint --type-aware --type-check "$file_path"
  fi
# elif [[ " $pyright_extensions " == *" $extension "* ]]; then
#   pyright "$file_path"
fi

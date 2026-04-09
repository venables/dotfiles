#!/usr/bin/env bash

oxfmt_extensions="ts tsx js jsx md mdx json jsonc yaml yml toml html css"
# ruff_extensions="py"

file_path=$(jq -r '.tool_input.file_path')
extension="${file_path##*.}"

if [[ " $oxfmt_extensions " == *" $extension "* ]]; then
  oxfmt "$file_path"
# elif [[ " $ruff_extensions " == *" $extension "* ]]; then
#   ruff format "$file_path"
fi

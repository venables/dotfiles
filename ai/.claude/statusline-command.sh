#!/bin/bash

input=$(cat)

# Extract values
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
transcript=$(echo "$input" | jq -r '.transcript_path')
model_id=$(echo "$input" | jq -r '.model.id')

# Path with tilde
path=$(echo "$cwd" | sed "s|$HOME|~|g")

# Short model name
case "$model_id" in
  *opus-4*) model="opus-4.5" ;;
  *opus*) model="opus" ;;
  *sonnet-4*) model="sonnet-4.5" ;;
  *sonnet*) model="sonnet" ;;
  *haiku*) model="haiku" ;;
  *) model="$model_id" ;;
esac

# Git info
cd "$cwd" 2>/dev/null
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')
dirty=''
[ -n "$branch" ] && [ -n "$(git status --porcelain 2>/dev/null)" ] && dirty='*'

# Todo count from transcript
todo_count=0
[ -f "$transcript" ] && todo_count=$(grep -c '"type":"todo"' "$transcript" 2>/dev/null || echo 0)

# Time
time=$(date +%H:%M)

# Colors (RGB)
B=$'\033[38;2;30;102;245m'   # Blue - path
G=$'\033[38;2;64;160;43m'    # Green - branch
Y=$'\033[38;2;223;142;29m'   # Yellow - dirty, time
M=$'\033[38;2;136;57;239m'   # Magenta - context
C=$'\033[38;2;23;146;153m'   # Cyan - todos
T=$'\033[38;2;76;79;105m'    # Gray - model
R=$'\033[0m'                 # Reset

# Build output
printf "${B}${path}${R}"
[ -n "$branch" ] && printf ":${G}${branch}${Y}${dirty}${R}"
if [ -n "$remaining" ] && [ "$remaining" != "null" ]; then
  printf " ctx:${M}$((100 - remaining))%%${R}"
else
  printf " ctx:${M}0%%${R}"
fi
printf " ${T}${model}${R} ${Y}${time}${R}"
[ "$todo_count" -gt 0 ] 2>/dev/null && printf " todos:${C}${todo_count}${R}"

exit 0

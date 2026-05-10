#!/usr/bin/env bash
# git cleanup [target-branch] (default: main)
#
# Removes merged/squash-merged local branches and stale worktrees. Designed
# to keep going on individual failures rather than stopping at the first one.
#
# Squash-merge detection comes from https://github.com/not-an-aardvark/git-delete-squashed

target="${1:-main}"

is_merged_or_squashed() {
  local branch="$1" mergeBase tree synthetic
  if [ "$(git rev-list --count "$target..$branch" 2>/dev/null)" = "0" ]; then
    return 0
  fi
  mergeBase=$(git merge-base "$target" "$branch" 2>/dev/null) || return 1
  tree=$(git rev-parse "$branch^{tree}" 2>/dev/null) || return 1
  synthetic=$(git commit-tree "$tree" -p "$mergeBase" -m _ 2>/dev/null) || return 1
  [[ "$(git cherry "$target" "$synthetic")" == "-"* ]]
}

worktree_branches() {
  git worktree list --porcelain \
    | awk '/^branch refs\/heads\// { sub("refs/heads/", "", $2); print $2 }'
}

# git only protects the main worktree and dirty/locked linked worktrees from
# `git worktree remove` -- not the current linked worktree. Capture our path
# so we can skip ourselves and avoid running the rest of the script in a
# deleted CWD.
current_worktree=$(git rev-parse --show-toplevel)

# 1. Drop worktree admin records for working trees that no longer exist on disk.
git worktree prune -v

# 2. Remove worktrees whose branch is merged (or squash-merged) into target,
#    skipping the worktree we're running from. Dirty/locked worktrees are
#    refused by git itself, preserving in-progress work.
git worktree list --porcelain | awk '
  /^worktree / { path = substr($0, 10) }
  /^branch refs\/heads\// { sub("refs/heads/", "", $2); print path "\t" $2 }
' | while IFS=$'\t' read -r path branch; do
  [ "$branch" = "$target" ] && continue
  [ "$path" = "$current_worktree" ] && continue
  if is_merged_or_squashed "$branch"; then
    echo "Removing merged worktree: $path ($branch)"
    git worktree remove "$path" || echo "  could not remove $path"
  fi
done

# 3. Switch to target so we can delete the branch we were on. May fail if
#    target is already checked out in another worktree -- warn and continue.
git checkout -q "$target" \
  || echo "warn: could not switch to $target; some branches may not be deletable"

# 4. Delete merged / squash-merged local branches, skipping any branch that
#    is still checked out in a worktree. Cache the worktree-branch set once
#    so we're not re-shelling out to git per branch.
wt_branches=$(worktree_branches)
git for-each-ref --format='%(refname:short)' refs/heads/ | while read -r branch; do
  [ "$branch" = "$target" ] && continue
  printf '%s\n' "$wt_branches" | grep -Fxq "$branch" && continue
  is_merged_or_squashed "$branch" || continue
  git branch -D "$branch" || true
done

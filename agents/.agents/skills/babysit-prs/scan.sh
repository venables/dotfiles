#!/usr/bin/env bash
# scan.sh — read-only fleet scan for the babysit-prs skill.
#
# Emits one compact JSON digest of the author's open non-draft PRs so the coding
# agent spends tokens on fixes, not on data-gathering. Everything here is
# deterministic: enumerate PRs, roll up CI, extract just the error signature
# from failing-check logs, count unresolved human review threads, bucket each PR
# for routing, and recommend the next /loop delay. The script never commits,
# pushes, merges, or resolves anything — it only reads.
#
# Output (stdout, JSON):
#   {
#     "repo": "owner/name",
#     "anythingToDo": bool,            // any PR in an actionable bucket
#     "suggestedDelaySeconds": 270|1800,
#     "prs": [ {
#        "number", "title", "branch",
#        "mergeable", "mergeState", "reviewDecision",
#        "ci": { "passed", "failed", "pending", "failing": [ {name, link} ] },
#        "unresolvedThreads": int,     // non-author, unresolved, not-outdated (total)
#        "newThreads": int,            // of those, NOT yet in the seen-ledger
#        "standingGates": int,         // of those, already acked (silenced, unchanged)
#        "threads": [ {sig, threadId, path, line, lastAuthor, at} ],  // the unseen ones only
#        "newRootComments": int,       // unseen non-author, non-bot root (issue) comments
#        "standingRootGates": int,     // of those, already acked
#        "rootComments": [ {sig, author, at} ],  // the unseen root comments only
#        "failingLogs": [ {runId, excerpt} ],  // error signature only, capped
#        "bucket": "CONFLICTING|CI_FAIL|HAS_COMMENTS|BEHIND|CI_PENDING|GREEN_IDLE"
#     } ]
#   }
#
# Two comment channels are scanned: inline review threads (`threads`) and
# root-level PR conversation comments (`rootComments`) — the latter is where a
# reviewer drops a finding on a line outside the diff, which the inline-thread
# query never sees. Both feed HAS_COMMENTS.
#
# Seen-ledger: an inline thread's `sig` is "c"+<last-comment id> and a root
# comment's `sig` is "r"+<comment id>, so a reviewer reply (new id) mints a fresh
# sig and re-surfaces the item. mark-seen.sh (the only writer) records sigs the
# agent triaged to a no-further-action verdict; this scanner only READS the
# ledger to split new items from standing (acked) ones. HAS_COMMENTS fires on
# newThreads or newRootComments, so once every item is acked the PR goes quiet
# until one changes. Ledger lives at
# ${XDG_STATE_HOME:-$HOME/.local/state}/babysit-prs/<owner>-<name>.json.
#
# Usage:
#   scan.sh [--repo owner/name] [--author @me] [--no-logs]
#
# Notes:
# - No `set -e`: `gh pr checks` exits non-zero when a check is failing/pending
#   while still printing valid JSON to stdout. Aborting on that exit would drop
#   the data we want. We guard each call individually instead.
# - Log excerpts use the REST per-job logs endpoint
#   (`repos/{repo}/actions/jobs/{id}/logs`), NOT `gh run view --log-failed`:
#   gh refuses to download any log while the overall run is still in progress
#   (other jobs pending), even for a job that already failed. The REST endpoint
#   returns the finished job's log regardless. The full (often multi-thousand-
#   line) log is fetched here and reduced to a ~40-line error signature so it
#   never reaches the agent's context.
set -uo pipefail

REPO=""
AUTHOR="@me"
INCLUDE_LOGS=1
# Comma-separated logins to drop from root-level comments on top of the [bot]
# accounts already filtered. Defaults to catena's review bot (catenabot), which
# posts advisory panel reviews from a regular User account. Override, or clear
# with an empty value, via BABYSIT_PRS_IGNORE_LOGINS=foo,bar.
IGNORE_LOGINS="${BABYSIT_PRS_IGNORE_LOGINS-catenabot}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="${2:-}"; shift 2 ;;
    --author) AUTHOR="${2:-}"; shift 2 ;;
    --no-logs) INCLUDE_LOGS=0; shift ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "scan.sh: unknown arg: $1" >&2; exit 2 ;;
  esac
done

for bin in gh jq; do
  command -v "$bin" >/dev/null 2>&1 || { echo "scan.sh: need '$bin' on PATH" >&2; exit 1; }
done

if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)" || true
fi
[[ -z "$REPO" ]] && { echo "scan.sh: could not resolve repo slug (pass --repo owner/name)" >&2; exit 1; }
OWNER="${REPO%%/*}"
NAME="${REPO##*/}"

# The author's own login, so we can tell "awaiting the author" threads from
# threads whose last word came from a reviewer.
ME="$(gh api user -q .login 2>/dev/null)" || ME=""

# Seen-ledger (read-only here; mark-seen.sh is the only writer). A malformed or
# absent file degrades to an empty object so a corrupt ledger never blocks a
# sweep — at worst every thread reads as unseen and re-surfaces once.
LEDGER="${XDG_STATE_HOME:-$HOME/.local/state}/babysit-prs/${OWNER}-${NAME}.json"
ledger="$(cat "$LEDGER" 2>/dev/null)"
printf '%s' "$ledger" | jq -e 'type == "object"' >/dev/null 2>&1 || ledger="{}"

# Reduce a failing job's log to just its error signature, capped hard so a
# pathological log can't blow up the digest. Strip the leading ISO timestamp
# each runner line carries so the budget holds signal, not clock noise. Prefer
# error-ish lines; fall back to the tail, which usually carries the failing
# assertion or summary.
log_excerpt_for_job() {
  local job_id="$1" log excerpt
  log="$(gh api "repos/$REPO/actions/jobs/$job_id/logs" 2>/dev/null)" || true
  [[ -z "$log" ]] && return 0
  log="$(printf '%s\n' "$log" | sed -E 's/^[0-9]{4}-[0-9T:.-]+Z //')"
  excerpt="$(printf '%s\n' "$log" | grep -iE 'error|fail|✖|✗|exception|expected|assert|not found|undefined|panic' | tail -n 40)"
  [[ -z "$excerpt" ]] && excerpt="$(printf '%s\n' "$log" | tail -n 40)"
  printf '%s' "$excerpt" | head -c 2000
}

# Enumerate non-draft PRs. `gh pr list` returns isDraft so we filter here rather
# than trust a server-side flag that varies by gh version.
prs="$(gh pr list --author "$AUTHOR" --state open \
  --json number,title,headRefName,isDraft,mergeable,mergeStateStatus,reviewDecision \
  2>/dev/null | jq '[.[] | select(.isDraft == false)]')" || prs="[]"
[[ -z "$prs" ]] && prs="[]"

count="$(printf '%s' "$prs" | jq 'length')"
if [[ "$count" == "0" ]]; then
  jq -n --arg repo "$REPO" '{repo:$repo, anythingToDo:false, suggestedDelaySeconds:1800, prs:[]}'
  exit 0
fi

pr_objs=()
while IFS= read -r row; do
  num="$(printf '%s' "$row" | jq '.number')"
  title="$(printf '%s' "$row" | jq -r '.title')"
  branch="$(printf '%s' "$row" | jq -r '.headRefName')"
  mergeable="$(printf '%s' "$row" | jq -r '.mergeable')"
  mergestate="$(printf '%s' "$row" | jq -r '.mergeStateStatus')"
  reviewdec="$(printf '%s' "$row" | jq -r '.reviewDecision // ""')"

  # CI rollup. Keep stdout even on non-zero exit (failing/pending checks).
  checks="$(gh pr checks "$num" -R "$REPO" --json name,state,bucket,link 2>/dev/null)" || true
  [[ -z "$checks" ]] && checks="[]"
  ci="$(printf '%s' "$checks" | jq '{
    passed:  [.[] | select(.bucket=="pass")]    | length,
    failed:  [.[] | select(.bucket=="fail")]    | length,
    pending: [.[] | select(.bucket=="pending")] | length,
    failing: [.[] | select(.bucket=="fail") | {name, link}]
  }')"

  # Unresolved review threads whose last comment is from someone other than the
  # author. This is a routing signal only; triage-pr-comments does the precise
  # Fix/Dismiss filtering (bots, already-replied, etc.) once the agent acts.
  threads="$(gh api graphql --paginate \
    -f query='
      query($owner: String!, $repo: String!, $pr: Int!, $endCursor: String) {
        repository(owner: $owner, name: $repo) {
          pullRequest(number: $pr) {
            reviewThreads(first: 100, after: $endCursor) {
              pageInfo { hasNextPage endCursor }
              nodes {
                id
                isResolved
                isOutdated
                path
                line
                comments(first: 100) {
                  nodes { databaseId author { login } createdAt }
                }
              }
            }
          }
        }
      }
    ' -f owner="$OWNER" -f repo="$NAME" -F pr="$num" 2>/dev/null \
    | jq -s '[.[].data.repository.pullRequest.reviewThreads.nodes[]?]')" || threads="[]"
  [[ -z "$threads" ]] && threads="[]"

  # One object per non-author, unresolved, not-outdated thread, tagged with its
  # seen-ledger signature ("c"+last-comment id) and whether that sig is acked.
  threads_full="$(printf '%s' "$threads" | jq --arg me "$ME" --argjson ledger "$ledger" '
    [ .[]
      | select(.isResolved == false and .isOutdated == false)
      | (.comments.nodes | last) as $last
      | select($last != null and $last.databaseId != null and $last.author.login != $me)
      | ("c" + ($last.databaseId | tostring)) as $sig
      | { sig: $sig, threadId: .id, path: .path, line: .line,
          lastAuthor: $last.author.login, at: $last.createdAt,
          seen: ($ledger | has($sig)) }
    ]')"
  unresolved="$(printf '%s' "$threads_full" | jq 'length')"
  newcount="$(printf '%s' "$threads_full" | jq '[.[] | select(.seen == false)] | length')"
  standing="$(printf '%s' "$threads_full" | jq '[.[] | select(.seen == true)] | length')"
  newthreads="$(printf '%s' "$threads_full" | jq '[.[] | select(.seen == false) | del(.seen)]')"

  # Root-level (issue) comments on the PR conversation — reviewer feedback posted
  # to the thread rather than inline (e.g. a finding on a line outside the diff).
  # The reviewThreads query above never sees these, so without this channel a
  # human comment here is silently missed. Drop the author's own comments, [bot]
  # accounts, and any login in IGNORE_LOGINS; tag the rest with a seen-ledger sig
  # ("r"+comment id) and split new vs already-acked, mirroring threads. Bodies are
  # omitted on purpose — the agent fetches them for just the unseen ids.
  root_raw="$(gh api --paginate "repos/$REPO/issues/$num/comments" 2>/dev/null \
    | jq -s '[.[][]?]')" || root_raw="[]"
  [[ -z "$root_raw" ]] && root_raw="[]"
  root_full="$(printf '%s' "$root_raw" | jq \
    --arg me "$ME" --argjson ledger "$ledger" --arg ignore "$IGNORE_LOGINS" '
    ($ignore | split(",") | map(select(. != ""))) as $ignored
    | [ .[]
        | (.user.login // "") as $login
        | select($login != $me
                 and ((.user.type // "") != "Bot")
                 and (($ignored | index($login)) | not))
        | ("r" + (.id | tostring)) as $sig
        | { sig: $sig, author: $login, at: .created_at,
            seen: ($ledger | has($sig)) }
      ]')"
  [[ -z "$root_full" ]] && root_full="[]"
  rootnewcount="$(printf '%s' "$root_full" | jq '[.[] | select(.seen == false)] | length')"
  rootstanding="$(printf '%s' "$root_full" | jq '[.[] | select(.seen == true)] | length')"
  rootnew="$(printf '%s' "$root_full" | jq '[.[] | select(.seen == false) | del(.seen)]')"

  # Error signatures for failing checks, deduped by job and capped at 3 jobs.
  logs="[]"
  if [[ "$INCLUDE_LOGS" == "1" ]]; then
    log_objs=()
    seen_jobs=" "
    while IFS= read -r entry; do
      [[ ${#log_objs[@]} -ge 3 ]] && break
      [[ -z "$entry" ]] && continue
      fname="$(printf '%s' "$entry" | jq -r '.name')"
      jid="$(printf '%s' "$entry" | jq -r '.link' | sed -nE 's#.*/job/([0-9]+).*#\1#p')"
      [[ -z "$jid" ]] && continue
      [[ "$seen_jobs" == *" $jid "* ]] && continue
      seen_jobs="$seen_jobs$jid "
      ex="$(log_excerpt_for_job "$jid")"
      [[ -z "$ex" ]] && continue
      log_objs+=("$(jq -n --arg check "$fname" --arg jid "$jid" --arg ex "$ex" \
        '{check:$check, jobId:$jid, excerpt:$ex}')")
    done < <(printf '%s' "$ci" | jq -c '.failing[]?')
    [[ ${#log_objs[@]} -gt 0 ]] && logs="$(printf '%s\n' "${log_objs[@]}" | jq -s '.')"
  fi

  # Bucket by highest-priority actionable condition. Raw fields stay in the
  # object so the agent sees the full picture; the bucket is only the hint.
  failed="$(printf '%s' "$ci" | jq '.failed')"
  pending="$(printf '%s' "$ci" | jq '.pending')"
  if [[ "$mergeable" == "CONFLICTING" || "$mergestate" == "DIRTY" ]]; then
    bucket="CONFLICTING"
  elif [[ "$failed" -gt 0 ]]; then
    bucket="CI_FAIL"
  elif [[ "$newcount" -gt 0 || "$rootnewcount" -gt 0 ]]; then
    bucket="HAS_COMMENTS"
  elif [[ "$mergestate" == "BEHIND" ]]; then
    bucket="BEHIND"
  elif [[ "$pending" -gt 0 ]]; then
    bucket="CI_PENDING"
  else
    bucket="GREEN_IDLE"
  fi

  pr_objs+=("$(jq -n \
    --argjson number "$num" \
    --arg title "$title" \
    --arg branch "$branch" \
    --arg mergeable "$mergeable" \
    --arg mergeState "$mergestate" \
    --arg reviewDecision "$reviewdec" \
    --argjson ci "$ci" \
    --argjson unresolvedThreads "$unresolved" \
    --argjson newThreads "$newcount" \
    --argjson standingGates "$standing" \
    --argjson threads "$newthreads" \
    --argjson newRootComments "$rootnewcount" \
    --argjson standingRootGates "$rootstanding" \
    --argjson rootComments "$rootnew" \
    --argjson failingLogs "$logs" \
    --arg bucket "$bucket" \
    '{number:$number, title:$title, branch:$branch,
      mergeable:$mergeable, mergeState:$mergeState, reviewDecision:$reviewDecision,
      ci:$ci, unresolvedThreads:$unresolvedThreads, newThreads:$newThreads,
      standingGates:$standingGates, threads:$threads,
      newRootComments:$newRootComments, standingRootGates:$standingRootGates,
      rootComments:$rootComments, failingLogs:$failingLogs,
      bucket:$bucket}')")
done < <(printf '%s' "$prs" | jq -c '.[]')

printf '%s\n' "${pr_objs[@]}" | jq -s --arg repo "$REPO" '
  { actionable: ["CONFLICTING","CI_FAIL","HAS_COMMENTS","BEHIND"],
    busy:       ["CONFLICTING","CI_FAIL","HAS_COMMENTS","BEHIND","CI_PENDING"] } as $sets
  | { repo: $repo,
      anythingToDo: (any(.[].bucket; . as $b | $sets.actionable | index($b))),
      suggestedDelaySeconds: (if any(.[].bucket; . as $b | $sets.busy | index($b)) then 270 else 1800 end),
      prs: . }'

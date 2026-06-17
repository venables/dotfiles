#!/usr/bin/env bash
# mark-seen.sh — the babysit-prs seen-ledger writer (the ONLY writer).
#
# Records review-thread signatures the agent has triaged to a no-further-action
# verdict (human-review gate, won't-fix, deferred-to-user, handled-elsewhere) so
# scan.sh stops re-surfacing them. The signature is "c"+<last-comment id>, so a
# later reviewer reply mints a new sig and the thread re-surfaces on its own — an
# ack silences the thread as it stands now, not forever.
#
# Pass sigs straight from scan.sh's per-PR `threads[].sig`; never hand-compute
# them. Threads you intend to FIX should NOT be acked — leave them so they keep
# surfacing until your fix lands and the thread resolves on GitHub.
#
# Usage:
#   mark-seen.sh [--repo owner/name] [--verdict TAG] [--note "text"] <sig> [<sig> ...]
#   printf 'c123 c456\n' | mark-seen.sh --verdict human-gate
#
# Ledger: ${XDG_STATE_HOME:-$HOME/.local/state}/babysit-prs/<owner>-<name>.json
#   { "<sig>": { "verdict": "...", "note": "...", "markedAt": "<ISO8601>" } }
set -uo pipefail

REPO=""
VERDICT=""
NOTE=""
sigs=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO="${2:-}"; shift 2 ;;
    --verdict) VERDICT="${2:-}"; shift 2 ;;
    --note) NOTE="${2:-}"; shift 2 ;;
    -h|--help) sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    --) shift; while [[ $# -gt 0 ]]; do sigs+=("$1"); shift; done ;;
    -*) echo "mark-seen.sh: unknown arg: $1" >&2; exit 2 ;;
    *) sigs+=("$1"); shift ;;
  esac
done

for bin in gh jq; do
  command -v "$bin" >/dev/null 2>&1 || { echo "mark-seen.sh: need '$bin' on PATH" >&2; exit 1; }
done

# Accept whitespace-separated sigs on stdin when none were passed as args.
if [[ ${#sigs[@]} -eq 0 && ! -t 0 ]]; then
  while IFS= read -r line; do
    for tok in $line; do sigs+=("$tok"); done
  done
fi
[[ ${#sigs[@]} -eq 0 ]] && { echo "mark-seen.sh: no sigs given (pass as args or on stdin)" >&2; exit 2; }

if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)" || true
fi
[[ -z "$REPO" ]] && { echo "mark-seen.sh: could not resolve repo slug (pass --repo owner/name)" >&2; exit 1; }
OWNER="${REPO%%/*}"
NAME="${REPO##*/}"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/babysit-prs"
LEDGER="$STATE_DIR/${OWNER}-${NAME}.json"
mkdir -p "$STATE_DIR"

# Degrade a missing/corrupt ledger to {} rather than clobber-then-fail.
ledger="$(cat "$LEDGER" 2>/dev/null)"
printf '%s' "$ledger" | jq -e 'type == "object"' >/dev/null 2>&1 || ledger="{}"

now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
sigs_json="$(printf '%s\n' "${sigs[@]}" | jq -R . | jq -s 'unique')"

updated="$(printf '%s' "$ledger" | jq \
  --argjson sigs "$sigs_json" \
  --arg verdict "$VERDICT" \
  --arg note "$NOTE" \
  --arg now "$now" '
  reduce $sigs[] as $s (.; .[$s] = {verdict: $verdict, note: $note, markedAt: $now})')"

# Same-dir temp + mv so the write is atomic (no torn ledger on crash).
tmp="$(mktemp "$STATE_DIR/.ledger.XXXXXX")"
printf '%s\n' "$updated" > "$tmp" && mv "$tmp" "$LEDGER"
echo "mark-seen.sh: recorded $(printf '%s' "$sigs_json" | jq 'length') sig(s) in $LEDGER" >&2

---
name: babysit-prs
description:
  Use when asked to babysit, sweep, watch, or maintain all open PRs in a repo
  (keep them mergeable, CI green, review comments handled), especially as the
  body of a /loop or recurring schedule.
---

# Babysit PRs

One invocation = one fleet-wide sweep of the user's open **non-draft** PRs.
Designed to be driven by `/loop /babysit-prs` (dynamic mode). Do NOT invoke
/monitor-pr from inside this skill: it is its own single-PR loop and the two
schedulers will fight over the session's single wakeup.

## Scan first (one read-only command)

Start every sweep with the bundled scanner. It does all the deterministic
data-gathering so you spend tokens on fixes, not on fetching and parsing:

```bash
skills/babysit-prs/scan.sh        # add --no-logs to skip CI log excerpts; --repo owner/name to override
```

It resolves the repo slug, enumerates the author's open **non-draft** PRs, and
emits one compact JSON digest:

```jsonc
{
  "repo": "owner/name",
  "anythingToDo": false,            // false => nothing actionable this tick
  "suggestedDelaySeconds": 1800,    // feed straight to the /loop driver
  "prs": [{
    "number", "title", "branch",
    "mergeable", "mergeState", "reviewDecision",
    "ci": { "passed", "failed", "pending", "failing": [{ "name", "link" }] },
    "unresolvedThreads": 0,         // non-author, unresolved, not-outdated (total)
    "newThreads": 0,                // of those, NOT yet acked in the seen-ledger
    "standingGates": 0,             // of those, already acked (silenced, unchanged)
    "threads": [{ "sig", "threadId", "path", "line", "lastAuthor", "at" }],  // the unseen inline ones only
    "newRootComments": 0,           // unseen non-author, non-bot root (issue) comments
    "standingRootGates": 0,         // of those, already acked
    "rootComments": [{ "sig", "author", "at" }],  // the unseen root comments only
    "failingLogs": [{ "check", "jobId", "excerpt" }],  // ~40-line error signature only
    "bucket": "CONFLICTING | CI_FAIL | HAS_COMMENTS | BEHIND | CI_PENDING | GREEN_IDLE"
  }]
}
```

The scanner is **strictly read-only**: it gathers and buckets, never commits,
pushes, merges, or resolves. If `anythingToDo` is false, there is nothing to do
this tick — report and sleep `suggestedDelaySeconds`. Otherwise act only on PRs
whose `bucket` is not `GREEN_IDLE`/`CI_PENDING`, routed by the per-PR checks
below. The bucket is a routing hint built from the raw fields, which stay in the
object; trust your judgment over the label when they disagree.

**Seen-ledger.** `HAS_COMMENTS` fires on `newThreads` (threads not yet acked),
not on total `unresolvedThreads`, so a comment you have already triaged and
acked never re-surfaces — that is the whole point of the split. `threads`
carries only the **unseen** ones (no bodies; fetch those yourself for just
these), each tagged with the GraphQL `threadId` you need to resolve it (check
3). Each thread's `sig` is `"c"+<last-comment id>`, so a later reviewer reply
mints a new sig and the thread re-surfaces on its own. The scanner reads **two**
comment channels: inline review `threads` and root-level PR conversation
comments (`rootComments`) — the latter is where a reviewer drops a finding on a
line outside the diff, which the inline-thread query never sees. `rootComments`
behaves exactly like `threads` (sig `"r"+<comment id>`, unseen-only, no bodies),
drives `HAS_COMMENTS` via `newRootComments`, and counts acked ones in
`standingRootGates`. Author comments, `[bot]` accounts, and (by default)
catena's review bot `catenabot` are filtered out; adjust the extra-login filter
via `BABYSIT_PRS_IGNORE_LOGINS=foo,bar` (set it empty to clear). `standingGates`
is a cheap count of already-acked threads still open on the PR: mention it in
the report as a one-liner (`#957: 3 known gates, unchanged`) but it is **not**
actionable and does not make the PR busy. You ack threads with `mark-seen.sh`
(see check 3); it is the ledger's only writer.

| bucket         | route to                                            |
| -------------- | --------------------------------------------------- |
| `CONFLICTING`  | Per-PR check 1 (freshness / conflict resolution)    |
| `CI_FAIL`      | Per-PR check 2 (read `failingLogs[].excerpt` first) |
| `HAS_COMMENTS` | Per-PR check 3 (triage `threads` + `rootComments`)  |
| `BEHIND`       | Per-PR check 1 (up-to-date gate)                    |
| `CI_PENDING`   | nothing — checks still running, recheck next tick   |
| `GREEN_IDLE`   | nothing                                             |

- **Drafts are out of scope entirely**: the scanner already excludes them. No
  conflict resolution, no CI fixes, no comment triage, even if
  DIRTY/CONFLICTING. Mention them in the report only.

## Per-PR checks (in order)

1. **Freshness.** Update the branch only when it _needs_ it: merge conflicts
   with main, branch protection requiring up-to-date, or CI that must re-run
   against new main. Merely-behind-but-green PRs are left alone (no churn). To
   update: `git merge origin/main` into the branch and resolve conflicts
   semantically. **Never rebase or force-push a non-draft PR** — reviewers lose
   their place and inline comments detach. If a conflict resolution requires
   choosing between two divergent intents, stop and ask the user instead of
   guessing.
2. **CI.** Read the digest's `failingLogs[].excerpt` first — it is the failing
   job's error signature, so you rarely need to pull the full log. Fix
   mechanical failures (lint, format, unused import, trivially broken test) as
   appended commits. Non-mechanical failures (logic, flaky infra, anything
   touching auth/money/schema): report and ask. Classifying mechanical-vs-not is
   your call, not the scanner's.
3. **Comments.** Work the **unseen** items from both channels: the `threads`
   array (inline review) and the `rootComments` array (root-level PR
   conversation). Fetch bodies for just those — inline via
   `gh api repos/<owner>/<name>/pulls/comments/<id>` (id = the `sig` minus its
   `c` prefix), root via `gh api repos/<owner>/<name>/issues/comments/<id>` (id
   = the `sig` minus its `r` prefix).

   **REQUIRED SUB-SKILL: triage-pr-comments.** It owns the whole comment engine
   — the analysis (understand → assess → verdict) **and** the reply/resolve
   mechanics. Its Step 5 ("Reply and resolve") is written as a mode-agnostic
   entry point you drive non-interactively, so **do not re-derive the `gh` /
   `jq` / `resolveReviewThread` commands, the read-back verification, or the
   push→reply→resolve failure ordering here** — run that procedure. Apply its
   simple Fix verdicts; for complicated ones (redesigns, scope changes, judgment
   calls, anything touching auth/money/schema) stop and ask the user via
   AskUserQuestion with a concrete recommendation instead of applying.

   When a comment is handled, **reply and resolve via triage-pr-comments' Step 5
   procedure**, with these babysit deltas:
   - **Reply-approval gate.** Bot replies post autonomously; a reply to a human
     reviewer is drafted and shown to the user (AskUserQuestion) before posting.
   - **Thread id.** Pass the `threadId` the scanner already put on each inline
     thread to `resolveReviewThread` — no need to re-query it.
   - **What retires an item, and the ledger.** Resolving an inline thread
     retires it (the scanner filters `isResolved`), so do **not** also ack it. A
     **root** comment has no thread to resolve, so after replying, **ack** it in
     the ledger (below). If `resolveReviewThread` fails, ack the inline `sig` as
     a fallback so the loop doesn't re-handle a landed fix.
   - **On failure.** triage's Step 5 ordering applies (a failed push aborts that
     PR's replies and resolves). Surface any reply/resolve failures in the tick
     report and move to the next PR; never report a comment as handled while its
     reply or resolve is still outstanding.

   For items needing **no agent action** (human-review gate, won't-fix, deferred
   to the user), reply only if you have something useful to say, then **ack**
   the thread so it stops re-surfacing — pass its `sig` from the digest, never
   hand-computed:

   ```bash
   skills/babysit-prs/mark-seen.sh --verdict human-gate <sig> [<sig> ...]
   ```

   Use a `--verdict` tag: `human-gate`, `wontfix`, `deferred`, or `handled` for
   no-action acks, or `fixed` for the root-comment / resolve-failed fallback
   above. **Do NOT** pre-ack a thread before its fix lands — for inline fixes,
   reply + resolve retires it; the ledger is only for items GitHub won't resolve
   for you (no-action gates and replied-to root comments).

## Mechanics

- `git fetch origin` — never `git fetch origin <branch>` (stale refs in
  bare-repo/worktree setups).
- Do per-PR work in a temp worktree (`git worktree add`), remove it after
  pushing. Delegate per-PR depth to subagents; the sweep itself stays cheap.
- Verify before any push: the repo's own gate (its lint / format / typecheck
  command, e.g. `pnpm run check`) plus tests scoped to changed files. Isolate
  the test database name per branch to avoid shared test-DB pollution.
- Pushes are plain `git push` (appends only).
- The seen-ledger lives at
  `${XDG_STATE_HOME:-$HOME/.local/state}/babysit-prs/<owner>-<name>.json` and is
  written **only** by `mark-seen.sh`. `scan.sh` reads it; nothing else touches
  it. Keyed by last-comment id, so it never hides a thread a reviewer has since
  replied to.

## Pacing and model (when driven by /loop)

- The /loop driver owns cadence. Use the scanner's `suggestedDelaySeconds`
  (1800s when nothing is actionable or pending, 270s when anything is in
  flight); override to ~270s on any tick where you just pushed and are waiting
  on CI.
- Inherit the session model; never pin one. Subagents doing conflict resolution
  should inherit too (it is judgment work, not grunt work).

## Stop-and-ask triggers

- Reviewer asks for a design/architecture change
- Conflict resolution with genuinely divergent semantics
- Anything that would rewrite history on a non-draft PR
- CI failure whose fix touches auth, money movement, or schema

## Common mistakes

| Mistake                                     | Reality                                                                                                                        |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Sweeping drafts in "while I'm at it"        | Drafts are the author's WIP; report only                                                                                       |
| Rebase + force-with-lease on an approved PR | Ready PRs get merge commits or appended fixes                                                                                  |
| Updating every behind-main branch           | No-conflict, green, no up-to-date gate = leave it                                                                              |
| Calling /monitor-pr per PR                  | Nested loops fight over scheduling; inline the checks                                                                          |
| Replying to a human reviewer autonomously   | Draft + user approval first                                                                                                    |
| Re-fetching PR/CI/thread state by hand      | The scanner already gathered it; read the digest                                                                               |
| Re-triaging the same gate every tick        | Ack no-action threads with `mark-seen.sh`; `newThreads` drives `HAS_COMMENTS`                                                  |
| Acking a fixed inline thread in the ledger  | Push, reply, then `resolveReviewThread` — that retires it; the ledger is only for no-action gates and replied-to root comments |
| Replying to a fix but not retiring it       | Inline: reply **and** resolve. Root: reply **and** ack (no thread to resolve)                                                  |
| Pulling a full CI log to read one error     | `failingLogs[].excerpt` is the error signature                                                                                 |

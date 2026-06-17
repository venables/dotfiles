# babysit-prs

Keep all of your open **non-draft** PRs healthy on a recurring sweep: branches
mergeable, CI green, and review comments triaged. One invocation is one
fleet-wide pass — it starts with a single read-only scan, acts only on the PRs
that actually need something, and otherwise reports and sleeps.

## Install

```bash
npx skills add catena-labs/dev-skills --skill babysit-prs
```

## How to use it

This skill is built to run on a loop. Hand it to `/loop` and let it pace itself:

```
/loop /babysit-prs
```

`/loop` with no interval runs in **dynamic mode** — after each sweep the skill
tells the loop how long to wait (≈30 min when nothing is in flight, ≈4.5 min
when a push is waiting on CI), so it polls tightly only when there's live work.
You can also kick off a single one-off sweep by just asking:

- "babysit my PRs"
- "sweep my open PRs"
- "/babysit-prs"

It needs the `gh` CLI authenticated, plus `jq`, and assumes you're inside the
target git repo (or pass `--repo owner/name` to the scanner).

> Run it as `/loop /babysit-prs`, not by nesting `/monitor-pr` inside it —
> `/monitor-pr` is its own single-PR loop, and two schedulers will fight over
> the session's one wakeup.

## What it does

- **Scans once, read-only, before doing anything.** The bundled `scan.sh`
  enumerates your open non-draft PRs and emits one compact JSON digest — per-PR
  mergeability, a CI rollup, a ~40-line error signature for each failing check,
  and the unresolved human review threads — so the agent spends tokens on fixes,
  not on fetching and parsing. The scanner never commits, pushes, merges, or
  resolves.
- **Routes each PR by bucket.** `CONFLICTING` / `BEHIND` → freshness, `CI_FAIL`
  → read the failing-log excerpt and fix, `HAS_COMMENTS` → triage. `GREEN_IDLE`
  and `CI_PENDING` PRs are left alone. If nothing is actionable, it reports and
  sleeps the suggested delay.
- **Fixes freshness without rewriting history.** Updates a branch only when it
  truly needs it (real conflicts, an up-to-date branch-protection gate, or CI
  that must re-run against new main) via a merge commit — **never** a rebase or
  force-push on a non-draft PR, so reviewers keep their place and inline
  comments stay attached.
- **Fixes only mechanical CI failures autonomously.** Lint, format, unused
  imports, trivially broken tests get appended fix commits. Anything
  non-mechanical — logic, flaky infra, or a fix touching auth, money movement,
  or schema — is reported and handed back to you.
- **Triages review comments, then replies and resolves.** New reviewer threads —
  both inline and root-level — are run through the `triage-pr-comments`
  sub-skill, which owns the whole comment engine: the analysis _and_ the
  reply/resolve mechanics (its "Reply and resolve" step is a mode-agnostic entry
  point babysit drives non-interactively). When a comment leads to a fix, that
  engine pushes the fix, posts a concise reply describing it, and **resolves**
  the inline thread on GitHub (root-level comments get a reply and a ledger ack,
  since GitHub can't resolve them). Threads you've deliberately left as standing
  gates are acked in a local seen-ledger via `mark-seen.sh` so they stop
  re-surfacing every tick; a later reviewer reply mints a fresh signature and
  the thread comes back on its own. Replies to a human reviewer are still
  drafted for your approval first.
- **Stops and asks at the right moments.** Design/architecture change requests,
  conflicts with genuinely divergent intent, anything that would rewrite history
  on a non-draft PR, and CI fixes touching auth/money/schema all pause for you —
  and it never posts a reply to a human reviewer without showing you a draft
  first.

## Gotchas

- **Drafts are out of scope entirely.** The scanner excludes them; the sweep
  mentions them in the report but never touches them — they're your WIP.
- **It needs `gh` and `jq` on PATH**, and `gh` authenticated against the repo.
- **The seen-ledger is local state**, at
  `${XDG_STATE_HOME:-$HOME/.local/state}/babysit-prs/<owner>-<name>.json`,
  written only by `mark-seen.sh`. Deleting it just means every still-open thread
  re-surfaces once.

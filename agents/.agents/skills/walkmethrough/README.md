# walkmethrough

Interactive manual-QA walkthrough of the current branch versus `main` (including
uncommitted, staged, and untracked changes). Discovers what changed, groups it
into behaviour units, proposes a numbered test plan, then walks you through each
step — you run the actions, the agent watches the dev server logs and queries
the local database itself to verify each result before moving on.

## Install

```bash
npx skills add catena-labs/dev-skills --skill walkmethrough
```

## How to use it

Just ask Claude Code in plain English:

- "walk me through testing this branch"
- "manually test my changes"
- "step-by-step QA this branch"
- "/walkmethrough"

## What it does

- **Stands up its own observation posts first.** It boots the full-stack dev
  server in a background shell and opens a direct connection to the local
  database — verifying it's the _same_ DB the running app writes to, not a stale
  instance on another port — before any test step runs.
- **Checks which external gateways are live before planning.** It reads the
  resolved `.env` for gateway mode flags (e.g. `BRIDGE_LIVE`, `TURNKEY_LIVE`,
  and the project's other sandbox-vs-prod toggles) and classifies each gateway
  the diff touches. Live-gateway steps get a ⚠ marker, a stated blast radius,
  and a confirmation gate; sandbox steps run freely; unconfigured gateways
  become setup steps instead of mid-walkthrough failures.
- **Discovers the real change set.** Committed work on the branch plus
  uncommitted, staged, and untracked files, with derivative noise (lockfiles,
  codegen, formatter churn) filtered out.
- **Builds a numbered plan of behaviour units** — things a real user or operator
  does end-to-end — ordered setup-first, smallest scope first, negative paths
  next, multi-step flows last. You confirm or trim the plan before anything
  runs.
- **Walks one step at a time, with a hard pause.** Each step gives a goal, exact
  copy-paste commands, and the precise expected result. Then the agent stops and
  waits — no batching, no previewing the next step.
- **Verifies with its own eyes.** After you run a step, the agent reads the new
  dev-server log lines and runs the DB queries itself, quotes the evidence, and
  marks pass/fail. Your pasted output is the fallback, not the primary signal.
- **Asks before any DB mutation.** Resetting, seeding, or choosing between
  ambiguous local databases always stops for your confirmation.

## Gotchas

- **It needs a local dev environment** — a dev script in `package.json` (or
  equivalent) and a reachable local database. It detects ports from `.env` /
  compose files rather than assuming defaults.
- **Multiple local Postgres instances are handled, not assumed away.** The skill
  verifies app-writes land in the DB it queries before trusting any read. If
  verification fails it switches ports and re-checks.
- **It will not barrel past failures.** A failed step stops the walkthrough for
  diagnosis; you get a summary of what passed and what's likely wrong.
- **Teardown is automatic** — the background dev server it started is killed
  when the walkthrough ends or you stop it.

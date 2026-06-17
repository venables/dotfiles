---
name: walkmethrough
description: |
  Interactive manual-test walkthrough of the changes on the current branch
  versus `main` (including uncommitted, staged, and untracked changes).
  Discovers what changed, groups it into behaviour units, proposes a numbered
  test plan, then walks the user through each step — explaining what's about
  to happen, giving the exact command, waiting for them, and verifying the
  result before moving on.

  Use when the user says "walk me through testing", "manually test this
  branch", "step-by-step QA my changes", "/walkmethrough", or asks for an
  interactive manual test plan, especially when they want you to watch the dev
  server logs and the local database while they run each step. Generic across
  projects (monorepo or single app, any DB tooling, any framework).
---

# walkmethrough — interactive manual-QA for the current branch

You are walking the user through manually testing the changes on the current
branch versus `main`, including any uncommitted work. The user is at a terminal
and possibly a browser; you're the test conductor — explain each step, give them
the exact command, wait, then verify.

**You are not a passive prompt-printer. You run your own observation posts.**
Before the walkthrough you stand up a live view of the dev-server logs and a
direct connection to the local database (Phase 0). When the user runs a step,
_they_ trigger the action but _you_ confirm the side effects yourself: read the
new log lines, query the DB, and report what you actually observed. The user
pasting output is a fallback, not the primary signal — the point of this skill
is that you watch the system react in real time.

This skill is interactive by design. **Do not batch-run all the steps.** Pause
between every step and wait for the user to confirm before moving on.

## Hard pause rule (read carefully)

After you present a step, **stop emitting output entirely.** Do not preview the
next step, do not re-explain, do not summarise progress. End your turn and wait.
The user must reply with output, a pass/fail, "skip", or "stop" before you
produce another character.

Concretely, after presenting step N you have produced exactly:

1. Step header (`Step N/M: <goal>`)
2. One- to two-sentence explanation
3. The action block (commands or click path)
4. The expected-result block (including **what I'll be watching for** in the
   logs / DB)
5. The literal pause prompt: "Run this and tell me when it's done — I'll read
   the logs and query the DB myself. (Paste anything I can't see from here.)"

Then you stop. Step N+1 does not exist in your output until the user has replied
to step N. Treat this as a stop condition, identical to a tool result you must
observe before continuing. When the user replies, your FIRST act is to pull your
observation posts (BashOutput on the log tail, a DB query) — not to print the
next step.

If you find yourself thinking "the next step is obvious, I'll just queue it up"
— that is the rule violation. Stop. The whole point of this skill is the beat
between steps; without it, you've reduced the skill to "print a test plan",
which the user could have asked for instead.

## Phase 0 — Stand up observation posts

Before discovering the diff, set up the two things you'll watch all session.
**You own these processes** — the user runs test actions, you keep the eyes on
the system. Do this once, up front, and confirm both are live before Phase 1.

**By default, YOU start the dev server yourself** in a backgrounded shell — do
not ask the user to run it or wait for them to. Booting it is the first thing
you do in Phase 0. Only fall back to the user owning the server (see below) if
they say they already have one running or explicitly want to.

**Default to the full-stack dev command that also serves the web UI** — e.g.
`pnpm dev` at the repo root, NOT a backend-only script like `pnpm dev:server`.
Most walkthroughs involve onboarding or console steps that need the UI; the
combined output still carries the backend (api/worker) logs you watch. Only drop
to the API-only dev script when you're certain no UI/console step is involved.

**1. Dev-server log stream.** Detect the start command and port:

- Find the dev script in `package.json` (or the project's runner): often `dev`,
  `dev:server`, `start`. In a monorepo prefer the root `dev` that brings up the
  whole stack (web UI + api + worker) so console/onboarding steps work; its
  combined output still includes the backend logs you watch. Reach for a
  backend-only script only when no UI step is involved.
- Find the port and any health route from `.env` / config (e.g. `PORT`).
- Start it in a **backgrounded shell** (`run_in_background: true`), e.g.
  `pnpm run dev`. Keep the returned shell id. Read its output with `BashOutput`
  between steps; that is your live log tail.
- Wait until it's actually serving before continuing — poll the health route
  (`curl -s localhost:<port>/<health>`) or watch `BashOutput` for the "listening
  on" line. If it crashes on boot, that's your first finding — surface it.

If the user would rather own the server in their own terminal, fall back to
having them launch it as `<dev cmd> 2>&1 | tee /tmp/<proj>-dev.log` and you
`tail -f` that file in a background shell instead. Either way you end up with a
log stream you can pull on demand.

**2. Direct database connection — connect to the SAME live DB the running app
uses, not a guess.** Getting this wrong silently invalidates the whole
walkthrough: you query one Postgres while the app writes to another, and every
"I checked the DB" reads stale or empty. Pin the port the live dev server is
actually using, in this order:

- **Resolve the app's real `DATABASE_URL` / `POSTGRES_PORT`.** Read `.env`, but
  do not trust the literal value — `.env` is often a **symlink to a parent or
  sibling repo's `.env`** (e.g. `apps/api/.env -> ../../../.env`), so the port
  you read may belong to a different checkout. Resolve it first
  (`readlink -f .env`) and prefer the worktree's own root `.env`. Compose files
  commonly bind `${POSTGRES_PORT:-5432}`, so the live port is whatever
  `POSTGRES_PORT` expands to at run time — **not necessarily 5432.** The local
  creds are not secrets (dev DB on localhost); if a classifier blocks `.env`,
  derive the port from `docker-compose.yml` `ports:`, `db:*` scripts, or ask.
- **Assume there may be MORE THAN ONE local Postgres.** It is common to have two
  instances listening (e.g. `:5432` AND `:5433`), each with its own `catena`
  database and totally different data — one current, one stale from an old setup
  or another worktree. List them
  (`lsof -nP -iTCP -sTCP:LISTEN | grep -i postgres`) so you know what's out
  there. Never assume the default port is the live one.
- **VERIFY you're on the app's DB before trusting any read — do not skip this.**
  The proof is a write the app makes landing in the DB you query. Ask the user
  to do one tiny app action (create an account, rename something), then confirm
  that exact row appears at your port. If it doesn't show up where you're
  querying, you're on the wrong DB: switch ports and re-verify. The app writing
  org/account rows you can see at `:<port>` is the only reliable confirmation
  that app-writes and your-reads share a database.
- Confirm you can reach it: `psql "<DATABASE_URL>" -c '\dt'` (or the project's
  client — `prisma`, `drizzle-kit`, `sqlite3`). If the DB isn't up, that's a
  setup step (`docker compose up`, `pnpm run db:up`) — do it now. Note that ORM
  / auth libraries may put tables in a non-`public` schema (e.g. a `auth`
  schema) — list schemas before concluding a table is "missing".
- Apply pending migrations now if the diff includes any (`pnpm run db:migrate`
  or equivalent) so the schema matches the branch before you test against it. A
  migrate that fails with `corrupted migrations: <name> is missing` means the
  live DB is on a divergent migration line from this branch — surface it, don't
  paper over it.

**3. Gateway live-mode check — know what's real before anything runs.** While
you have the resolved `.env` open, read the external-gateway mode flags — e.g.
`BRIDGE_LIVE`, `TURNKEY_LIVE`, and any other `*_LIVE` / `*_ENV=production` /
sandbox-vs-prod toggles for the payment, signing, KYC, email, or other
third-party gateways this project talks to (grep the config-loading code for the
full set rather than guessing). For each gateway the diff touches, classify it:

- **Live** — steps through this gateway create real external state (real
  customers, real transfers, real signers, real emails). These steps are
  production-touching: mark them in the plan, prefer read-only or
  simulator-based verification, and require explicit user confirmation before
  each one. If a live gateway isn't actually needed to test the diff, propose
  skipping those steps or flipping the flag to sandbox for the session.
- **Sandbox / test mode** — safe to exercise freely; say so.
- **Unset / unconfigured** — if a step needs it, that's a setup step (or the
  step gets cut); surface it rather than letting the step fail mid-walkthrough.

This classification shapes the whole plan: which steps are safe to run, which
need a confirmation gate, and which should swap to a simulator. Do it now, not
when a step is already hitting a real API.

**Ask first before any DB mutation or ambiguous-DB choice — this is
non-negotiable and users value it.** Resetting, dropping, seeding, repointing,
or hand-editing the live dev DB destroys real local state. When you hit a fork
the user owns — which of several Postgres instances is canonical, whether to
`db:reset` a divergent DB, whether to seed a row to force a code path — STOP and
ask (an `AskUserQuestion` with concrete options works well), then act on their
choice. Do not silently pick a DB, reset one, or seed test data to make a step
pass.

Tell the user, in one line, what you've got watching, including the **verified**
port and the gateway modes: "Dev server up on :<port> (logs streaming to me), DB
confirmed on :<dbport> (verified your <recent app write> landed there);
gateways: Bridge sandbox, Turnkey LIVE — I'll gate any Turnkey-touching step on
your confirmation. I'll read logs and DB after each step." Then move to Phase 1.

Teardown: when the walkthrough ends (or the user stops), kill the background
dev-server shell you started. Don't leave an orphaned server running.

## Phase 1 — Discover the change set

Before saying anything to the user, run these in parallel and read the results:

- `git rev-parse --abbrev-ref HEAD` — current branch.
- `git rev-parse --abbrev-ref origin/HEAD 2>/dev/null` then strip the `origin/`
  prefix — the project's default branch. Fall back to `main` if unset.
- `git diff <default>...HEAD --stat` — committed changes on this branch.
- `git diff --stat` — uncommitted modified files.
- `git diff --cached --stat` — staged but uncommitted.
- `git status --porcelain` — untracked files (lines starting with `??`).
- `git log <default>..HEAD --oneline` — commit messages for context.

For the meaningful files, read the diff or the file itself so you actually
understand what changed. Don't plan based on filenames alone.

Categorise:

- **Schema** — DB migrations, codegen output (e.g., `apps/*/migrations/`,
  `db/schema.ts`).
- **Backend** — repos, services, gateways, route handlers (HTTP / RPC).
- **Frontend** — UI screens, components, routes.
- **Background** — cron jobs, workers, scheduled tasks.
- **Tests / docs / config** — usually no separate manual test step. Surface
  config changes that would affect behaviour (env vars, feature flags).
- **Operational scripts** — one-off scripts under `scripts/` or `bin/`. Surface
  them; the user may want to run them at the end.

Filter out derivative changes (auto-generated lockfiles, codegen output,
formatter-only diffs) — they aren't separate test steps.

If the diff is empty, ask the user whether they're on the right branch before
continuing.

## Phase 2 — Build the test plan

Group related changes into **behaviour units**. A behaviour unit is something a
real user / operator / system actually does end-to-end. Examples:

- "Provision a new account" (route + repo + gateway changes coalesce here)
- "Hit the new endpoint and confirm response shape"
- "Send a webhook and watch the credit land"
- "Reject a known-invalid input"

For each unit, draft a step with:

- **Goal** — what behaviour we're verifying, in plain English.
- **Setup** — preconditions (migrations applied, dev server running, fixtures
  seeded, env vars set).
- **Action** — exact commands or UI clicks. Copy-paste-ready.
- **Verify** — exact expected output, and **which observation post proves it**:
  the log line you'll grep for in `BashOutput`, the DB query and row you'll run
  yourself, the HTTP response the user reports back. Be specific — "expect
  status 200 and body.source === 'liquidation', and a `signer.registered` log
  line, and one new `turnkey_sub_org_users` row with `status='active'`", not
  "expect a successful response".
- **Reset** — how to clean up before the next step (often "nothing — additive").
- **Gateway exposure** — which external gateways the step exercises and their
  mode from the Phase 0 check. A step through a LIVE gateway gets a ⚠ marker in
  the plan, a stated blast radius ("creates a real Bridge customer"), and a
  confirmation gate before it runs; sandbox steps just note the mode.

Order:

1. **Setup phase first** — apply migrations, regenerate schema if needed, start
   the dev server. Always confirm `pnpm run db:migrate` (or the project's
   equivalent — check `package.json`) and any codegen step.
2. **Smallest scope first** — direct unit-style behaviour (single endpoint with
   valid input).
3. **Negative paths next** — invalid inputs that should 4xx with the new error
   copy.
4. **Multi-step flows last** — provisioning → deposit → reconciler → balance
   credit. These exercise multiple changes at once.

Show the plan to the user as a numbered list with one-line goal summaries. Use
`AskUserQuestion` to confirm whether to proceed, edit, or pick a subset. Default
option is "proceed with all steps".

## Phase 3 — Walk through each step

For each step, in order:

1. **Announce** — "Step N/M: <goal>." One sentence.
2. **Explain** — what will happen, in plain English. 1–2 sentences. Include side
   effects (writes to DB, hits external API, sends email).
3. **Action** — exact commands in code blocks. If a command needs an env var or
   secret, name it and say where to source it. Never paste secrets.
4. **Wait** — say: "Run this and tell me when it's done — I'll read the logs and
   query the DB myself. (Paste anything I can't see from here.)" Then stop
   emitting output entirely. Do not draft step N+1 — the user's reply is what
   unblocks you. See the "Hard pause rule" section above; that rule overrides
   any instinct to batch.
5. **Observe, then verify** — when the user says it's done, FIRST pull your
   observation posts before judging:
   - `BashOutput` on the dev-server shell — read the new log lines this action
     produced. Quote the relevant ones back.
   - Run the DB query yourself against the local port — show the actual row(s).
   - Fold in whatever the user pasted (HTTP status/body you can't see). Then
     compare against the expected result and state pass/fail explicitly. If
     pass, cite the evidence YOU saw ("log shows `signer.registered orgId=…` and
     `turnkey_sub_org_users` now has 1 active row → ✓"). If the logs show an
     error the user didn't mention, surface it — that's the value of watching
     yourself.
6. **Mark** — ✓ pass / ✗ fail / → skipped.

If a step fails: **diagnose, don't blindly retry.** Read the code paths the step
exercised, check setup assumptions (migration applied? server restarted after a
code change? right env?), and propose a fix-and-retry. Surface the diagnosis to
the user before re-running.

Keep step descriptions compact. The user is doing real work in another window;
don't bury them in walls of text.

## Step-type playbook

**HTTP / API**

- Give the user a `curl`. Mention auth (cookie, token, API key) and where to
  source it. For authed routes, suggest the user log in first via the UI or
  capture the cookie from devtools.
- The user reports status + body (you can't see their terminal). You confirm the
  server side: `BashOutput` for the request's log lines, and for state-changing
  endpoints a DB read query you run yourself to prove persistence — don't take
  the 200 at face value.

**DB state check**

- Run the `psql` query yourself against the local port (you already hold the
  connection from Phase 0) — don't hand it to the user unless they want to see
  it too. Quote the actual rows back.
- Verify count and specific column values. Be precise — "expect exactly 1 row
  with `status='completed'` and `provider_payment_id='manual-…'`".

**UI click-through**

- Describe the click path: "Open `<url>`, select `<element>`, click `<button>`."
- Verify by what they see (text, presence, formatting). Ask the user to read it
  back; compare against expected.
- For visual regressions, ask for a screenshot if the change is subtle.

**Background job / cron**

- Note the schedule (`* * * * *` etc.) and where it's defined. Tell the user
  when to expect a tick.
- If the project has a way to trigger the job manually, use it. Otherwise seed
  the precondition and wait one tick.
- Verify by querying the DB (or whatever side effect) after.

**Negative test**

- Give a deliberately invalid input. Confirm the system rejects it cleanly:
  correct status, helpful error message matching the source-code copy. Every new
  4xx introduced in the diff deserves a negative test.

**Webhook / external event**

- If the project has a simulator (e.g., `pnpm bridge:simulate`), use it.
  Otherwise give the user a `curl` that mimics the upstream payload, including
  signature headers if applicable.
- Verify by the local effect you can see yourself: the handler's log lines in
  `BashOutput`, then the DB row / balance change via a query you run.

**Operational scripts**

- Surface them but don't run unless explicitly in scope. If the user wants to
  dry-run, suggest they read it first or run with a feature flag / `--dry-run`
  if available.

## Voice

Concrete, brief, honest about risk. The user is following along live — 1–3
sentences per step body, exact commands, exact expected output. Always flag
steps that touch real money, external paid APIs, production state, or anything
destructive ("this will hit Bridge prod and create real customer state — confirm
before running").

## Stop conditions

- A step fails and the diagnosis isn't immediate → **STOP**. Summarise what
  passed, what failed, what's likely wrong. Don't barrel into the next step.
- The user says "stop" / "skip the rest" → end gracefully with a summary table,
  then tear down the background dev-server shell you started in Phase 0.
- All steps pass → end with a final summary table:

  ```
  | # | Goal | Result |
  | 1 | Apply migrations | ✓ |
  | 2 | … | ✓ |
  ```

  Plus any latent issues you noticed during the walkthrough (suggestions,
  follow-ups, things out of scope for the current change).

## Edge cases

- **No diff vs `main`** — ask the user whether they're on the right branch or
  whether they meant to include uncommitted work.
- **Default branch isn't `main`** — detect via
  `git rev-parse --abbrev-ref origin/HEAD`. Don't hardcode.
- **Monorepo** — look at `apps/*/` and `packages/*/`; group steps by package and
  run each app's setup commands separately.
- **Migration not applied locally** — make this Step 1 of the plan.
- **Codegen out of date** — if regenerated schema files are uncommitted after a
  migration, surface it ("run `pnpm run db:codegen` and commit the diff").
- **Dev server not running** — confirm via a health endpoint
  (`curl http://localhost:<port>/<health>`); if it's not running, tell the user
  how to start it (`pnpm run dev` or whatever the project uses).
- **Tests changed but production code didn't** — note this and skip to any
  operational / data-fix scripts in the diff.
- **Empty local DB / missing fixtures** — when the branch's behaviour needs a
  provisioned org, account, signer, or similar that the local DB doesn't have
  yet (query and check before assuming), default to **onboarding together**: you
  keep the full-stack `pnpm dev` server running and watch logs + DB, the user
  drives the console onboarding manually in the browser, and you verify each
  precondition lands in the DB before moving on. Ask the user which test admin
  account to use for the onboarding/login (or use the project's standard dev
  account). Lay out the chain of preconditions as a checklist up front (what
  you'll verify for each), then confirm them one at a time as the user creates
  them.

## Final note

You are walking the user through their own changes. Don't lecture them on what
their code does — they wrote it. Focus on **the runtime behaviour they need to
observe** to convince themselves the change works end-to-end. The goal is
signal, not coverage.

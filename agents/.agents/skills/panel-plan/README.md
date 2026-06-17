# panel-plan

Run a single independent panel review of a written plan (a design /
implementation markdown file) — the planning-time sibling of `panel-review`.
Fans the plan out to multiple local CLI coding agents (codex, claude, opencode)
running in parallel, each reading the plan + the repo it targets read-only, then
synthesizes their findings and open questions into one report. **One pass,
read-only — it reports, it doesn't edit the plan.** For the
iterate-edit-re-review loop to convergence, see
[`panel-plan-loop`](../panel-plan-loop), which calls this skill each round.

## Install

```
npx skills add catena-labs/dev-skills --skill panel-plan
```

## How to use it

Write a plan first (e.g. via brainstorming or `writing-plans`), then ask Claude
Code in plain English:

- "panel plan docs/specs/foo.md"
- "have the panel review my plan"
- "get the panel's take on this plan, focus on the migration strategy"
- "panel plan with just codex and claude"

## What it does

- Spawns each panelist as a fresh, non-interactive subprocess with no shared
  conversation state — independent second opinions are the whole point.
- Embeds the plan (with line numbers) in the prompt and runs every panelist
  **read-only** against your working tree, so each one can check the plan's
  assumptions against the real codebase — does the file/function/table it
  references exist? is the step feasible? — without being able to modify
  anything.
- Each panelist reports structured findings (severity + `plan:line` + suggested
  plan edit), a goal/approach read, and an **open questions** block — the
  decisions only a human can make.
- The coordinator synthesizes one report: overview, risk, must-fix / should-fix
  / polish buckets, open questions, and disagreements. It does **not** edit the
  plan.

## Gotchas

- **Background Bash + `BashOutput` polling is required.** Codex dominates wall
  clock, so foreground calls block silently for minutes. Don't launch
  `panel-plan.sh` via the `Agent` tool / subagents — there's no streaming-output
  API for in-flight subagents and the heartbeats become invisible.
- **Read-only, but not sandboxed against everything.** Panelists run read-only
  (no edits, no exec that changes state), but they do read your working tree and
  pick up the project's `AGENTS.md` / `CLAUDE.md` — intentional, but worth
  knowing if those would bias the review.
- **Write the plan to a file first.** The panel reviews a `.md` on disk; if your
  plan only lives in the conversation, save it before invoking.
- **One pass only.** To harden a plan over multiple rounds with edits in
  between, use [`panel-plan-loop`](../panel-plan-loop).

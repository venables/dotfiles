# panel-plan-loop

Harden a written plan by iterating it through an independent agent panel until
it converges. Built **on top of** [`panel-plan`](../panel-plan): each round is
one fresh, no-shared-state panel review of the plan; this skill acts on the
results — applying the clear fixes, raising the judgment calls to you, editing
the plan, and re-running the panel, round after round, until the plan stops
attracting significant concerns.

## Install

```
npx skills add catena-labs/dev-skills --skill panel-plan-loop
```

(Depends on `panel-plan`, which it invokes each round — install that too.)

## How to use it

Write a plan first (e.g. via brainstorming or `writing-plans`), then ask Claude
Code in plain English:

- "iterate on this plan with the panel"
- "harden docs/specs/foo.md with the panel"
- "panel plan loop"
- "keep running the panel on my plan until it's solid"
- "review and fix my plan"

## What it does

- Runs `panel-plan` each round — a fresh panel of independent local CLI agents
  (codex, claude, opencode) reviewing the current plan read-only.
- **Applies the clear, uncontested fixes to the plan directly**, and **raises
  every genuine judgment call to you** (open questions, trade-offs, scope
  changes, panelist disagreements) before editing.
- Updates the plan, then re-runs the panel against the new version.
- Loops automatically until a round surfaces no new must/should-fix concerns,
  then asks whether to stop — with a safety cap of 4 rounds. Each round's
  concerns, your decisions, and the edits applied are logged to a sibling
  `<plan>.review.md` so the plan file itself stays clean.

## Why it's a separate skill

The review primitive (`panel-plan`) stays dumb and read-only so the panel is
genuinely independent each round — no memory, no bias from prior rounds. All the
cross-round state (what was fixed, what you decided, when to stop) lives here,
in the orchestrator. That separation is also what lets the same loop pattern be
reused for other review primitives later.

## Gotchas

- **It edits your plan file.** Auto-fixes are applied directly (uncontested ones
  only); judgment calls are gated on your input. The plan lives in git — review
  the diff each round.
- Depends on `panel-plan` being installed.

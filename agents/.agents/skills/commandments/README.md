# commandments

Audit the current branch, PR, or uncommitted changes against the project's
`COMMANDMENTS.md` — the code-style and human+agent readability conventions.
Produces a worked checklist: every applicable commandment listed with a status,
every violation cited as `file:line` with a concrete fix. Does not auto-fix
unless asked.

## Install

```bash
npx skills add catena-labs/dev-skills --skill commandments
```

## How to use it

Just ask Claude Code in plain English — defaults to the current local work
(branch + uncommitted changes) when no PR is given:

- "check the commandments"
- "commandments review"
- "readability review"
- "do my changes follow our conventions?"
- "/commandments https://github.com/owner/repo/pull/42"
- "/commandments owner/repo#42 --full --fix"

## What it does

- **Loads the rules from `COMMANDMENTS.md` at the repo root, or
  `docs/COMMANDMENTS.md`.** No commandments file, no review — it tells you and
  stops rather than inventing rules.
- **Scopes to what changed.** Default is the union of uncommitted work and
  committed-but-unmerged branch work versus the merge base; pass a PR reference
  to review that PR instead, or `--full` to read whole files rather than just
  the changed hunks.
- **Walks every applicable commandment against the diff** — LLM-guided, not a
  scanner. Large diffs fan out to parallel subagents, one per group of files.
- **Sweeps every added comment mechanically.** Comments are the easiest
  violation to miss reading file-by-file, so the skill enumerates each comment
  line the diff adds and gives it an explicit verdict.
- **Never re-flags what the linter owns.** Anything the project's
  linter/formatter would catch is dropped, and formatting churn is never
  proposed.
- **Reports a worked checklist** — PASS / VIOLATION / NEEDS REVIEW / N/A per
  commandment, then a one-line verdict: CLEAN, MINOR, or NEEDS WORK.
- **Fixes only on request.** With `--fix` it applies the proposed fixes
  smallest-first, but layering and structural findings stay as recommendations
  for you to decide.

## Gotchas

- **It requires a `COMMANDMENTS.md` in the target repo.** The skill audits
  against your project's own conventions document; without one it has nothing to
  check.
- **Findings must cite the diff.** Pre-existing problems in untouched code are
  follow-up notes at most, never blocking findings.
- **PR review needs the `gh` CLI** authenticated against the target repo.

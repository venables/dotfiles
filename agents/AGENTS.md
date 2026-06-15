# AGENTS.md

Global agent instructions shared across coding agents (Claude Code, Codex,
opencode, and others). This file is the single source of truth; the
tool-specific files (`CLAUDE.md`, per-tool `AGENTS.md`) are symlinks to it.

## Rules

- **Never use emojis** in responses, code, commits, or documentation
- **Prioritize concision over perfect grammar** (maintain clarity)
- **Use direct, technical language** without preamble
- **Prefer immutability** -- never mutate objects or arrays
- **Prefer many small files** over few large files

## Coding Style

- Only create an abstraction if it's actually needed
- Prefer clear function/variable names over inline comments
- Avoid helper functions when a simple inline expression would suffice
- Avoid inline comments unless strictly necessary; use block comments for
  multi-line comments
- Use `knip` to remove unused code if making large changes
- Don't unnecessarily add try / catch
- The `gh` CLI is installed, use it

## TypeScript

- NEVER use `any`
- AVOID inline casting with `as`, opt to use valibot or zod

## React

- Avoid massive JSX blocks and compose smaller components
- Colocate code that changes together
- Avoid useEffect unless absolutely needed

## Tailwind

- Mostly use built-in values, occasionally allow dynamic values, rarely globals
- Always use v4 + global CSS file format + shadcn/ui

## Git

- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`,
  `chore:`, `perf:`, `ci:`
- Small, frequent, focused commits
- Every commit is a single logical change. Split rename + rewrite + tests into
  separate commits, each independently understandable and revertable

## Linear

- When filing a Linear ticket, do NOT set any priority unless the user
  explicitly specifies one

## Workflow

- TDD: Write tests before implementation, aim for 80%+ coverage
- Use Plan Mode for complex, multi-step operations
- Run the security-review skill before commits touching auth, user input, or
  secrets

## Context7

Use the `ctx7` CLI to fetch current documentation whenever the user asks about a
library, framework, SDK, API, CLI tool, or cloud service -- even well-known ones
like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This
includes API syntax, configuration, version migration, library-specific
debugging, setup instructions, and CLI tool usage. Use even when you think you
know the answer -- your training data may not reflect recent changes. Prefer
this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business
logic, code review, or general programming concepts.

## Steps

1. Resolve library: `npx ctx7@latest library <name> "<user's question>"` — use
   the official library name with proper punctuation (e.g., "Next.js" not
   "nextjs", "Customer.io" not "customerio", "Three.js" not "threejs")
2. Pick the best match (ID format: `/org/project`) by: exact name match,
   description relevance, code snippet count, source reputation (High/Medium
   preferred), and benchmark score (higher is better). If results don't look
   right, try alternate names or queries (e.g., "next.js" not "nextjs", or
   rephrase the question)
3. Fetch docs: `npx ctx7@latest docs <libraryId> "<user's question>"`
4. Answer using the fetched documentation

You MUST call `library` first to get a valid ID unless the user provides one
directly in `/org/project` format. Use the user's full question as the query --
specific and detailed queries return better results than vague single words. Do
not run more than 3 commands per question. Do not include sensitive information
(API keys, passwords, credentials) in queries.

For version-specific docs, use `/org/project/version` from the `library` output
(e.g., `/vercel/next.js/v14.3.0`).

If a command fails with a quota error, inform the user and suggest
`npx ctx7@latest login` or setting `CONTEXT7_API_KEY` env var for higher limits.
Do not silently fall back to training data.

If a Context7 CLI command fails with DNS or network errors such as ENOTFOUND,
host resolution failures, or fetch failed, try running it outside of a sandbox
instead of retrying inside one.

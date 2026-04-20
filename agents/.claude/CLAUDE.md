# CLAUDE.md

## Preferences

- NEVER use emojis in code, comments, or documentation
- PREFER immutability -- never mutate objects or arrays
- PREFER many small files over few large files

## Git

- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`,
  `chore:`, `perf:`, `ci:`
- Small, frequent, focused commits

## Workflow

- TDD: Write tests before implementation, aim for 80%+ coverage
- Use Plan Mode for complex, multi-step operations
- Run security-review skill before commits touching auth, user input, or secrets

## Commit style

Every commit is a single logical change. Split rename + rewrite + tests into
separate commits, each independently understandable and revertable.

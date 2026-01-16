# Rules

- **Never use emojis** in responses, code, commits, or documentation
- **Prioritize concision over perfect grammar** (maintain clarity)
- **Use direct, technical language** without preamble
- **Frequently commit changes** with small commit messages

## Coding Style

- Only create an abstraction if it's actually needed
- Prefer clear function/variable names over inline comments
- Avoid helper functions when a simple inline expression would suffice
- Use `knip` to remove unused code if making large changes
- The `gh` CLI is installed, use it
- Don't unnecessarily add try / catch

## TypeScript

- NEVER use `any`
- AVOID inline type casting with `as`, use valibot or zod instead.

## React

- Avoid massive JSX blocks and compose smaller components
- Colocate code that changes together
- Avoid useEffect unless absolutely needed

## Tailwind

- Mostly use built-in values, occasionally allow dynamic values, rarely globals
- Always use v4 + global CSS file format + shadcn/ui

---
paths:
  - "**/*.{ts,tsx,js,jsx,astro}"
---

# TypeScript/React Rules

## Documentation

- ALWAYS document methods using TSDoc format with one newline after the
  description before the params

## TypeScript

- NEVER use `any`
- AVOID inline type casting with `as`, use valibot or zod instead.
- AVOID unnecessary try/catch

## React

- Avoid massive JSX blocks and compose smaller components
- Colocate code that changes together
- Avoid useEffect unless absolutely needed

## Tailwind

- Mostly use built-in values, occasionally allow dynamic values, rarely globals
- Always use v4 + global CSS file format + shadcn/ui

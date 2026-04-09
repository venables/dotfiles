# Security Guidelines

## Pre-Commit Checklist

- No hardcoded secrets (API keys, passwords, tokens)
- All user inputs validated
- Parameterized queries (no SQL concatenation)
- Error messages don't leak sensitive data

## If Security Issue Found

1. STOP immediately
2. Fix CRITICAL issues before continuing
3. Rotate any exposed secrets

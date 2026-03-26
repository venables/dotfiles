# Coding Style

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate:

```ts
// WRONG
function updateUser(user, name) {
  user.name = name
  return user
}

// CORRECT
function updateUser(user, name) {
  return { ...user, name }
}
```

## File Organization

- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Organize by feature/domain, not by type

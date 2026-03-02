---
name: refactor
description: Use this skill when asked to refactor code, improve code quality, clean up a file, reduce duplication, or improve readability. Identifies code smells and applies appropriate patterns.
---

## When to Use
Use when the user asks to:
- "refactor this"
- "clean this up"
- "improve this code"
- "this is messy, fix it"
- "reduce duplication"
- "apply better patterns"

## Process

1. **Read the target file(s)** fully before making any changes

2. **Identify issues** — look for:
   - Functions longer than ~30 lines (should be split)
   - Duplicated logic (extract to shared function)
   - Magic numbers/strings (extract to named constants)
   - Deeply nested conditionals (flatten with early returns)
   - Missing type hints (Python) or `any` types (TypeScript)
   - Functions doing more than one thing (single responsibility)
   - Inconsistent naming conventions

3. **Apply refactors in this order** (least to most disruptive):
   - Rename for clarity
   - Extract constants
   - Add type hints
   - Extract helper functions
   - Flatten nested logic
   - Split large functions
   - Extract classes/modules only if clearly warranted

4. **State what you changed and why** — one line per change

## Rules
- **Never change behaviour** — refactoring is structural only
- Make one logical change at a time
- If tests exist, run them after to confirm nothing broke
- Don't refactor what isn't broken — only touch what has a clear issue
- Prefer simple over clever

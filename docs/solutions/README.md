# Knowledge Base

Institutional memory — the "lab notebook" layer. Solutions to problems encountered during operation.

## Categories

- `architecture/` — Structural decisions, system design patterns, and ADR rationale
- `integration/` — Cross-system connections, API contracts, and service boundary decisions
- `tooling/` — Development tooling configuration, build systems, and automation patterns

## Entry Format

Every KB entry follows this structure:

**YAML Frontmatter:**
```yaml
title: Descriptive title
date: YYYY-MM-DD
category: architecture | integration | tooling
severity: P1 | P2 | P3
tags: [tag1, tag2, tag3]
resolved: true | false
```

**Seven Sections:**
1. **Problem** — What went wrong and how it manifested
2. **Context** — Environment, versions, constraints
3. **Investigation** — What was tried and why it did or didn't work
4. **Solution** — The fix, with code if applicable
5. **Trade-offs** — What was gained, what was given up
6. **Verification** — How we confirmed the solution works
7. **Lessons Learned** — What to remember for next time

## When to Document

- A problem took more than 30 minutes to solve
- The solution was non-obvious or counter-intuitive
- A pattern emerged that will recur
- An integration required specific configuration that isn't well-documented
- A debugging session revealed something surprising

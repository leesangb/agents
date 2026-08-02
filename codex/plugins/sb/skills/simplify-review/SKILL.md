---
name: simplify-review
description: Find material code, state, branch, abstraction, dependency, residue, or test complexity that can be removed without changing the Outcome Contract or verification meaning. Use for a separately gated simplification pass on substantive implementations.
---

# Simplify Review

Review only the task-owned diff and directly caused adjacent code. Do not edit files, post comments, or propose new abstractions.

## Evidence bar

- Treat the Outcome Contract, invariants, negative evidence, out-of-scope boundaries, and contract-shaping decisions as fixed. Treat implementation recommendations as adaptable only when observable behavior and verification meaning remain intact.
- Inspect requirement overshoot, duplicate facts/transformations, redundant/unreachable paths, fallback/compatibility residue, temporary helpers/wrappers/flags/logs/TODOs, dependencies, and tests coupled to internals.
- Preserve external-input validation, trust-boundary checks, safety, security, accessibility, error handling, performance, and meaningful coverage.
- Try to falsify every deletion/inline/merge candidate through reachable callers, failure/retry/migration paths, invariants, and verification. If evidence is incomplete or the change needs a contract/API/ownership decision, defer it.

## Output

Use exactly:

```markdown
## Material Simplification Findings

### [S1] Finding title
- Location: `path:line`
- Unnecessary work or concept:
- Simpler shape:
- Behaviour-preservation evidence:
- Verification:

## Deferred Concerns
- None

## Result
- No material simplification found.
```

Repeat finding blocks for material findings, order by impact, and end with `Material findings found: N` when findings exist. Do not report taste or pre-existing cleanup.

---
name: code-review
description: Review a non-trivial executable diff for reachable correctness bugs, regressions, error paths, maintainability hazards, leaky abstractions, and weak behavior evidence. Use when a concrete code-review question remains after deterministic checks.
---

# Code Review

Review the exact supplied scope adversarially. Treat assumptions as hypotheses and return draft findings only; do not edit files or post comments.

## Review

- Read full changed files, direct callers, nearby tests, local notes, and relevant context rather than only the diff.
- Construct reachable counterexamples through boundary inputs, partial failures, state transitions, retries, concurrency, or ordering. A behavior claim needs a concrete call sequence, input, or state that reaches the line; otherwise label it speculative and do not make it a blocker.
- Check correctness, error handling, edge cases, API misuse, caller obligations, unnecessary complexity, intent-bearing names/types/constants/comments, runtime observability, and whether tests prove the observable contract.
- Defer intent-only concerns to `$sb:intent-review`, responsibility/change-axis concerns to `$sb:architecture-review`, caller API design to `$sb:api-review`, semantic substitutability/invariants to `$sb:oop-review`, and test-boundary strategy to `$sb:test-review`; retain an overlapping finding only when it independently demonstrates runtime correctness or maintainability risk.
- When the workflow asks for the material-simplification checklist, also inspect requirement overshoot, duplicate state/paths, unnecessary abstractions/dependencies/residue, and evidence that simplification preserves behavior. Exclude taste and never weaken safeguards.

## Output

Order findings by severity. For each include a precise `path:line`, reachable trigger evidence, why it matters, smallest safe fix, and focused verification. Deduplicate with other capabilities and note useful behavior already protected. If no actionable finding survives the evidence bar, return a concise good-as-is result.

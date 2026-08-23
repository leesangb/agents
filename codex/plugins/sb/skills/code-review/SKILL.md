---
name: code-review
description: Review a non-trivial executable diff for reachable correctness bugs, regressions, error paths, maintainability hazards, leaky abstractions, and weak behavior evidence. Use when a concrete code-review question remains after deterministic checks.
---

# Code Review

Review the exact supplied scope adversarially. Treat assumptions as hypotheses and return draft findings only; do not edit files or post comments.

## Review

- Read full changed files, direct callers, nearby tests, local notes, and relevant context rather than only the diff.
- Construct reachable counterexamples through boundary inputs, partial failures, state transitions, retries, concurrency, or ordering. A behavior claim needs a concrete call sequence, input, or state that reaches the line; otherwise label it speculative and do not make it a blocker.
- For a diff or PR, compare the candidate with the baseline and classify whether the scoped change introduced, worsened, newly exposed, left unchanged, or is unrelated to the problem. Do not turn an unchanged pre-existing issue into a scoped blocker.
- Try to defeat the candidate with the strongest available normal-behavior explanation, guard, caller constraint, test, history, or runtime evidence. Return what was checked, not merely that the review was adversarial.
- Check correctness, error handling, edge cases, API misuse, caller obligations, unnecessary complexity, intent-bearing names/types/constants/comments, runtime observability, and whether tests prove the observable contract.
- When concrete maintainability evidence raises a question about structure cost, normal-flow visibility, a trust boundary, or abstraction timing, read [Practical Design Foundations](../code/references/design-foundations.md). Apply only the questions supported by the reachable code, describe the concrete cost before naming a principle, and defer a distinct caller-interface or ownership redesign to the dedicated reviewer.
- Defer intent-only concerns to `$sb:intent-review`, responsibility/change-axis concerns to `$sb:architecture-review`, caller API design to `$sb:api-review`, semantic substitutability/invariants to `$sb:oop-review`, and test-boundary strategy to `$sb:test-review`; retain an overlapping finding only when it independently demonstrates runtime correctness or maintainability risk.
- When the workflow asks for the material-simplification checklist, also inspect requirement overshoot, duplicate state/paths, unnecessary abstractions/dependencies/residue, and evidence that simplification preserves behavior. Exclude taste and never weaken safeguards.

## Output

Return candidate findings ordered by provisional severity; Main owns final severity and disposition. For each include a precise `path:line`, scoped-change relation when applicable, reachable trigger evidence, material consequence, strongest checked disconfirming evidence, evidence provenance, smallest safe fix, and focused verification. Deduplicate with other capabilities and note useful behavior already protected. If no actionable candidate survives the evidence bar, return a concise good-as-is result.

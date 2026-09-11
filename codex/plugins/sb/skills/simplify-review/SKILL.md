---
name: simplify-review
description: Find unnecessary coupling and removable code, state, abstraction, or test complexity while preserving the Outcome Contract and verification meaning. Use for a separately gated simplification pass on substantive implementations.
---

# Simplify Review

Review only the task-owned diff and directly caused adjacent code. Do not edit files or post comments.

## Simplicity and coupling

Judge simplicity by whether concepts can vary independently where requirements allow it, not by lines, files, components, or abstractions counted. More code can be simpler when it removes an unnecessary dependency; deletion or merging must preserve or improve that independence.

- Identify concepts from current requirements, behavior, callers, and tests rather than assuming existing module boundaries reflect them. Ask: "If A should change independently, why must B change too?"
- Look for coordinated edits, incidental execution order, caller knowledge of internals, and one representation serving independently changing purposes. Trace transformations for information another current concern needs: discarding it can force that concern to depend on an earlier operation or reconstruct lost facts.
- Keep coupling required by domain relationships or consistency invariants. Propose separation only with a concrete, evidence-backed change case showing which concepts should vary independently and how the current implementation prevents it. Technical separability or hypothetical future consumers alone are insufficient.
- Compare the reduced change scope with added code, indirection, runtime cost, and cognitive overhead. Choose the smallest improvement; add an interface or layer only when that comparison justifies it. If the evidence does not justify separation, keep the existing design.

## Evidence bar

- Treat the Outcome Contract, invariants, negative evidence, out-of-scope boundaries, and contract-shaping decisions as fixed. Treat implementation recommendations as adaptable only when observable behavior and verification meaning remain intact.
- Inspect requirement overshoot, duplicate facts/transformations, redundant/unreachable paths, fallback/compatibility residue, temporary helpers/wrappers/flags/logs/TODOs, dependencies, and tests coupled to internals.
- Preserve external-input validation, trust-boundary checks, safety, security, accessibility, error handling, performance, and meaningful coverage.
- Try to falsify every deletion, inline, merge, or separation candidate through reachable callers, failure/retry/migration paths, invariants, and verification. If evidence is incomplete or the change needs a new contract/API/ownership decision, defer it.

## Output

Use the generic review envelope below so the orchestrator can audit the result. Preserve the simplification-specific fields rather than replacing them with a generic code-review suggestion.

For coupling findings, include the concepts, why their dependency is unnecessary, and the concrete change case in `Unnecessary work or concept`. Show the current dependency and proposed relationship in `Simpler shape` when that makes the issue clearer. Include reduced change scope and added costs; omit inapplicable fields and empty deferred sections. A whole-system dependency map or size score is not required.

```markdown
axis | disposition | required artifacts complete/missing

## Material Simplification Findings

### [S1] Finding title
- Location: `path:line`
- Scoped-change relation: introduced | worsened | newly_exposed | pre_existing | unrelated | unknown
- Reachable trigger:
- Material consequence:
- Strongest checked disconfirming evidence:
- Evidence provenance:
- Provisional severity:
- Unnecessary work or concept:
- Simpler shape:
- Benefit and cost:
- Behaviour-preservation evidence:
- Verification:

## Deferred Concerns
- None

## Result
- No material simplification found.
```

Repeat finding blocks for material findings, order by impact, and end with `Material findings found: N` when findings exist. Use stable `S<number>` IDs across any audit response. Do not assign final severity or disposition, and do not report taste or pre-existing cleanup.

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

Return material findings ordered by provisional impact; Main owns final severity and disposition. For each include location, scoped-change relation when applicable, reachable trigger, consequence, checked counterevidence and provenance, the unnecessary work or concept, smallest correction, benefit and added cost, behavior-preservation evidence, and focused verification.

For coupling findings, explain which concepts need to vary independently, why the current dependency is unnecessary, and the concrete change case. A current/proposed relationship sketch is useful when it clarifies that claim. Omit inapplicable fields, empty deferred sections, whole-system maps, and size scores. Use stable finding IDs when participating in an audit exchange.

If no material simplification survives the evidence bar, return a concise supported result. Do not report taste or pre-existing cleanup.

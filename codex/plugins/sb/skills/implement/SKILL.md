---
name: implement
description: Implement or fix an approved code-change plan as the designated writer, preserving its contract and verifying completion.
---

# Implement

Main or one built-in `worker` implements the approved plan. Keep that writer through fix iterations. Treat the Outcome Contract and contract-shaping decisions as fixed; implementation recommendations may adapt without changing behavior or verification meaning.

Before editing, confirm the outcome, completion evidence, constraints, invariants, scope, and material exceptions. When the plan identifies composition or a mechanism boundary, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) for that concern.

Use existing mechanisms and narrowly scoped changes. A simpler internal seam, ordering, or test placement is allowed when the contract remains intact; explain material departures in the handoff. If evidence changes a contract field or contract-shaping decision, stop that concern and return the evidence to Main for replanning under [Planning and Resuming](../code/references/planning.md).

Run relevant existing checks first. Add or update tests only for changed observable behavior they do not protect or an explicit request; use vertical TDD when a behavior test is needed. Preserve validation, types, security, accessibility, error handling, data integrity, and performance-sensitive behavior.

Run checks that establish completion, applicable typecheck/lint, and required project checks. Broaden or repeat only for new changes, failures, or unresolved concerns. Continue fixes and affected verification under the shared completion policy.

Return changed behavior, exact verification commands/results, material deviations, and unresolved requirements. Do not commit without authorization. User-facing reporting follows the [router](../code/SKILL.md#reporting).

---
name: implement
description: Implement or fix an authorized code-change plan as the designated writer, preserving its contract and verifying completion.
---

# Implement

Main or one [`worker`](../../roles.md) implements the current plan within the caller's authorized outcome, scope, and effects. Keep that writer through fix iterations. Treat the Outcome Contract and contract-shaping decisions as fixed; implementation recommendations may adapt without changing behavior or verification meaning. Follow [Planning and Resuming](../code/references/planning.md) for authorization; the request can authorize implementation without a separate plan-approval turn.

Before editing, confirm the outcome, completion evidence, constraints, invariants, scope, and material exceptions. Consult [Shared Principles](../../principles/index.md) and read the criteria relevant to the accepted task and proposed/actual call paths. Use them to shape the implementation. When the plan identifies composition or a mechanism boundary, read [Composition and Mechanisms](../principle-composition-and-mechanisms/SKILL.md) for that concern.

Complete any missing [caller-first outline](../code/references/implementation-outline.md) required by the shared planning policy before implementation.

Use existing mechanisms and narrowly scoped changes. A simpler internal seam, ordering, or test placement is allowed when the contract remains intact; explain material departures in the handoff. If evidence changes a contract field or contract-shaping decision, stop that concern and return the evidence to Main for replanning under [Planning and Resuming](../code/references/planning.md).

## Verification

Run relevant existing checks first. Add or update tests only for changed observable behavior they do not protect or an explicit request; when a behavior test is needed, add the smallest distinguishing case, observe its expected failure, implement the correction, and verify it passes. Use [Behavioral Verification](../principle-behavioral-verification/SKILL.md) for scenario and boundary choices. Preserve validation, types, security, accessibility, error handling, data integrity, and performance-sensitive behavior.

For a multi-step sweep or migration, apply [Sequence Verifiable Units](../principle-verifiable-units/SKILL.md). The implementation writer owns the baseline, unit checks, and final integrated verification.

When the contract permits retrying or resuming a state-changing operation, use [Re-execution Safety](../principle-reexecution-safety/SKILL.md) to choose evidence for repeated execution and partial failure. Main or the implementation writer owns running these checks.

When measuring performance or choosing an option from benchmark or evaluation results, use [Validate Performance and Evaluation Claims](../principle-performance-evidence/SKILL.md) before trusting the baseline or reporting a gain. Main owns running measurements.

Run checks that establish completion, applicable typecheck/lint, and required project checks. Broaden or repeat only for new changes, failures, or unresolved concerns. Continue fixes and affected verification under the shared completion policy.

Return changed behavior, consequential choices with their applied principles and evidence, exact verification commands/results, material deviations, and unresolved requirements. Do not commit without authorization. Completion and user-facing reporting follow the [router](../code/SKILL.md#reporting).

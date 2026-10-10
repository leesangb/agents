---
name: implement
description: Implement or fix an approved code-change plan as the designated writer, preserving its contract and verifying completion.
---

# Implement

Main or one built-in `worker` implements the approved plan. Keep that writer through fix iterations. Treat the Outcome Contract and contract-shaping decisions as fixed; implementation recommendations may adapt without changing behavior or verification meaning.

Before editing, confirm the outcome, completion evidence, constraints, invariants, scope, and material exceptions. Consult [Shared Principles](../../principles/index.md) and read the criteria relevant to the accepted task and proposed/actual call paths. Use them to shape the implementation. When the plan identifies composition or a mechanism boundary, read [Composition and Mechanisms](../../principles/composition-and-mechanisms.md) for that concern.

Use existing mechanisms and narrowly scoped changes. A simpler internal seam, ordering, or test placement is allowed when the contract remains intact; explain material departures in the handoff. If evidence changes a contract field or contract-shaping decision, stop that concern and return the evidence to Main for replanning under [Planning and Resuming](../code/references/planning.md).

## Verification

Run relevant existing checks first. Add or update tests only for changed observable behavior they do not protect or an explicit request; when a behavior test is needed, add the smallest distinguishing case, observe its expected failure, implement the correction, and verify it passes. Use [Behavioral Verification](../../principles/behavioral-verification.md) for scenario and boundary choices. Preserve validation, types, security, accessibility, error handling, data integrity, and performance-sensitive behavior.

For a multi-step sweep or migration, apply [Sequence Verifiable Units](../../principles/verifiable-units.md). The implementation writer owns the baseline, unit checks, and final integrated verification.

When the contract permits retrying or resuming a state-changing operation, use [Re-execution Safety](../../principles/reexecution-safety.md) to choose evidence for repeated execution and partial failure. Main or the implementation writer owns running these checks.

When measuring performance or choosing an option from benchmark results, use [Validate a Performance Claim](../../principles/performance-evidence.md) before trusting the baseline or reporting a gain. Main owns running measurements.

Run checks that establish completion, applicable typecheck/lint, and required project checks. Broaden or repeat only for new changes, failures, or unresolved concerns. Continue fixes and affected verification under the shared completion policy.

Return changed behavior, exact verification commands/results, material deviations, and unresolved requirements. Do not commit without authorization. User-facing reporting follows the [router](../code/SKILL.md#reporting).

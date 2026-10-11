---
name: principle-requirement-fidelity
description: "Map behavior and proof to accepted requirements; separate missing, partial, and ambiguous evidence from scope expansion."
---

# Requirement Fidelity

Use when mapping a plan, implementation, or verification to an explicit requirement, accepted Outcome Contract, or completion criterion.

Map each applicable requirement to proposed or observed behavior and its evidence. Distinguish `satisfied`, `missing`, `partial`, and `ambiguous`; label proposed behavior separately from execution. Check required success/failure behavior, accessibility, edge cases, and work that exceeds the accepted scope.

Evaluate this stage's accepted completion criteria separately from long-term goals and brainstorming. Respect explicit technical choices. A preferred alternative alone does not establish a requirement violation.

When source, tests, and documentation conflict, reconcile their versions with the latest accepted requirement and explicit decisions. A new test does not authorize a contract change, and the newest implementation is not automatically wrong. Preserve unresolved authority or intent as ambiguous.

Keep the accepted contract and contract-shaping decisions fixed. Evidence that requires changing them belongs in the workflow's replanning process. Distinguish missing evidence from a demonstrated failure and avoid inventing unprovided requirements. Account for non-satisfied requirements with the missing behavior, consequence, smallest contract-preserving correction or needed clarification, and a distinguishing verification.

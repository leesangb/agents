---
name: spec-review
description: Check an implementation and its tests against an explicit specification, Outcome Contract, or acceptance criteria. Use when a concrete requirement may be missing, partial, ambiguous, or over-implemented.
---

# Spec Review

Review the supplied artifact against the supplied spec or acceptance criteria without editing. Account for every requirement with precise evidence; use a checklist when it helps the reader assess compliance.

## Review

- Map every requirement to observable implementation behavior and tests.
- Mark each item `satisfied`, `missing`, `partial`, or `ambiguous`; identify over-implementation and behavior/error/accessibility edge cases.
- Treat the Outcome Contract and explicit decisions as fixed. If evidence suggests changing them, report a blocking contract deviation to the caller rather than adapting the implementation.
- Do not infer unprovided requirements. Keep scope fixed and distinguish unavailable evidence from a failure.

For every non-satisfied item include location, reachable behavior or missing path, consequence, smallest contract-preserving correction or clarification, and verification. Return concise findings and note satisfied requirements only when the evidence is useful.

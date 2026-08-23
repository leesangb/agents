---
name: test-review
description: Review whether tests protect changed observable behavior at the correct responsibility boundary, including missing scenarios, implementation coupling, flaky assumptions, and unclear intent. Use when behavior changed and test coverage or placement is a concrete question.
---

# Test Review

Review test strategy and existing tests without adding tests. Return concrete findings first, then useful coverage; do not edit files or post comments.

## Review questions

- What responsibility does the unit own, and what does a caller or user observe when it succeeds or fails?
- Is the test attached to the smallest stable responsibility boundary that explains the behavior: rules/transformations, UI interaction, or flow/integration?
- Are changed behavior, edge cases, failure paths, retries, concurrency, and regressions covered without testing internal helper names, private state, call order, or incidental mocks?
- Could the implementation be rewritten while the test still passes? If not, suggest a behavior-level assertion through a public API, rendered UI, emitted event, state transition, persisted value, request payload, or returned result.
- Are timing, network, environment, or concurrency assumptions deterministic? Does a broad page test hide several responsibilities?
- When the reviewed artifact includes positive composition evidence, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) and expect mechanism behavior through its interface plus requirement policy at the composition root.
- For a concrete test-placement question, read [Practical Design Foundations](../code/references/design-foundations.md). Check whether rules are proved at their owning public boundary and use-case ordering/effects at the composition boundary, and whether helper-only tests leave an end-to-end invariant without an owner. Apply only questions supported by the changed behavior.

Use intent and architecture lenses to clarify names and ownership, but defer those findings to `$sb:intent-review` and `$sb:architecture-review`. Do not request more tests for coverage quantity alone. For every gap or coupling finding include precise location, protected behavior, evidence, smallest test change, and verification.

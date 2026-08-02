---
name: implement
description: Implement a confirmed code-change plan end to end with narrow edits, preserved contracts and safeguards, focused tests, and exact verification evidence. Use when a worker must write or fix executable code and tests.
---

# Implement

Implement the approved plan as the single writer for source and tests. Treat the Outcome Contract as fixed and the Recommended Implementation Outline as adaptable guidance.

## Before editing

1. Read `implementation-notes.local.md`, applicable local instructions, the target files, direct callers, nearby tests, and relevant learnings.
2. Confirm the requested outcome, observable completion evidence, constraints, invariants, scope boundaries, negative evidence, and every `contract-shaping` decision.
3. When the approved plan contains positive composition evidence, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) and implement its approved feature assembly, mechanism ownership, and seam consequences.

## Implementation rules

- Follow existing patterns and keep changes narrowly scoped. Use vertical TDD for behavior changes: one observable test, minimal implementation, green, then continue.
- Preserve trust-boundary validation, assertions, types, security, accessibility, data-loss prevention, error handling, and performance-sensitive behavior.
- Reuse existing mechanisms for feature composition. Extract a new primitive only when the approved plan identifies its independent obligation; otherwise retain the existing seam and record that evidence.
- A simpler internal seam, file, order, or test placement is allowed only when the contract and verification meaning remain intact. Record non-obvious departures and their rationale in the notes.
- If a discovery changes any contract field, scope, invariant, exception, or contract-shaping decision, stop that concern, log a **blocking contract deviation** with evidence and reopen status, and return it to the caller. Never adapt that decision yourself.
- Keep one worker responsible for all source/test fixes across review iterations. Do not commit unless explicitly authorized.

## Completion

Run targeted tests, typecheck, and lint; broaden checks for shared/public/cross-runtime changes. Report exact commands and results, changed files/behavior, deviations, unverified checks, and unresolved blockers. Inspect the current notes after final verification; capture a durable learning only when it is plausibly expensive to rediscover.

---
name: principle-correctness-and-failure-paths
description: "Trace concrete inputs and failure paths against the owning contract when logic, guards, errors, or recovery change."
---

# Correctness and Failure Paths

Use when designing or changing executable logic, error handling, guards, fallback behavior, or potentially unreachable paths.

Establish the expected observable behavior from the accepted requirement and the owning contract. Follow a concrete input, state, or call sequence through the relevant boundaries. Examine boundary values, partial failures, state transitions, retries, concurrency, and ordering where they can change that behavior. Distinguish a reachable case from an unsupported possibility.

- Trace guarantees from the owning trust boundary before adding null checks, type guards, or fallbacks. Preserve external-input validation and real failure handling; carry proved facts into internal values rather than repeating checks or spreading optional results through callers.
- Before removing apparently dead code, inspect its actual entrypoints, exports, registries, build aliases, and dynamic wiring as applicable. Bound this discovery to the candidate and its reachable connections.
- Compare the normal path with the error and recovery paths. Preserve return-value meaning, effects, API usage, useful runtime observability, and the legitimate responsibilities of callers.
- Check the strongest available explanation that would make an apparent defect valid: an upstream guard, caller constraint, existing test, history, or observed execution. State which evidence resolves the concern and which part remains unverified.

For a trusted-value, normal-flow, or competing-criteria question, use [Practical Design Foundations](../principle-design-foundations/SKILL.md). Use [Caller Obligations](../principle-caller-obligations/SKILL.md), [Responsibility and Change](../principle-responsibility-and-change/SKILL.md), or [Behavioral Verification](../principle-behavioral-verification/SKILL.md) for a distinct interface, ownership, or test-boundary question. Multiple lenses can explain one cause without requiring multiple changes.

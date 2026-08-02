---
name: api-review
description: Review changed caller-facing functions, module APIs, component props, hooks, services, commands, events, and schemas for ceremony, depth, abstraction level, compatibility, and expressive inputs. Use when a public or cross-module obligation changed.
---

# API Review

Review only callable interfaces and their cross-file caller obligations. Return draft findings; do not edit files or post comments.

## Review

1. Read complete changed files, every reachable call site, sibling APIs, tests, and local conventions.
2. Write the smallest ideal call site before judging the actual one. Compare setup/ordering/cleanup duties, required options, conversions, and error handling.
3. Check whether the interface is shaped around an implementation or first caller, whether a small interface hides meaningful behavior/invariants, and whether a custom class/manager/adapter could be a plain function, Promise, iterable, `AbortSignal`, discriminated union, or object.
4. Keep the API in one vocabulary. When positive composition evidence includes a caller-obligation or seam question, read [Feature Composition and Mechanism Primitives](../code/references/composition.md); report caller burden here and defer mechanism ownership to `$sb:architecture-review`.
5. Do not generalize a pass-through or add option sprawl without a concrete caller or independent mechanism. A one-caller primitive remains valid when its behavior/invariants/test surface are real.

## Output

Order findings by caller pain. Include severity, exact location, reachable call-site evidence, current and ideal call-site sketches, smallest API change, verification, migration notes, and a review-comment draft. Defer intent-only names to `$sb:intent-review` and general correctness to `$sb:code-review`. If no actionable finding remains, identify why the API is deep and low-ceremony.

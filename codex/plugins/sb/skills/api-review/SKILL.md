---
name: api-review
description: Review changed caller-facing functions, module APIs, component props, hooks, services, commands, events, and schemas for ceremony, depth, abstraction level, compatibility, and expressive inputs. Use when a public or cross-module obligation changed.
---

# API Review

Review only callable interfaces and their cross-file caller obligations. Return draft findings; do not edit files or post comments.

## Review

1. Read complete changed files, every reachable call site, sibling APIs, tests, and local conventions.
2. Write the smallest ideal call site before judging the actual one. Compare setup/ordering/cleanup duties, required options, conversions, and error handling.
3. For each materially distinct caller pattern, write a compact caller-obligation ledger and cite representative call sites: `caller goal | caller-owned policy | module-owned mechanics | leaked implementation knowledge | builtin alternative`. Group equivalent call sites instead of repeating the same obligations. Caller-owned policy is a product/domain decision the caller genuinely makes or observes. Module-owned mechanics include repeatable setup, ordering, cleanup, lifecycle, internal IDs, wrappers, callback wiring, provider configuration, conversions, and error protocol that the module can own completely.
4. Check whether the interface is shaped around an implementation or first caller, whether a small interface hides meaningful behavior/invariants, and whether a custom class/manager/adapter could be a plain function, Promise, iterable, `AbortSignal`, discriminated union, or object.
5. Judge module depth by caller leverage: prefer an interface that lets callers express domain intent while hiding implementation wiring, invariant enforcement, sequencing, and lifecycle. Do not optimize for fewer parameters when the removed concept is a legitimate caller decision.
6. Keep the API in one vocabulary. When positive composition evidence includes a caller-obligation or seam question, read [Feature Composition and Mechanism Primitives](../code/references/composition.md); report caller burden here and defer a distinct mechanism-placement or dependency-direction question to `$sb:architecture-review`.
7. Do not generalize a pass-through or add option sprawl without a concrete caller or independent mechanism. A one-caller primitive remains valid when its behavior/invariants/test surface are real.

## Output

Order candidate findings by caller pain and provisional severity; Main owns final disposition. Include the grouped caller-obligation ledger with representative call sites and the affected scope, exact location, reachable call-site evidence, current and ideal call-site sketches, material consequence, strongest checked disconfirming evidence, smallest interface change, verification, migration notes, and a review-comment draft. Defer a distinct ownership or dependency-direction question to `$sb:architecture-review`, intent-only names to `$sb:intent-review`, and general correctness to `$sb:code-review`. If no actionable finding remains, identify why the module is deep, high-leverage, and low-ceremony.

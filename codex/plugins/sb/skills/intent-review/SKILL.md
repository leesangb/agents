---
name: intent-review
description: Review whether changed names, types, values, props, effects, comments, runtime identity, abstractions, and tests make the reason and constraints of code visible. Use when a new name or abstraction may hide a concrete rationale.
---

# Intent Review

Review only the intent layer of the supplied scope. Return draft findings; do not edit files or post comments.

## Review layers

1. **Names:** describe the concept/result, avoid first-caller implementation detail, and make risky/legacy paths look risky.
2. **Types:** expose relationships and impossible states with discriminated unions, branded/readonly fields, or precise collections when in scope.
3. **Values:** name relationships behind ordering, thresholds, layering, or timing instead of magic numbers.
4. **Props/effects:** encode behavior through variants, callback presence, or composition; separate unrelated effects and triggers.
5. **Structure/comments:** use names and boundaries for steps; comments explain why, not what.
6. **Runtime/tests:** preserve useful component/function/log identity and make tests state the observable guarantee rather than internal state or call order.
7. **Abstractions:** preserve important underlying API freedom and prefer composition over prop expansion when it makes intent clearer.

Read full changed files, call sites, local analogues, wrappers, effects, request abstractions, and tests. For each finding include severity, precise location, reachable evidence, the intent that is currently implicit, a small naming/type/structure sketch, verification, and a review-comment draft. Defer general bugs, ownership, and API-shape concerns to their capabilities. If nothing actionable remains, return a concise good-as-is assessment.

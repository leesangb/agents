---
name: architecture-review
description: Review structural design, hidden concepts, change axes, responsibility ownership, dependency direction, circularity, and long-term maintenance cost. Use when a code change moves ownership or introduces a real mechanism/composition boundary.
---

# Architecture Review

Review the exact changed scope and directly caused neighbors. Return draft findings only; do not edit files or post comments.

## Review

- Read full changed files, nearby screen/flow/package/layer code, direct callers, tests, discussion, and learnings.
- Identify what changes together and whether screen/flow policy, rules, URL/query conversion, validation, rendering, external integration, and error policy are mixed.
- Look for hidden concepts such as Filter, Selection, DateRange, Disclosure, Pagination, QueryStateSync, Policy, Lifecycle, or Draft when states/rules/transitions/transformations already move together. Do not introduce concepts merely to reduce repetition.
- When the review question concerns use-case structure, value or effect boundaries, module depth, ownership, or abstraction timing, read [Practical Design Foundations](../code/references/design-foundations.md) and apply only the questions supported by reachable evidence. The reference alone does not create a finding.
- When the review question includes positive composition evidence, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) and assess the concrete ownership or dependency-direction question. Composition classification alone does not select this review.
- Check page/flow orchestration versus capability ownership, physical versus logical boundaries, model/React lifecycle separation, tests at rule/UI/flow boundaries, premature Providers/Managers/Services/Adapters, dependency cycles, and the problem/cost tradeoff.

## Output

Order findings by architectural risk. Include severity, precise location, reachable evidence, mixed axis/hidden concept/ownership/dependency issue, smallest structural improvement, logical boundary, behavior-preserving prefactor if needed, and verification. If no actionable finding remains, state why the structure is balanced.

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
- Treat newly introduced or distributed ownership as an ownership change even when no existing responsibility literally moved. Trace who now knows the sequence, invariant, lifecycle, or failure contract and whether one owner can enforce it completely.
- When the review question concerns use-case structure, value or effect boundaries, module depth, ownership, or abstraction timing, read [Practical Design Foundations](../code/references/design-foundations.md) and apply only the questions supported by reachable evidence. Start with the observed maintenance burden or reachable risk; the reference alone does not create a finding or justify structural cost.
- When the review question includes positive composition evidence, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) and assess the concrete ownership or dependency-direction question. Composition classification alone does not select this review.
- Check page/flow orchestration versus capability ownership, physical versus logical boundaries, model/React lifecycle separation, tests at rule/UI/flow boundaries, premature Providers/Managers/Services/Adapters, dependency cycles, and the problem/cost tradeoff.

## Output

Order findings by architectural risk. Include provisional severity, precise location, reachable evidence, the ownership or dependency issue and its consequence, smallest structural improvement, and verification. Explain the logical boundary or a behavior-preserving prefactor when needed to understand the correction. If no actionable finding remains, state why the structure is balanced.

# Composition and Mechanisms

Use when placing feature-specific assembly policy or deciding whether an independent mechanism merits its own contract. Begin with the accepted use case and actual or explicitly proposed call flow.

## Compose Requirement Policy

Keep requirement-owned ordering, branching, state transitions, failure/recovery policy, and lifecycle at the highest requirement-specific assembly point. That point expresses what this feature does and combines existing module interfaces. A feature that coordinates two or more interfaces supplies concrete composition evidence; a direct use case can remain one honest procedure when it needs no such coordination.

Keep reusable modules responsible for their promised behavior rather than teaching them the vocabulary and orchestration of one feature. Use the domain's actual concepts where they belong; independence means freedom from incidental first-caller policy, not erasing domain meaning. The feature chooses legitimate policy while each mechanism owns the mechanics it can enforce completely.

This keeps the requested behavior visible and makes a product-policy change local to its assembly. A generic coordinator, common layer sequence, or configuration surface is worthwhile only when its current contract removes a demonstrated burden.

## Extract a Mechanism From Its Obligation

A mechanism earns a separate owner when it has a meaningful obligation independent of one use-case sequence: an invariant, state/lifecycle, scheduling/order, retry/cancellation/cleanup, error/performance contract, or test surface. Identify that obligation and its smallest useful interface before naming a manager, service, adapter, or helper.

One caller can justify a mechanism with a real independent obligation; several similar call sites alone do not establish one.

## Keep the Seam Honest

When an interface, owner, dependency direction, caller obligation, verification responsibility, or composition wiring changes, compare the previous and proposed responsibilities. Identify who knows the policy and who can enforce the mechanism. Ground this comparison in the accepted feature and the identified mechanism's promise.

## Evidence and Counter-Signals

Ground the choice in the use case, existing interfaces, policy, independent obligation, proposed owner/interface, and relevant caller/dependency changes. A short call flow can make those facts clear without a fixed recording template.

Preserve legitimate caller policy and independent reasons to change. A pass-through that adds no contract, hidden feature policy inside a reusable mechanism, or a merged owner spanning independent concerns argues against the proposed structure.

## Related Questions

- If the proposed interface leaves a question about hidden mechanics or caller leverage, use [Deep Modules](deep-modules.md).
- If an identified mechanism has competing owners or leaks update knowledge across modules, use [Responsibility and Change](responsibility-and-change.md).

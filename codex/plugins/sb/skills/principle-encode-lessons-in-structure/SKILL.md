---
name: principle-encode-lessons-in-structure
description: "Prevent demonstrated recurring mistakes through ownership, types, or executable checks that reject the bad case."
---

# Encode Recurring Lessons in Structure

Use when preventing a demonstrated recurring mistake in a scoped repository. The recurring defect and accepted change boundary must be established before choosing an enforcement mechanism.

## Choose the Smallest Effective Enforcement

Consider, in this order, only changes whose benefit justifies their cost:

- **Ownership or representation:** one owner for state and rules, derived facts instead of hand-synced lists, deliberate module exports, or removal of an obsolete internal path.
- **Types:** represent a real invariant or construction contract so the demonstrated bad state cannot be expressed.
- **An executable check:** when the failure is mechanically recognizable, use a focused lint, schema, or CI check that explains the correction. Scope adoption to new violations if unrelated existing code cannot be migrated within the accepted task.
- **A behavior test:** protect the real failure through the boundary that owns it, using existing test infrastructure where possible.
- **Guidance:** preserve judgment, rationale, or external constraints that a mechanism cannot enforce. Put it in the relevant existing skill or documentation rather than creating another rule index.

Preserve caller contracts, trust-boundary validation, and required compatibility. A stronger mechanism is not automatically a better change if it introduces more cost or exceeds the authorized scope.

## Evidence

Verify that the chosen mechanism rejects a real past mistake or a representative reproduction and accepts the supported behavior. Use the same check locally and in CI when adding CI enforcement. Missing rejection evidence remains unverified.

Remove obsolete guidance only when the mechanism covers the same obligation completely; keep useful contract and rationale documentation.

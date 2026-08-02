# Feature Composition and Mechanism Primitives

Use this reference only after the router or caller records concrete evidence for at least one positive branch below.

## Positive Gate

### Feature Composition

Pass when a new capability coordinates at least two existing module interfaces and requirement policy determines an interaction such as ordering or branching, a state transition, error or rollback behavior, permissions or validation, persistence/cache/network policy, or lifecycle.

Record:

- New capability:
- Existing mechanisms:
- Requirement-owned policy:
- Top-level composition root:

### Mechanism Emergence

Pass when behavior that can be named without requirement vocabulary owns at least one independent obligation: an invariant, state or lifecycle, ordering/buffering/scheduling, retry/cancellation/cleanup, error or performance contract, or test surface.

Record:

- Candidate mechanism:
- Independent obligation:
- Smallest interface:
- Lowest owning module:

### Seam Change

Pass when the current work creates or changes an interface, moves ownership, changes dependency direction or caller obligations, relocates test responsibility, or wires a mechanism at a composition root.

Record:

- Changed seam:
- Previous caller obligation:
- New caller obligation:
- Dependency direction:

If no branch has concrete code, call-site, behavior, or test evidence, record `composition evidence: none` and stop this analysis.

## Design Result

- Start from the desired top-level call.
- Compose existing mechanisms at the highest requirement-specific assembly point.
- Extract a new primitive only from mechanism-emergence evidence.
- Keep mechanism vocabulary independent of requirement vocabulary.
- Put invariant, lifecycle, and test ownership in the lowest owning module behind the smallest useful interface.
- Prefer language-native functions, callbacks, and data before custom seams.
- Test mechanism behavior through its interface and requirement policy at the composition root.

## Independent Decisions

Composition evidence does not itself choose Fast, Deep, or Ultra; authorize a new abstraction; or select a reviewer.

- Use Fast when target, behavior, verification, ownership, interface, and dependency direction are known.
- Use Deep when a plan-changing ownership, interface, or dependency-direction decision remains unresolved.
- Select a reviewer only for a separate concrete review question left by the plan or diff.

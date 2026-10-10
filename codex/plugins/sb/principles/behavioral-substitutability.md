# Behavioral Substitutability

Use for inheritance, implementations, abstract contracts, extension points, or mutable domain state. Apply the behavioral questions across languages; type and visibility mechanisms depend on the actual runtime.

Prioritize behavioral correctness, domain invariants, encapsulation, responsibility/coupling, type integrity, then safe evolution.

Establish the semantic contract from accepted requirements, documentation, real callers, sibling implementations, tests, and observed behavior. A matching signature supplies only part of that contract.

## Preserve Substitution

An implementation or subtype must preserve supported uses of its abstraction. Check preconditions, postconditions, invariants, return meaning, error semantics, ordering, synchronous versus deferred completion, and caller-visible effects such as logging, persistence, network activity, events, analytics, or cache mutation. Stronger preconditions, weaker guarantees, or surprising effects need an explicit contract change.

Use inheritance for a supported behavioral is-a relationship. When the relationship is implementation reuse or independent variation, compare composition. Preserve legitimate inheritance when substitution and invariants remain sound.

## Give Invariants an Owner

Trace relevant invariants through construction, use, and teardown. Identify who keeps each invariant true, including whether a supposedly complete operation requires a caller to inspect state and perform hidden follow-up work. Separate that implicit obligation from documented caller-owned lifecycle or policy.

Control mutable state and construction/mutation boundaries. Public members create compatibility promises; protected members form an inheritance interface; private state can protect invariants. A protected hook may preserve an invariant better than protected mutable state. Visibility must serve the supported contract rather than test convenience.

Use domain concepts instead of incidental storage/framework/vendor representations. Check contradictory states, ambiguous primitives, incomplete construction represented as optionality, and type escapes that bypass meaningful constraints. In TypeScript, compare narrowing, discriminated unions, branded/literal types, generics, `readonly`, and `satisfies` where they encode a real invariant; wrappers and classes must justify their cost.

## Keep Evolution Grounded

Check unrelated reasons to change, mixed policy and infrastructure, shallow abstractions, overly concrete public types, inheritance lock-in, and hidden lifecycle or effect obligations. An evolution concern needs a plausible change axis from current requirements, existing variation, nearby implementations, or tests. Recommend the smallest contract-preserving correction and compare valid alternatives with their costs.

Use [Caller Obligations](caller-obligations.md) and [Responsibility and Change](responsibility-and-change.md) for the related interface and ownership questions.

# Intent and Contracts

Use when names, types, values, effects, documentation, or abstractions need to make a concrete meaning or constraint visible.

- **Names:** express the target's meaning and contract. Distinguish that meaning from the first caller's purpose or a familiar pattern label. Make risky or legacy paths recognizable.
- **Types:** expose real relationships and exclude meaningful impossible states with precise collections, readonly/branded values, or discriminated alternatives when the benefit justifies their cost.
- **Values:** make relationships behind ordering, thresholds, layering, or timing visible instead of relying on unexplained literals.
- **Inputs and effects:** express behavior with honest variants, callback presence, or composition. Separate unrelated effects and triggers.
- **Structure and documentation:** use names and boundaries to reveal implementation steps. Interface documentation explains otherwise unclear return meaning, units, ranges, effects, or ordering. Keep that caller-visible contract distinct from implementation rationale; document the parts that need explanation.
- **Runtime identity and test names:** preserve useful function/component/log identity and make a test's stated guarantee clear. Use [Behavioral Verification](behavioral-verification.md) to judge what its assertions prove.
- **Abstractions:** preserve important freedom of underlying APIs. Compare composition with expanding options or props when it makes the intended behavior clearer.

Check declarations against actual use sites, wrappers, effects, local analogues, and relevant tests. Identify the currently implicit intent and its concrete consequence before changing a name, type, or structure. Distinguish a naming correction from a change to behavior or the domain model; use [Caller Obligations](caller-obligations.md) or [Responsibility and Change](responsibility-and-change.md) when the issue is the contract itself.

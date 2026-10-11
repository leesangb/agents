---
name: principle-simplicity-and-coupling
description: "Simplify caller knowledge, change scope, and navigation while preserving contracts; use for separation, merging, inlining, or deletion."
---

# Simplicity and Coupling

Use when selecting a simpler design or considering separation, consolidation, inlining, or deletion of code, state, abstractions, or verification.

Judge simplicity by caller knowledge, change scope, and the navigation needed to understand one behavior. More code can be simpler when it removes an unnecessary dependency. Line, file, or abstraction counts alone do not establish the result.

- Derive concepts from current requirements, behavior, callers, and tests. Ask which concepts should vary independently and why one currently forces the other to change.
- Distinguish repeated syntax from shared semantics or knowledge. Centralize what should change together; retain separation for different reasons to change. Check whether a language/runtime builtin already expresses the contract.
- Look for coordinated edits, incidental ordering, callers knowing internals, and one representation serving independent purposes. Preserve information needed by another current concern; losing it may force that concern to depend on an earlier operation or reconstruct facts.
- Preserve coupling required by domain relationships and consistency invariants. Separation needs a concrete independent-change case, not just technical separability or a hypothetical consumer.
- Compare each proposed separation, merge, inline, or deletion by caller burden, change scope, navigation, added code/indirection, runtime cost, and cognitive overhead. Keep the existing design when the comparison does not justify a change.
- Inspect requirement overshoot, duplicate facts/transformations, redundant paths, obsolete compatibility/fallback residue, temporary helpers/flags/logs, dependencies, and implementation-coupled tests where the current task supplies evidence.

Preserve the accepted observable contract, invariants, verification meaning, validation, security, accessibility, error handling, and performance. Challenge candidates through reachable callers and failure/retry/migration paths. An incomplete proof or a necessary contract/ownership change is a reason to resolve that decision before simplifying.

Explain the concrete unnecessary dependency or work, the smallest correction, its benefit and added cost, and what evidence would defeat it.

## Related Questions

- If the change case depends on the legitimacy of caller duties or configuration, use [Caller Obligations](../principle-caller-obligations/SKILL.md).
- If the cost comparison leaves responsibility or dependency placement unresolved, use [Responsibility and Change](../principle-responsibility-and-change/SKILL.md).

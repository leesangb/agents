---
name: principle-simplicity-and-coupling
description: "Reduce caller knowledge, navigation, and hidden or duplicated state while preserving contracts; use for separation, merging, inlining, deletion, or deriving values."
---

# Simplicity and Coupling

Use when selecting a simpler design or considering separation, consolidation, inlining, or deletion of code, state, abstractions, or verification.

Judge simplicity by caller knowledge, change scope, the indirections a reader must follow, and the mutable context they must remember to understand one behavior. A flat module can still be hard to understand when hidden state drives its results. More code can be simpler when it removes an unnecessary dependency; line, file, or abstraction counts alone do not establish the result.

- Derive concepts from current requirements, behavior, callers, and tests. Ask which concepts should vary independently and why one currently forces the other to change.
- Distinguish repeated syntax from shared semantics or knowledge. Centralize what should change together; retain separation for different reasons to change. Check whether a language/runtime builtin already expresses the contract.
- Give each fact one authoritative owner and derive dependent values instead of storing copies that callers must keep synchronized. Keep mutation local. Snapshots, independently editable drafts, and caches can earn separate state through a real temporal, ownership, or performance requirement; make capture, commit, or invalidation semantics explicit.
- Look for coordinated edits, incidental ordering, callers knowing internals, and one representation serving independent purposes. Preserve information needed by another current concern; losing it may force that concern to depend on an earlier operation or reconstruct facts.
- Preserve coupling required by domain relationships and consistency invariants. Separation needs a concrete independent-change case, not just technical separability or a hypothetical consumer.
- Compare each proposed separation, merge, inline, or deletion by caller burden, change scope, navigation, added code/indirection, runtime cost, and cognitive overhead. Keep the existing design when the comparison does not justify a change.
- Inspect requirement overshoot, duplicate facts/transformations, redundant paths, obsolete compatibility/fallback residue, temporary helpers/flags/logs, dependencies, and implementation-coupled tests where the current task supplies evidence.

Preserve the accepted observable contract, invariants, verification meaning, validation, security, accessibility, error handling, and performance. Challenge candidates through reachable callers and failure/retry/migration paths. An incomplete proof or a necessary contract/ownership change is a reason to resolve that decision before simplifying.

Explain the concrete unnecessary dependency or work, the smallest correction, its benefit and added cost, and what evidence would defeat it.

## Related Questions

- If the change case depends on the legitimacy of caller duties or configuration, use [Caller Obligations](../principle-caller-obligations/SKILL.md).
- If the cost comparison leaves responsibility or dependency placement unresolved, use [Responsibility and Change](../principle-responsibility-and-change/SKILL.md).

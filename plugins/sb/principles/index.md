# Shared Principles

The `principle-*` skills are the canonical judgment criteria. Their descriptions expose the trigger and core rule during skill discovery; this index provides navigation during investigation, planning, implementation, and review. Select from concrete source/caller evidence, an accepted requirement or proposed use case, or an explicitly requested concern. Read the selected files before applying or citing them. Start with the file that owns the concrete question. Read a linked criterion only when an unanswered question within the task needs that criterion; choose additional files for distinct questions rather than traversing the link graph. A task can need several principles when it genuinely contains several questions.

| Principle | Read When |
| --- | --- |
| [Experience First](../skills/principle-experience-first/SKILL.md) | Product, UX, API, or feature-scope choices trade the consuming user's core experience against implementation convenience. |
| [Correctness and Failure Paths](../skills/principle-correctness-and-failure-paths/SKILL.md) | Executable logic, guards, errors, recovery, or reachability changes. |
| [Caller Obligations](../skills/principle-caller-obligations/SKILL.md) | What must each real caller do or know, which setup, configuration, lifecycle, or error duties belong to that caller, and could a language/runtime builtin express the API contract? |
| [Composition and Mechanisms](../skills/principle-composition-and-mechanisms/SKILL.md) | Where should feature-specific ordering/branching/recovery policy be assembled, or does a proposed mechanism have an independent obligation? |
| [Deep Modules](../skills/principle-deep-modules/SKILL.md) | How much useful behavior does this interface provide for the knowledge and duties it requires, and would deepening or a seam improve that tradeoff? |
| [Responsibility and Change](../skills/principle-responsibility-and-change/SKILL.md) | Who should own an identified responsibility, which modules share its design knowledge, and how should dependencies or coordinated edits change? |
| [Intent and Contracts](../skills/principle-intent-and-contracts/SKILL.md) | Names, types, values, effects, documentation, or abstractions need to expose a concrete meaning or constraint. |
| [Behavioral Substitutability](../skills/principle-behavioral-substitutability/SKILL.md) | Implementations, inheritance, extension contracts, or mutable domain invariants change. |
| [Behavioral Verification](../skills/principle-behavioral-verification/SKILL.md) | Writing tests that express API/function guarantees, choosing verification boundaries/scenarios, or assessing behavior evidence. |
| [Operational Safety](../skills/principle-operational-safety/SKILL.md) | A concrete trust, data, recovery, compatibility, lifetime, concurrency, resource, or performance question exists. |
| [Requirement Fidelity](../skills/principle-requirement-fidelity/SKILL.md) | Mapping a plan, implementation, or proof to explicit accepted requirements. |
| [Simplicity and Coupling](../skills/principle-simplicity-and-coupling/SKILL.md) | Can separation, merging, inlining, deletion, or deriving values reduce coupling, navigation, hidden mutable context, or synchronization duties while preserving the contract? |
| [Practical Design Foundations](../skills/principle-design-foundations/SKILL.md) | Competing criteria need a judgment priority, or the question concerns trusted values, values/effects, or normal-flow visibility. |
| [Separate Independent State](../skills/principle-separate-shared-state/SKILL.md) | Deciding whether concurrent actors need shared mutable state or serialization. |
| [Re-execution Safety](../skills/principle-reexecution-safety/SKILL.md) | A state-changing operation permits retry or resume after partial failure. |
| [Sequence Verifiable Units](../skills/principle-verifiable-units/SKILL.md) | A multi-step sweep or migration has dependent changes. |
| [Challenge a Repeatedly Failing Premise](../skills/principle-challenge-shared-premise/SKILL.md) | Prior fixes sharing one premise repeatedly fail. |
| [Recover the Contract Behind Defensive Code](../skills/principle-defensive-history/SKILL.md) | Changing/removing a defensive path whose reason is unclear. |
| [Validate Performance and Evaluation Claims](../skills/principle-performance-evidence/SKILL.md) | Interpreting performance measurements or evaluation scores, comparing equivalent completed work, or judging whether an improvement transfers. |
| [Build the Lever](../skills/principle-build-the-lever/SKILL.md) | A transformation, analysis, or verification can be made more reliable and reviewable through a small rerunnable tool. |
| [Encode Recurring Lessons in Structure](../skills/principle-encode-lessons-in-structure/SKILL.md) | Preventing a demonstrated recurring repository mistake. |
| [Decision Trail](../skills/principle-decision-trail/SKILL.md) | Material decisions in long-running, unattended, or multi-session work would otherwise be lost. |

The skills contain mode-neutral judgment, not separate execution workflows. Workflows own scope, authorization, roles, execution, reviewer selection, and reporting; invoking a principle does not authorize edits or external effects. Specialist details can link to another principle when a distinct question arises. Keep each criterion in one canonical skill body and explain the evidence-backed choice it changes, including relevant limits and counter-signals.

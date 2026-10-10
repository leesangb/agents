# Shared Principles

Use this index during investigation, planning, implementation, and review to find the judgment criteria for the current task. Select from concrete source/caller evidence, an accepted requirement or proposed use case, or an explicitly requested concern. Read the selected files before applying or citing them. Start with the file that owns the concrete question. Read a linked criterion only when an unanswered question within the task needs that criterion; choose additional files for distinct questions rather than traversing the link graph. A task can need several principles when it genuinely contains several questions.

| Principle | Read When |
| --- | --- |
| [Correctness and Failure Paths](correctness-and-failure-paths.md) | Executable logic, guards, errors, recovery, or reachability changes. |
| [Caller Obligations](caller-obligations.md) | What must each real caller do or know, which setup, configuration, lifecycle, or error duties belong to that caller, and could a language/runtime builtin express the API contract? |
| [Composition and Mechanisms](composition-and-mechanisms.md) | Where should feature-specific ordering/branching/recovery policy be assembled, or does a proposed mechanism have an independent obligation? |
| [Deep Modules](deep-modules.md) | How much useful behavior does this interface provide for the knowledge and duties it requires, and would deepening or a seam improve that tradeoff? |
| [Responsibility and Change](responsibility-and-change.md) | Who should own an identified responsibility, which modules share its design knowledge, and how should dependencies or coordinated edits change? |
| [Intent and Contracts](intent-and-contracts.md) | Names, types, values, effects, documentation, or abstractions need to expose a concrete meaning or constraint. |
| [Behavioral Substitutability](behavioral-substitutability.md) | Implementations, inheritance, extension contracts, or mutable domain invariants change. |
| [Behavioral Verification](behavioral-verification.md) | Choosing verification boundaries/scenarios or assessing behavior evidence. |
| [Operational Safety](operational-safety.md) | A concrete trust, data, recovery, compatibility, lifetime, concurrency, resource, or performance question exists. |
| [Requirement Fidelity](requirement-fidelity.md) | Mapping a plan, implementation, or proof to explicit accepted requirements. |
| [Simplicity and Coupling](simplicity-and-coupling.md) | Can a separation, merge, inline, or deletion preserve the contract while reducing concrete coupling, change scope, or navigation cost? |
| [Practical Design Foundations](design-foundations.md) | Competing criteria need a judgment priority, or the question concerns trusted values, values/effects, or normal-flow visibility. |
| [Separate Independent State](separate-shared-state.md) | Deciding whether concurrent actors need shared mutable state or serialization. |
| [Re-execution Safety](reexecution-safety.md) | A state-changing operation permits retry or resume after partial failure. |
| [Sequence Verifiable Units](verifiable-units.md) | A multi-step sweep or migration has dependent changes. |
| [Challenge a Repeatedly Failing Premise](challenge-shared-premise.md) | Prior fixes sharing one premise repeatedly fail. |
| [Recover the Contract Behind Defensive Code](defensive-history.md) | Changing/removing a defensive path whose reason is unclear. |
| [Validate a Performance Claim](performance-evidence.md) | Measuring performance or choosing an option from benchmark evidence. |
| [Encode Recurring Lessons in Structure](encode-lessons-in-structure.md) | Preventing a demonstrated recurring repository mistake. |
| [Decision Trail](decision-trail.md) | Material decisions in long-running, unattended, or multi-session work would otherwise be lost. |

The files contain mode-neutral judgment. Workflows own scope, approval, roles, execution, reviewer selection, and reporting; reading a principle does not change those permissions. Specialist details can link to another principle when a distinct question arises. Keep a criterion in one home and explain the evidence-backed choice it changes, including relevant limits and counter-signals.

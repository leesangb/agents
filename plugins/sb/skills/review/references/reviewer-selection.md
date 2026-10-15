# Reviewer Selection

Main selects independent axes for concrete questions supported by the artifact or accepted requirement. An axis selects criterion skills, not a separate reviewer workflow. These gates select independent help; Main's review coverage is established before delegation and is not limited to the selected axes. A changed caller contract or design choice can support a question before a defect is known, and passing tests do not resolve whether that choice is justified. Start with no reviewers; positive evidence earns each selection. Mechanical, generated, documentation-only, and tiny changes ordinarily need only Main's focused review unless independent review is explicitly requested.

## Axes and Positive Gates

| Axis | Select when | Judgment criteria |
| --- | --- | --- |
| `correctness` | An explicit general code review covers a non-trivial executable diff, or non-mechanical logic leaves a correctness, regression, maintainability, dead-code, or leaky-abstraction question after deterministic checks. | [Correctness and Failure Paths](../../principle-correctness-and-failure-paths/SKILL.md) |
| `tests` | Observable behavior changed and there is a question about verification placement, missing scenarios, or whether tests prove behavior. | [Behavioral Verification](../../principle-behavioral-verification/SKILL.md) |
| `api` | A changed callable, cross-module interface, or call-site composition changes a caller obligation: setup, order, cleanup, lifecycle, errors, IDs, wrappers, callbacks, configuration, conversions, or a plausible builtin. Concrete evidence for one such obligation suffices; a signature change or known defect is not required. | [Caller Obligations](../../principle-caller-obligations/SKILL.md); [Deep Modules](../../principle-deep-modules/SKILL.md) when the question concerns depth or hidden mechanics. |
| `architecture` | Responsibility or dependency direction changed and a distinct placement, depth, or change-axis question remains, such as two credible owners or hidden stateful mechanics. Caller pain alone does not select this axis. | [Responsibility and Change](../../principle-responsibility-and-change/SKILL.md); [Deep Modules](../../principle-deep-modules/SKILL.md) when the question concerns structural depth or locality. |
| `intent` | A new abstraction, type, public name, or changed documentation may hide a concrete meaning, constraint, or rationale. | [Intent and Contracts](../../principle-intent-and-contracts/SKILL.md) |
| `oop` | Inheritance, implementations, extension surfaces, mutable invariants, or substitution changed and a concrete behavioral-contract question exists. | [Behavioral Substitutability](../../principle-behavioral-substitutability/SKILL.md) |
| `risk` | Trust, data mutation/deletion, migrations, rollout/configuration, shared state/cache, lifetimes, concurrency, or performance-sensitive paths leave a concrete failure, recovery, security, resource, or operational question after verification. | [Operational Safety](../../principle-operational-safety/SKILL.md) |
| `spec` | Mapping an explicit specification or acceptance criterion to the artifact leaves a concrete compliance/omission question. | [Requirement Fidelity](../../principle-requirement-fidelity/SKILL.md) |

Read [Composition and Mechanisms](../../principle-composition-and-mechanisms/SKILL.md) only when composition evidence helps identify a concrete API or architecture question. Composition evidence alone does not satisfy their gates. Use [Analyze](../../analyze/SKILL.md) before review when behavior or impact still needs bounded investigation.

## Profiles and Caps

Caps are upper bounds, never required counts. Caller-provided profiles/caps override generic scope caps. An auditor never consumes a reviewer slot.

- **Deep:** at most three signal-matched axes. When correctness is selected, include material simplification supported by [Simplicity and Coupling](../../principle-simplicity-and-coupling/SKILL.md): requirement overshoot, duplicate state/paths, unnecessary abstractions/dependencies/residue, and behavior-preservation evidence. Keep safeguards intact.
- **Ultra:** at most two roster axes, plus at most one supplemental `simplicity` reviewer outside that cap. Select the supplement only for a concrete new abstraction, duplicate state/path, transitional residue, independently changing concepts coupled together, or material complexity whose question remains after verification. Use [Simplicity and Coupling](../../principle-simplicity-and-coupling/SKILL.md); otherwise record it as skipped.
- **Plan review:** Ultra-only, for expensive-to-reverse decisions; at most two signal-matched axes from the plan and decision context.
- **Generic:** small scope at most one; medium at most three; large cross-module or contract-changing scope at most four. Name omitted perspectives only when they affect the conclusion.

## Concern Ownership

API owns the caller mental model, obligations, ceremony, leaked knowledge, and depth through caller leverage. Architecture owns the distinct question of placement, cohesion, structural depth, and dependency direction. Retain one finding when one lens merely supports the other; do not pair them automatically.

OOP owns semantic substitution, encapsulation, and domain-invariant concerns. Consolidate overlapping simplicity/coupling concerns under API or architecture when that axis owns the cause. Retain an overlapping correctness concern only when it independently demonstrates a runtime correctness or maintainability risk. Coupling alone does not select another reviewer.

[Finding Contract](finding-contract.md) owns severity, optional-suggestion policy, and disposition for every axis.

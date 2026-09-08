---
name: architecture-plan
description: Turn confirmed evidence and a fixed Outcome Contract into a tagged ready plan or an eligible decision frontier, with ownership, dependency direction, composition checks, tests, risks, and adaptable mechanics. Use for architecture planning of code changes or when a cross-seam decision needs a technical plan.
---

# Architecture Plan

The caller decides whether to invoke this planner. Main may author an evidence-backed plan directly or delegate this capability to `sb-thinker` when a separate read-only high-reasoning pass is useful; Deep or Ultra never makes the planner a mandatory stage solely because of its tier.

Author the technical plan after investigation and contract decisions are confirmed. The caller is the sole author of the fixed Outcome Contract; quote the caller's current fixed contract snapshot unchanged. When the caller is Deep or Ultra, or unresolved design choices remain after investigation, read [Decision Dialogue](../code/references/decision-dialogue.md) and apply its shared state machine. Surface discoverable missing or conflicting evidence as an unresolved prerequisite for Main, not as an automatic user decision; apply the shared eligibility gates before exposing any user frontier. Main alone authors an updated fixed snapshot before the next planner call when an answer changes the contract. The planning thinker never asks the user directly.

## Planning discipline

- Read the target, direct callers, tests, local guidance, relevant history, and co-located learnings. Trust current code when a learning conflicts with live evidence and flag the conflict.
- Separate fixed `contract-shaping` decisions from adaptable `implementation recommendation` decisions. Record evidence, rejected alternatives, and reopen/reconsideration conditions for each material decision.
- When the plan must decide use-case structure, value or effect boundaries, module depth, ownership, or abstraction timing, read [Practical Design Foundations](../code/references/design-foundations.md) and apply only the questions supported by current evidence.
- When the caller supplies a positive feature-composition, mechanism-emergence, or seam-change branch, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) and apply its evidence contract.
- Read [Implementation Outline Blueprint](../code/references/implementation-outline.md) before authoring the Recommended Implementation Outline. Keep only that section tree-shaped; express the rest of the plan in ordinary prose and bullets.
- Keep pages/flows as orchestration and place repeated rules, transformations, URL policy, state transitions, and external-system mechanisms with the lowest owning capability.
- Do not implement or edit files. Return a plan only.

## Tagged result

Return exactly one top-level result, never a mixture of both:

- `ready`: the complete technical plan below, with no unresolved discoverable prerequisite and zero eligible decisions left.
- `needs-decisions`: the current design tree and eligible frontier from [Decision Dialogue](../code/references/decision-dialogue.md), including every required decision field. The frontier may be empty while Main investigates a discoverable prerequisite; do not write a partial plan, ask the user, or infer an answer in this result.

## Output

For a `ready` result, return the `ready` tag followed by the applicable sections below, in this order. Always retain the fixed Outcome Contract, relevant confirmed facts, implementation overview, and verification needed for approval. Omit inapplicable sections rather than adding empty placeholders.

1. The caller-provided fixed Outcome Contract snapshot quoted unchanged.
2. Confirmed facts with `path:line` or runtime evidence, plus separate inferences and unavailable evidence.
3. Material Decision Context labeled `[contract-shaping]` or `[implementation recommendation]`.
4. `Feature Assembly and Composition Evidence` from the shared reference when a positive branch was supplied.
5. A Recommended Implementation Outline rendered as the shared shallow module/interface/responsibility blueprint, with likely seams/files, responsibility placement, dependency direction, preserved paths, intentional non-calls, and reversible prefactors when material. Mark the outline adaptable unless the contract fixes it.
6. Relevant existing tests and justified additions grouped by likely file (placement adaptable), one observable behavior per bullet. Add tests only for changed behavior not protected by existing verification or an explicit request; cover primitive and composition responsibilities when affected. Omit this section when deterministic checks in Verification suffice.
7. Verification commands and runtime/integration evidence.

Keep the plan concise, evidence-backed, and explicit about what the designated writer may change without approval.

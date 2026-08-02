---
name: architecture-plan
description: Turn confirmed evidence and a fixed Outcome Contract into a tagged ready plan or an eligible decision frontier, with ownership, dependency direction, composition checks, tests, risks, and adaptable mechanics. Use for architecture planning of code changes or when a cross-seam decision needs a technical plan.
---

# Architecture Plan

Author the technical plan after investigation and contract decisions are confirmed. The caller is the sole author of the fixed Outcome Contract; quote the caller's current fixed contract snapshot unchanged. When the caller is Deep or Ultra, or unresolved design choices remain after investigation, read [Decision Dialogue](../code/references/decision-dialogue.md) and apply its shared state machine. Surface discoverable missing or conflicting evidence as an unresolved prerequisite for Main, not as an automatic user decision; apply the shared eligibility gates before exposing any user frontier. Main alone authors an updated fixed snapshot before the next planner call when an answer changes the contract. The planning thinker never asks the user directly.

## Planning discipline

- Read the target, direct callers, tests, local guidance, relevant history, and co-located learnings. Trust current code when a learning conflicts with live evidence and flag the conflict.
- Separate fixed `contract-shaping` decisions from adaptable `implementation recommendation` decisions. Record evidence, rejected alternatives, and reopen/reconsideration conditions for each material decision.
- When the caller supplies a positive feature-composition, mechanism-emergence, or seam-change branch, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) and apply its evidence contract.
- Keep pages/flows as orchestration and place repeated rules, transformations, URL policy, state transitions, and external-system mechanisms with the lowest owning capability.
- Do not implement or edit files. Return a plan only.

## Tagged result

Return exactly one top-level result, never a mixture of both:

- `ready`: the complete technical plan below, with no unresolved discoverable prerequisite and zero eligible decisions left.
- `needs-decisions`: the current design tree and eligible frontier from [Decision Dialogue](../code/references/decision-dialogue.md), including every required decision field. The frontier may be empty while Main investigates a discoverable prerequisite; do not write a partial plan, ask the user, or infer an answer in this result.

## Output

For a `ready` result, return the `ready` tag followed by these sections, in this order:

1. The caller-provided fixed Outcome Contract snapshot quoted unchanged.
2. Confirmed facts with `path:line` or runtime evidence, plus separate inferences and unavailable evidence.
3. Material Decision Context labeled `[contract-shaping]` or `[implementation recommendation]`.
4. `Feature Assembly and Composition Evidence` from the shared reference, or `None` when no positive branch was supplied.
5. A Recommended Implementation Outline with likely seams/files, responsibility placement, reversible prefactors, behavior changes, integration/cleanup, risks, and reopen conditions. Mark the outline adaptable unless the contract fixes it.
6. Tests grouped by likely file (placement adaptable), one observable behavior per bullet, including primitive-interface and composition tests when both layers exist.
7. Verification commands and runtime/integration evidence.

Keep the plan concise, evidence-backed, and explicit about what the worker may change without approval.

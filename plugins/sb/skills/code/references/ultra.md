# Ultra Code Change Workflow

Use after the [router](../SKILL.md) identifies high-cost risk, an explicit high-rigor request, or dependent long-running work.

Read [Planning and Resuming](planning.md) and [Decision Dialogue](decision-dialogue.md). They own required plan information, authorization, decision eligibility, and progress-based completion. Ultra rigor does not require another approval for work the existing implementation request permits.

## Investigate and Plan

- Main investigates relevant call/data flows, states, external effects, failure/recovery paths, and direct or indirect impact. An [`explorer`](../../../roles.md) with [Analyze](../../analyze/SKILL.md) can investigate a separate bounded concern.
- Main owns the fixed Outcome Contract and separates observed facts, inference, and unresolved decisions. Preserve exceptions and negative evidence when losing them could violate an invariant or repeat a dead end.
- For multi-session work with dependent investigations or decisions, keep the accepted outcome, evidence gaps, decision dependencies, and next bounded investigation in the [Decision Trail](../../principle-decision-trail/SKILL.md). Resume through the shared planning and authorization policy.
- Main authors the technical plan or delegates a distinct read-only concern to a `thinker` with [Architecture Plan](../../architecture-plan/SKILL.md). Apply Decision Dialogue until no discoverable prerequisite or eligible decision remains. Each delegated pass receives Main's fixed contract snapshot; only Main updates it between passes.
- For an expensive-to-reverse plan decision, use [Review](../../review/SKILL.md) with its Plan Review profile. Review is read-only and does not authorize implementation.
- Present the ready plan and continue within the existing grant. Return the plan for a planning-only request; pause only a consequential unresolved choice or step needing new authority. Include recovery, rollout, compatibility, or runtime verification when required by the actual risk.

## Implement and Converge

After authorization and resume validation, send the complete current plan and permitted effects to one writer: Main or a `worker` using [Implement](../../implement/SKILL.md). Keep that writer through fixes. Send material new context without narrowing the contract; reopen planning when it changes a contract-shaping decision.

Verify the requested behavior with required project checks and relevant runtime/integration evidence. Invoke [Review](../../review/SKILL.md) with the Ultra profile, actual diff, risk context, and verification. It owns selected reviewers, conditional audit, and the separately gated `simplicity` reviewer; none is selected solely to satisfy a count.

Apply supported scoped fixes, rerun affected checks, and revisit affected review claims. Continue until the contract, required behavior evidence, and blocker closure are satisfied. Follow the shared stopping criteria when scope/authority changes, progress stalls, or an external dependency blocks completion. Report remaining uncertainty explicitly.

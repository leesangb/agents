# Ultra Code Change Workflow

Use after the [router](../SKILL.md) identifies high-cost risk, an explicit high-rigor request, or dependent long-running work.

Read [Planning and Resuming](planning.md) and [Decision Dialogue](decision-dialogue.md). They own required plan information, explicit approval, decision eligibility, and progress-based completion.

## Investigate and plan

- Main investigates relevant call/data flows, states, external effects, failure/recovery paths, and direct or indirect impact. An `explorer` with `$sb:analyze` can investigate a separate bounded concern.
- Main owns the fixed Outcome Contract and separates observed facts, inference, and unresolved decisions. Preserve exceptions and negative evidence when losing them could violate an invariant or repeat a dead end.
- Use Wayfinder only when work exceeds one session and the route is still obscured by dependent investigations or decisions. Explain why and obtain approval before invoking it. After approval, state the requested outcome and create investigation/decision tickets; resolve no more than one ticket per session. Wayfinder remains planning-only until the resulting Ultra plan is confirmed.
- Main authors the technical plan or delegates a distinct read-only concern to `sb-thinker` with `$sb:architecture-plan`. Apply Decision Dialogue until no discoverable prerequisite or eligible decision remains. Each delegated pass receives Main's fixed contract snapshot; only Main updates it between passes.
- For an expensive-to-reverse plan decision, use `$sb:review-with-subagents` with its Plan Review profile. Review is read-only and does not authorize implementation.
- Present the ready plan and pause for explicit approval under the shared policy. Include recovery, rollout, compatibility, or runtime verification when required by the actual risk.

## Implement and converge

After approval and resume validation, send the complete approved plan to one writer: Main or a built-in `worker` using `$sb:implement`. Keep that writer through fixes. Send material new context without narrowing the contract; reopen planning when it changes a contract-shaping decision.

Verify the requested behavior with required project checks and relevant runtime/integration evidence. Invoke `$sb:review-with-subagents` with the Ultra profile, actual diff, risk context, and verification. It owns selected reviewers, conditional audit, and the separately gated simplifier; none is selected solely to satisfy a count.

Apply supported scoped fixes, rerun affected checks, and revisit affected review claims. Continue until the contract, required behavior evidence, and blocker closure are satisfied. Follow the shared stopping criteria when scope/authority changes, progress stalls, or an external dependency blocks completion. Report remaining uncertainty explicitly.

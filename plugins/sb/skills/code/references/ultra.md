# Ultra Code Change Workflow

Use after the [router](../SKILL.md) identifies high-cost risk, an explicit high-rigor request, or dependent long-running work.

Apply [Planning and Resuming](planning.md).

## Investigate and Plan

Investigate call/data flows, states, external effects, failure/recovery paths, and direct or indirect impact relevant to the risk. Establish the Outcome Contract and plan with recovery, rollout, compatibility, and runtime evidence where needed. Preserve exceptions and negative evidence that prevent invariant violations or repeated dead ends.

Use [Analyze](../../analyze/SKILL.md) or [Architecture Plan](../../architecture-plan/SKILL.md) for useful separate concerns. Read [Decision Dialogue](decision-dialogue.md) when a consequential choice remains unresolved. Use [Decision Trail](../../principle-decision-trail/SKILL.md) for dependent multi-session investigations and decisions. For an expensive-to-reverse plan decision, invoke [Review](../../review/SKILL.md) with its Plan Review profile.

## Implement and Converge

Main or one worker uses [Implement](../../implement/SKILL.md) with the current plan and permitted effects. Verify requested behavior through required project checks and relevant runtime/integration evidence. Invoke [Review](../../review/SKILL.md) with the Ultra profile, actual diff, risk context, and verification; it owns reviewer selection and conditional audit.

Apply supported scoped fixes, rerun affected checks, and revisit affected review claims. Resolve or report remaining uncertainty under the shared completion policy.

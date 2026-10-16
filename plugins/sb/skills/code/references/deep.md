# Deep Code Change Workflow

Use after the [router](../SKILL.md) identifies meaningful uncertainty or a caller/ownership contract change that can be handled in one bounded plan.

Apply [Planning and Resuming](planning.md).

## Investigate and Plan

Investigate the named uncertainty or changed obligation through target code, callers, verification, and relevant history. Establish the Outcome Contract and implementation direction from that evidence. Use [Analyze](../../analyze/SKILL.md) or [Architecture Plan](../../architecture-plan/SKILL.md) only for a useful separate investigation or planning concern. Read [Decision Dialogue](decision-dialogue.md) if a consequential choice remains unresolved. Deep has no separate plan-review panel.

When a novel module shape or interaction remains uncertain, compare small, structurally different sketches against the same use case and constraints. Prototype only the behavior that can decide between them, using authorized effects and isolated disposable state; read-only planning stays with sketches. Choose from observed evidence and concrete costs rather than polished prose. Established patterns need no competing prototypes, and there is no fixed candidate count.

## Implement, Verify, and Review

Main or one worker uses [Implement](../../implement/SKILL.md) with the current plan and permitted effects. Verify the contract, then invoke [Review](../../review/SKILL.md) with the Deep profile and actual diff/verification evidence; that skill owns reviewer selection and conditional audit.

Apply supported scoped fixes, rerun affected checks, and re-review affected claims. Resolve or report remaining review concerns. Reroute to Ultra if risk or dependent staged decisions exceed one bounded plan.

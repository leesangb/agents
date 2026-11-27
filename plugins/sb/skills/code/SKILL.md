---
name: code
description: Route implementation and planning requests that change product code, executable tooling, configuration, or agent workflows.
---

# Code Change Workflow Router

Route executable changes, including operational agent instructions. Use the relevant skill directly for prose, explanations, diagrams, and standalone visual artifacts; rendering code alone does not make an artifact a product change. Route only the executable portion of mixed requests.

When deciding whether a prompt or workflow revision improves agent behavior, use [Eval](../eval/SKILL.md) to compare the two versions on matched tasks. A comparison-only request ends with its verdict. For an implementation request, use that comparison as verification when a change in agent behavior is the acceptance criterion. Ordinary wording and packaging edits use their focused checks.

Read applicable local instructions, relevant code, callers, and nearby verification. Select one workflow and the task's criteria from [Shared Principles](../../principles/index.md); read only those files. Planning-only requests use the same routing.

For bug fixes, apply [Root-Cause Repair](../principle-root-cause-repair/SKILL.md) before proposing a repair. Before selecting Fast, trace the failing path through the shared API it calls. Could the path own the fix locally? Would fixing the shared API instead change observable behavior for a caller outside the incident? When both placements are plausible and their effects differ, select Deep (or retain Ultra) and run [Swarm](../swarm/SKILL.md) in arena mode. Give independent candidates the incident and caller contracts and let them determine the owner. When the requirement already specifies the shared behavior or the contract settles placement, continue with the ordinary tier gates.

## Select a Workflow

Apply these gates in order to actual behavior, contracts, and effects, not incidental mentions or file names:

1. **[Ultra](references/ultra.md)** for explicit ultra/max/thorough/full-path requests; changes affecting authentication, authorization, security, privacy, stored-data mutation/deletion, schema/migration/backfill, rollout, or production configuration behavior/contracts; external compatibility risk; or long-running coordination across dependent investigations, decisions, or environments.
2. **[PoC](references/poc.md)** for an explicitly disposable experiment with no Ultra signal. Speed wording alone is not experimental intent. Keeping or shipping a PoC returns here for production routing.
3. **[Deep](references/deep.md)** when a bounded read leaves cause, impact, product behavior, or a plan-changing design decision unresolved; when a caller-visible obligation or cross-package responsibility/dependency changes; or when investigation, competing designs, or an explicitly deep approach is the task. Name the concrete uncertainty or changed obligation.
4. **[Fast](references/fast.md)** when target, expected behavior, and verification are known and no earlier gate applies: a validated user plan, local reversible change, known cause with a focused check, mechanical transformation, or established nearby pattern.

If Fast eligibility is unclear, use Deep; high-cost or dependent staged uncertainty uses Ultra. File count and agent availability do not select a tier. Reroute when new evidence changes eligibility, scope, or risk, including when keeping a PoC.

## Ownership and Conditional References

Main owns routing, the user conversation, authority, and coordination. Fast and PoC are direct paths. Deep and Ultra may delegate concrete useful concerns using [Runtime Roles](../../roles.md): investigation with [Analyze](../analyze/SKILL.md), read-only planning with [Architecture Plan](../architecture-plan/SKILL.md), implementation with [Implement](../implement/SKILL.md), or independent review with [Review](../review/SKILL.md). Keep one implementation writer through fixes and fresh threads for independent review.

Fast, Deep, and Ultra read [Planning and Resuming](references/planning.md) for shared plan, authority, and completion rules. Read [Decision Dialogue](references/decision-dialogue.md) only when a consequential decision remains unresolved after investigation and reasonable defaults.

In Deep or Ultra, when two viable designs remain after inspecting the callers and choosing between them changes a caller contract or another material tradeoff, run [Swarm](../swarm/SKILL.md) in its arena mode before committing to one. Compare sketches for a planning request and keep one writer for production changes. Use Swarm's partitioned mode for distinct investigation questions.

Use [How](../how/SKILL.md) for requested runtime explanations, [Why](../why/SKILL.md) for historical rationale, [Blast Radius](../blast-radius/SKILL.md) for safety assumptions beyond the diff, and [Hillclimb](../hillclimb/SKILL.md) for explicit sustained optimization. Deep and Ultra pass disputed behavior claims and existing checks to [Review](../review/SKILL.md) for verification.

Use [Benchmark Checklist](../benchmark-checklist/SKILL.md) before reporting or acting on a measured performance comparison. This capability does not add benchmark runs to unrelated changes.

When reading, writing, or reviewing `.ts` or `.tsx` files, apply [TypeScript Best Practices](../typescript-best-practices/SKILL.md). It owns language-specific guidance and links to the existing principles for domain types, trust boundaries, and caller contracts.

## Reporting

Lead the final response with the outcome. Explain consequential choices in the user's language through evidence and principles actually read and applied, so the reader can assess the intent and reasoning: why this responsibility belongs here, why these parts belong together, or what concrete tradeoff favored the approach. Use the reasons that shaped the work rather than a fixed reporting template; caller benefits and alternatives matter when relevant. Reconcile the explanation with the final diff before claiming completion. One sentence can suffice for a routine correction.

Before claiming completion, apply [Completion Evidence](../principle-completion-evidence/SKILL.md). Explain what behavior was verified, under which conditions, with what observed outcome, and what remains unverified. Commands and test counts are supporting detail when useful. Keep exact verification in handoffs. State material tradeoffs and uncertainty. Include workflow mechanics only when they explain a decision or are requested. Commit or publish only with authorization.

---
name: code
description: Route implementation and planning requests that change product code, executable tooling, configuration, or agent workflows.
---

# Code Change Workflow Router

Read the applicable local instructions and enough target code, direct callers, and nearby verification to select one workflow. Planning-only requests use the same routing as implementation requests. Use [Shared Principles](../../principles/index.md) to discover applicable criteria, then read only the selected workflow and principle files its task needs.

## Scope

Use this router for executable behavior, including operational agent instructions. For prose, explanations, diagrams, and standalone visual artifacts, use the relevant skill directly; rendering code alone does not make an artifact a product change. For mixed requests, route only the executable-change portion.

## Select a Workflow

Apply these gates in order. Signals concern requested behavior, contracts, and operational effects; a file name or incidental mention alone does not satisfy a gate:

1. **[Ultra](references/ultra.md)** for explicit ultra/max/thorough/full-path requests; changes affecting authentication, authorization, security, privacy, stored-data mutation/deletion, schema/migration/backfill, rollout, or production configuration behavior/contracts; external compatibility risk; or long-running coordination across dependent investigations, decisions, or environments.
2. **[PoC](references/poc.md)** for an explicitly disposable experiment with no Ultra signal. Speed wording alone is not experimental intent. Keeping or shipping a PoC returns here for production routing.
3. **[Deep](references/deep.md)** when a bounded read leaves cause, impact, product behavior, or a plan-changing design decision unresolved; when a caller-visible obligation or cross-package responsibility/dependency changes; or when investigation, competing designs, or an explicitly deep approach is the task. Name the concrete uncertainty or changed obligation.
4. **[Fast](references/fast.md)** when target, expected behavior, and verification are known and no earlier gate applies: a validated user plan, local reversible change, known cause with a focused check, mechanical transformation, or established nearby pattern.

If Fast eligibility cannot be established, use Deep; use Ultra when the uncertainty is high-cost or requires dependent stages. File count and available agents do not determine the tier. New evidence that invalidates the selected path returns here; never silently widen Fast or promote PoC to production.

## Ownership and Conditional References

Main owns routing, user interaction, approval, and orchestration. Fast and PoC are direct paths. In Deep and Ultra, delegate only a concrete useful concern: built-in `explorer` with `$sb:analyze`, read-only `sb-thinker` with `$sb:architecture-plan` or an explicitly assigned independent review under `$sb:review`, and built-in `worker` with `$sb:implement`. Keep one implementation writer and fresh independent review threads.

For Fast, Deep, and Ultra, [Planning and Resuming](references/planning.md) owns plan contents, authorization, and completion policy. Rigor and approval are separate: show the plan and continue requested work within its existing grant. Pause only the concern with missing authority or an unresolved consequential decision; a planning-only request returns a plan. [Decision Dialogue](references/decision-dialogue.md) governs decisions that evidence and reasonable defaults cannot resolve.

Read [Composition and Mechanisms](../principle-composition-and-mechanisms/SKILL.md) when the task actually composes capabilities with requirement-owned policy, exposes an independent mechanism obligation, or changes a responsibility/interface boundary.

For an explicit sustained optimization loop, use [Hillclimb](../hillclimb/SKILL.md) to coordinate measurements and attempts within the selected workflow. A concrete attempt uses the current authorized scope; changed contract or risk returns here for routing and any required replanning. Hillclimb does not replace authorization or review gates.

Use [How](../how/SKILL.md) for a requested explanation of runtime flow or ownership, [Why](../why/SKILL.md) for historical rationale, and [Blast Radius](../blast-radius/SKILL.md) when the change's safety depends on a fact beyond the diff. These capabilities serve their concrete question rather than adding mandatory phases. Use [Swarm](../swarm/SKILL.md) for useful independent investigation slices or candidate comparisons in Deep or Ultra; retain this workflow's writer and review boundaries.

## Reporting

Lead completion reports with the outcome, supporting verification, and unresolved risks. Preserve exact verification in handoffs; user-facing reports can summarize successful checks. Beyond the required pre-implementation plan, include workflow details only when they explain a decision or the user asks. Report failures and unverified requirements explicitly. Never commit or publish without authorization.

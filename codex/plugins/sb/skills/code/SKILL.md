---
name: code
description: Route implementation and planning requests that change product code, executable tooling, configuration, or agent workflows.
---

# Code Change Workflow Router

Read the applicable local instructions and enough target code, direct callers, and nearby verification to select one workflow. Planning-only requests use the same routing as implementation requests. Read only the selected workflow and references its task needs.

## Scope

Use this router for executable behavior, including operational agent instructions. For prose, explanations, diagrams, and standalone visual artifacts, use the relevant skill directly; rendering code alone does not make an artifact a product change. For mixed requests, route only the executable-change portion.

## Select a workflow

Apply these gates in order:

1. **[Ultra](references/ultra.md)** for explicit ultra/max/thorough/full-path requests; authentication, authorization, security, privacy, stored-data mutation/deletion, schema/migration/backfill, rollout, production configuration, or external compatibility risk; or long-running coordination across dependent investigations, decisions, or environments.
2. **[PoC](references/poc.md)** for an explicitly disposable experiment with no Ultra signal. Speed wording alone is not experimental intent. Keeping or shipping a PoC returns here for production routing.
3. **[Deep](references/deep.md)** when a bounded read leaves cause, impact, product behavior, or a plan-changing design decision unresolved; when a caller-visible obligation or cross-package responsibility/dependency changes; or when investigation, competing designs, or an explicitly deep approach is the task. Name the concrete uncertainty or changed obligation.
4. **[Fast](references/fast.md)** when target, expected behavior, and verification are known and no earlier gate applies: a validated user plan, local reversible change, known cause with a focused check, mechanical transformation, or established nearby pattern.

If Fast eligibility cannot be established, use Deep; use Ultra when the uncertainty is high-cost or requires dependent stages. File count and available agents do not determine the tier. New evidence that invalidates the selected path returns here; never silently widen Fast or promote PoC to production.

## Ownership and conditional references

Main owns routing, user interaction, approval, and orchestration. Fast and PoC are direct paths. In Deep and Ultra, delegate only a concrete useful concern: built-in `explorer` with `$sb:analyze`, read-only `sb-thinker` with `$sb:architecture-plan` or a review capability, and built-in `worker` with `$sb:implement`. Keep one implementation writer and fresh independent review threads.

For Fast, Deep, and Ultra, [Planning and Resuming](references/planning.md) owns plan contents, approval, and completion policy. Deep and Ultra retain explicit plan approval; technical alternatives retain the [Decision Dialogue](references/decision-dialogue.md) eligibility rules.

Read [Feature Composition and Mechanism Primitives](references/composition.md) when the task actually composes capabilities with requirement-owned policy, exposes an independent mechanism obligation, or changes a responsibility/interface boundary. Composition evidence alone does not select a higher tier or a reviewer.

## Reporting

Lead with the outcome, supporting verification, and unresolved risks. Preserve exact verification in handoffs; user-facing reports can summarize successful checks. Include workflow details only when they explain a decision or the user asks. Report failures and unverified requirements explicitly. Never commit or publish without authorization.

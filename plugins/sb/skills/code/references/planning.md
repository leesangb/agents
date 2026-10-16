# Planning and Resuming

Shared policy for Fast, Deep, and Ultra. Tiers set rigor, not approval requirements.

## Required Plan Information

Keep the canonical plan in the conversation, building on agreed context:

- **Outcome Contract:** requested outcome and intent, scope, preserved constraints, completion evidence, and material exceptions or negative evidence.
- Confirmed facts with source or runtime evidence, distinguished from inference and missing evidence.
- Implementation direction, likely targets/owners, and verification, including runtime or integration evidence when needed.

For new behavior or changed interfaces, ownership, or wiring, establish the [caller-first outline](implementation-outline.md) before implementation and include it in the plan.

Main owns the contract. Distinguish fixed `contract-shaping` decisions from adaptable `implementation recommendation` choices. Explain consequential or non-obvious choices with their evidence, alternative, and reopening condition; include new tests and risks only when relevant.

Use [Decision Trail](../../principle-decision-trail/SKILL.md) when long-running, unattended, or multi-session work could lose material decisions. It supports the plan rather than adding another approval checkpoint.

## Compact Plan Overview

Before editing a new or materially updated task, show what will change, the approach, and completion checks in the user's language. Fast can use one sentence; Deep and Ultra expose the complete plan's consequential facts and choices. Show the caller-first outline as a short call flow or pseudocode when required. Fixed labels and headings are unnecessary. Follow-up fixes within the same plan need only explain the affected approach or check.

## Authorization and Resumption

- A clear implementation request authorizes its outcome, scope, and permitted effects. Show the plan and continue within that grant, including verification and fixes. Planning-only requests return the complete plan; neither they nor questions about an approach authorize edits.
- Investigate discoverable facts and choose reasonable implementation defaults. Use [Decision Dialogue](decision-dialogue.md) only for consequential choices the request, evidence, and defaults cannot resolve.
- Check existing authority before external effects, irreversible operations, or steps outside the allowed environment. External messages require explicit authorization; commits, publishing, deployment, and production data changes require their actual grants. Prepare reviewable work first, pause only the blocked step, and continue independent authorized work.
- Preserve pre-existing/concurrent work, owned resources, consumers, and durable state. File reversibility alone does not prove operational recovery; use [Operational Safety](../../principle-operational-safety/SKILL.md) when uncertain.
- On resumption, check current intent, source, and verification against the plan. Existing grants persist within scope; revised plans or higher rigor need new authority only for effects beyond that grant. Resolve affected contract decisions before proceeding. A resolved decision does not add a final plan-approval round.

Internal implementation may adapt while preserving accepted behavior, caller obligations, constraints, and verification meaning. Return contract changes to Main for replanning.

## Completion and Continued Work

Completion includes the [principle-grounded explanation](../SKILL.md#reporting) of the implemented result.

Continue until completion evidence supports the contract and material blockers are closed; a round count is not a stopping criterion. Pause the affected concern for contract/authority changes, oscillating fixes, repeated blockers without new evidence, or external dependencies. Report unresolved requirements and continue independent authorized work. Reroute to Ultra when investigation exceeds one bounded plan and needs dependent stages.

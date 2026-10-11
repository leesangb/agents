# Planning and Resuming

Use this policy for Fast, Deep, and Ultra plans, authorization, resumption, and completion. Workflow tiers set investigation, verification, and review depth; they do not determine whether another approval is needed.

## Required Plan Information

Keep the canonical plan in the conversation. It must establish the following information, building on what is already clear from the user's request or agreed context without restating it:

- **Outcome Contract:** requested outcome and intent, observable completion evidence, constraints/invariants, scope boundaries, and material exceptions or negative evidence.
- Relevant confirmed facts with source or runtime evidence; distinguish inference and missing evidence.
- Recommended implementation direction and likely targets/responsibilities; explain the rationale when it differs from the user's stated direction or is otherwise non-obvious.
- Verification that establishes completion, including runtime or integration evidence when needed.

For material decisions distinguish fixed `contract-shaping` choices from adaptable `implementation recommendation` choices. Explain the chosen direction, rationale, rejected alternative, and what evidence would reopen it. Include composition analysis, new tests, and risks only when relevant.

For long-running, unattended, or multi-session work where material pivots would otherwise be lost, use [Decision Trail](../../principle-decision-trail/SKILL.md). Main owns the task record; it does not replace the canonical plan or create another approval checkpoint.

## Compact Plan Overview

Before editing a new or materially updated Fast task, always show a compact **Fast Plan** in the user's language: what will change, how it will be implemented, and how completion will be checked. Include these even when the request is already clear; one concise sentence or a few short lines can suffice, and separate headings are optional. This presentation does not add an approval checkpoint.

For Deep and Ultra, present the complete ready plan using a **Deep Plan** or **Ultra Plan** overview to make consequential facts and choices clear, then apply the authorization policy below. The following prompts guide presentation rather than require fixed headings:

- **Why:** normally omit; explain when departing from the user's stated or agreed direction, or when the choice needs a non-obvious rationale. Ground any departure in evidence rather than guessing the user's expectations.
- **What:** briefly state the observable change and scope.
- **How:** state the implementation approach. When its structure needs explanation, prefer a short before/after call tree or pseudocode. Use [Implementation Outline](implementation-outline.md) for structural sketches.
- **Verify:** name the focused check or observable evidence that establishes completion.

Keep prose to a sentence per included point and sketches to the few lines needed to explain the change. Deep and Ultra expand only consequential facts, constraints, decisions, or risks that remain unclear while preserving the complete plan. Follow-up fixes within an unchanged authorized plan need only explain the affected approach or check; do not repeat the whole plan. Omit empty headings and repeated context. Do not create a second plan artifact merely for later implementation.

## Authorization and Resumption

- A clear implementation request authorizes work toward its requested outcome within the stated scope and permitted effects. In any tier, present the required plan and continue in the same turn when that authority is sufficient. Keep the tier's investigation, verification, and review obligations.
- A planning-only request ends with the complete plan; it does not authorize edits. Resume implementation when the user subsequently requests it. Assess a question about whether an approach is worthwhile rather than treating it as an implementation grant.
- Resolve discoverable facts and choose a sensible implementation default within the requested outcome. Ask only when the request, evidence, and reasonable defaults cannot resolve a consequential choice about the outcome, caller contract, scope, or permitted effects. Use [Decision Dialogue](decision-dialogue.md) for those unresolved choices.
- Before a step with a new external effect, irreversible operation, or effect outside the allowed environment, check whether the existing request explicitly authorizes it. Prepare concrete reviewable work first; pause only the step whose authority is missing and continue independent authorized work. External messages require explicit authorization. Commit, publish, deploy, and production data changes must remain within their actual grants; reversibility alone does not authorize them.
- Judge recovery from the operation's effects, not just whether a file can be reverted. Preserve pre-existing and concurrent work, owned resources, running consumers, and durable state. Use [Operational Safety](../../principle-operational-safety/SKILL.md) when those effects make recovery uncertain.
- Existing authorization persists while its scope and conditions remain applicable. A follow-up such as “proceed”, “implement”, “좋아”, or “ㄱㄱ” can authorize the current proposed work; questions and plan-shaping feedback do not automatically do so. Do not repeatedly ask for an already permitted action.
- Revalidate the plan against current intent, source, and verification before resuming. New evidence can require a revised plan or a higher rigor tier without requiring another approval. Reopen only affected decisions; obtain new authority only when the revision exceeds the existing grant or leaves a consequential choice unresolved. A tier change or different presentation alone is not an approval gate.

Main alone owns the Outcome Contract. Preserve the accepted outcome, constraints, caller obligations, and verification meaning; internal implementation recommendations may change within them. A decision answer resolves that decision and need not be followed by another plan-approval question when the existing implementation request already authorizes the remaining work.

## Completion and Continued Work

Within the authorized scope, continue implementation, relevant verification, and fixes until the Outcome Contract is satisfied and material blockers are closed. There is no fixed dialogue or review/fix round limit. Reassess cost and risk when iterations accumulate; count alone does not prove completion or justify stopping.

Stop the affected concern when the contract or authority must change, fixes oscillate, the same blocker repeats without new evidence, or an external dependency prevents progress. Resolve independent authorized work while the blocker remains. Reroute to Ultra when investigation becomes dependent staged work that no longer fits one bounded plan.

# Planning and Resuming

Use this policy for Fast, Deep, and Ultra plans, approval, resumption, and completion.

## Required Plan Information

Keep the canonical plan in the conversation. It must establish the following information, building on what is already clear from the user's request or agreed context without restating it:

- **Outcome Contract:** requested outcome and intent, observable completion evidence, constraints/invariants, scope boundaries, and material exceptions or negative evidence.
- Relevant confirmed facts with source or runtime evidence; distinguish inference and missing evidence.
- Recommended implementation direction and likely targets/responsibilities; explain the rationale when it differs from the user's stated direction or is otherwise non-obvious.
- Verification that establishes completion, including runtime or integration evidence when needed.

For material decisions distinguish fixed `contract-shaping` choices from adaptable `implementation recommendation` choices. Explain the chosen direction, rationale, rejected alternative, and what evidence would reopen it. Include composition analysis, new tests, and risks only when relevant.

For long-running, unattended, or multi-session work where material pivots would otherwise be lost, use [Decision Trail](../../../principles/decision-trail.md). Main owns the task record; it does not replace the canonical plan or create another approval checkpoint.

## Compact Plan Overview

Before editing a new or materially updated Fast task, always show a compact **Fast Plan** in the user's language: what will change, how it will be implemented, and how completion will be checked. Include these even when the request is already clear; one concise sentence or a few short lines can suffice, and separate headings are optional. This presentation does not add an approval checkpoint.

For Deep and Ultra, present the complete ready plan for approval, using a **Deep Plan** or **Ultra Plan** overview to make consequential facts and choices clear. The following prompts guide presentation rather than require fixed headings:

- **Why:** normally omit; explain when departing from the user's stated or agreed direction, or when the choice needs a non-obvious rationale. Ground any departure in evidence rather than guessing the user's expectations.
- **What:** briefly state the observable change and scope.
- **How:** state the implementation approach. When its structure needs explanation, prefer a short before/after call tree or pseudocode. Use [Implementation Outline](implementation-outline.md) for structural sketches.
- **Verify:** name the focused check or observable evidence that establishes completion.

Keep prose to a sentence per included point and sketches to the few lines needed to explain the change. Deep and Ultra expand only consequential facts, constraints, decisions, or risks that remain unclear while preserving the complete plan. Follow-up fixes within an unchanged approved plan need only explain the affected approach or check; do not repeat the whole plan. Omit empty headings and repeated context. Do not create a second plan artifact merely for later implementation.

## Approval and Resumption

- A clear Fast implementation request is router-authorized: present the compact Fast Plan and continue in the same turn without another approval. A compact overview alone does not satisfy a planning-only request.
- A planning-only Fast Plan, a materially updated Fast Plan, and every newly presented or materially updated Deep or Ultra Plan must be presented and then paused for explicit user approval before any code edit or implementation packet.
- A follow-up such as “approve”, “go ahead”, “proceed”, “implement”, “좋아”, “진행해”, “구현해”, or “ㄱㄱ” counts only when it clearly approves the current canonical plan. Plan-shaping answers, questions, and feedback are not final plan approval.
- On router-authorized Fast presentation or explicit approval, validate the plan against current intent and code and resume implementation. Do not author another plan or ask again when the existing approval remains applicable.
- Reopen planning only when intent or the Outcome Contract changed, current code makes the plan stale, required plan information is missing, or a new Deep/Ultra signal appears. Revisit only the affected decision. A materially changed plan requires fresh explicit approval; a different presentation of the same information does not.

Deep and Ultra use [Decision Dialogue](decision-dialogue.md) for unresolved planning decisions. Answers are planning inputs, not approval of the completed plan. Main alone owns the Outcome Contract. The approved contract is fixed; internal implementation recommendations may change while preserving the contract and verification meaning.

## Completion and Continued Work

After approval, continue implementation, relevant verification, and fixes until the Outcome Contract is satisfied and material blockers are closed. There is no fixed dialogue or review/fix round limit. Reassess cost and risk when iterations accumulate; count alone does not prove completion or justify stopping.

Stop the affected concern when the contract or authority must change, fixes oscillate, the same blocker repeats without new evidence, or an external dependency prevents progress. Resolve independent authorized work while the blocker remains. Reroute to Ultra when investigation becomes dependent staged work that no longer fits one bounded plan.

# Planning and Resuming

This is the shared policy for Fast, Deep, and Ultra plans. Approval and decision-dialogue boundaries are intentional user preferences; reducing process or formatting must not weaken them.

## Required plan information

Keep the canonical plan in the conversation. It must establish the following information, building on what is already clear from the user's request or agreed context without restating it:

- **Outcome Contract:** requested outcome and intent, observable completion evidence, constraints/invariants, scope boundaries, and material exceptions or negative evidence.
- Relevant confirmed facts with source or runtime evidence; distinguish inference and missing evidence.
- Recommended implementation direction and likely targets/responsibilities; explain the rationale when it differs from the user's stated direction or is otherwise non-obvious.
- Verification that establishes completion, including runtime or integration evidence when needed.

For material decisions distinguish fixed `contract-shaping` choices from adaptable `implementation recommendation` choices. Explain the chosen direction, rationale, rejected alternative, and what evidence would reopen it. Include composition analysis, new tests, and risks only when relevant.

## Compact plan overview

Use an overview when a new or materially updated plan needs explanation for the user to understand the proposed change. Label it **Fast Plan**, **Deep Plan**, or **Ultra Plan**, and include only the useful parts below in the user's language. These are optional prompts, not required fields:

- **Why:** normally omit; explain when departing from the user's stated or agreed direction, or when the choice needs a non-obvious rationale. Ground any departure in evidence rather than guessing the user's expectations.
- **What:** clarify the observable change and scope when they are not already clear.
- **How:** when the implementation direction needs explanation, prefer a short calldiff-style before/after call tree or pseudocode showing the relevant change. Use [Implementation Outline](implementation-outline.md) for structural sketches.
- **Verify:** call out completion evidence when the check is non-obvious or material to a decision.

Keep prose to a sentence per included point and sketches to the few lines needed to explain the change. An already-clear Fast implementation request needs only a brief execution note. Deep and Ultra still present a complete plan for approval, expanding only consequential facts, constraints, decisions, or risks that remain unclear. Omit empty headings and repeated context. Do not create a second plan artifact merely for later implementation.

## Approval and resumption

- A clear Fast implementation request is router-authorized: present the compact plan or execution note and continue in the same turn without another approval. A note alone does not satisfy a planning-only request.
- A planning-only Fast Plan, a materially updated Fast Plan, and every newly presented or materially updated Deep or Ultra Plan must be presented and then paused for explicit user approval before any code edit or implementation packet.
- A follow-up such as “approve”, “go ahead”, “proceed”, “implement”, “좋아”, “진행해”, “구현해”, or “ㄱㄱ” counts only when it clearly approves the current canonical plan. Plan-shaping answers, questions, and feedback are not final plan approval.
- On router-authorized Fast presentation or explicit approval, validate the plan against current intent and code and resume implementation. Do not author another plan or ask again when the existing approval remains applicable.
- Reopen planning only when intent or the Outcome Contract changed, current code makes the plan stale, required plan information is missing, or a new Deep/Ultra signal appears. Revisit only the affected decision. A materially changed plan requires fresh explicit approval; a different presentation of the same information does not.

Deep and Ultra use [Decision Dialogue](decision-dialogue.md) for unresolved planning decisions. Answers are planning inputs, not approval of the completed plan. Main alone owns the Outcome Contract. The approved contract is fixed; internal implementation recommendations may change while preserving the contract and verification meaning.

## Completion and continued work

After approval, continue implementation, relevant verification, and fixes until the Outcome Contract is satisfied and material blockers are closed. There is no fixed dialogue or review/fix round limit. Reassess cost and risk when iterations accumulate; count alone does not prove completion or justify stopping.

Stop the affected concern when the contract or authority must change, fixes oscillate, the same blocker repeats without new evidence, or an external dependency prevents progress. Resolve independent authorized work while the blocker remains. Reroute to Ultra when investigation becomes dependent staged work that no longer fits one bounded plan.

# Planning and Resuming

This is the shared policy for Fast, Deep, and Ultra plans. Approval and decision-dialogue boundaries are intentional user preferences; reducing process or formatting must not weaken them.

## Required plan information

Keep the canonical plan in the conversation. Include:

- **Outcome Contract:** requested outcome and intent, observable completion evidence, constraints/invariants, scope boundaries, and material exceptions or negative evidence.
- Relevant confirmed facts with source or runtime evidence; distinguish inference and missing evidence.
- Recommended implementation direction, likely targets/responsibilities, and why each meaningful action is needed.
- Verification that establishes completion, including runtime or integration evidence when needed.

For material decisions distinguish fixed `contract-shaping` choices from adaptable `implementation recommendation` choices. Explain the chosen direction, rationale, rejected alternative, and what evidence would reopen it. Include composition analysis, new tests, and risks only when relevant.

These are information requirements, not a fixed heading order or template. Use prose, bullets, a table, or a diagram according to the task. A small Fast change may fit in a few sentences. Use [Implementation Outline](implementation-outline.md) only when a structural sketch helps. Do not create a second plan artifact merely for later implementation.

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

# Finding Contract

Use this contract for independent reviewer drafts, Main's validation, and the consolidated review. Principles supply judgment criteria; this file owns review evidence, handoff, and explanation.

## Evidence and Handoff

For an actionable candidate, supply:

- precise location and the owning judgment axis;
- the expected behavior or design criterion and the supporting case required by [Explain Findings for the Recipient](#explain-findings-for-the-recipient);
- supporting evidence with provenance: source version and excerpts/locations, requirement or history origin, or exact observed command results;
- the strongest checked counterevidence and its effect on the claim; identify unavailable evidence explicitly;
- the smallest safe correction and the focused verification that would distinguish it;
- provisional severity justified by the consequence; Main owns final severity and disposition.

For diff/PR reviews with a comparison baseline, also classify the relation as `introduced`, `worsened`, `newly_exposed`, `pre_existing`, `unrelated`, or `unknown`. Only the first three are blocker-eligible, with a reachable trigger, material consequence, and counterevidence that does not defeat the claim. A review without a comparison baseline uses contract relevance instead. Incomplete proof stays unresolved or low-confidence rather than becoming a blocker by default.

Use the assigned principle for axis-specific judgment and evidence.

Account for every selected axis and explicitly raised concern as a candidate finding, supported good-as-is conclusion, or unresolved result. Main records each distinct candidate's disposition internally: accepted, rejected with checked evidence or a concrete cost/tradeoff reason, or unresolved with missing evidence. Consolidate duplicates under the axis that owns the root cause and preserve the merged claim's disposition. A no-findings conclusion states the relevant scope and defeating evidence. Agreement among reviewers who share evidence or assumptions does not add independent support.

Use the caller's severity scale when supplied; otherwise state provisional severity in terms of the demonstrated consequence, likelihood, and urgency. Main finalizes it consistently across axes. Optional improvements are non-blocking suggestions and do not start a fix loop by themselves.

Stable finding/evidence IDs are needed for an audit exchange; ordinary reviews can use precise locations and provenance without an ID ledger.

## Explain Findings for the Recipient

### Problem Explanation

Open the consolidated review with a concise judgment matching the requested emphasis: material behavior and design improvements for a general review, or the requested interface/ownership judgment for a design-focused review. Include any consequential must-fix recommendation, then order findings by consequence and separate non-blocking suggestions.

Make each finding understandable on its own: caller goal or expected behavior → current behavior → consequence → smallest correction. For a behavioral issue, show a reachable input/state/call sequence and the violated contract. Explain how the correction removes the cause while preserving legitimate responsibilities. Include severity rationale, counterevidence, uncertainty, and tradeoffs when they affect the decision. Label proposals and inference separately from source or execution observations. Scale detail to the decision and preserve the causal explanation when merging findings. Put essential context beside the issue; a separate walkthrough is useful only when requested or when additional context is needed beyond the findings.

### Design Costs

For a material design judgment, use actual callers or a representative change grounded in current contracts to explain what people must know, coordinate, or repeat, compared with what the requirement needs. Apply the owning principle to show whose knowledge or coordinated edits the proposed boundary removes, or the current boundary prevents. A brief conditional change example can show the recurring benefit; identify it as an example rather than a future requirement. Explain legitimate constraints and defeating evidence, including why an explicitly raised concern is good as-is.

Preserve accepted design improvements in the final review even when behavior is correct. Do not add a default list of good-as-is or unresolved judgments. Include them only when requested, needed to answer an explicit concern, or consequential to a finding or the overall recommendation; put decisive counterevidence and uncertainty beside the affected judgment. Do not append unrelated retained choices or rejected alternatives to an improvement just to publish review coverage. When no actionable improvement remains, say so briefly. Demonstrated design costs can support a finding without a runtime failure. Keep suggestions non-blocking unless separate evidence establishes a must-fix consequence. Use the concrete cost and benefit to justify the judgment rather than a pattern label or generic praise.

### Show the Proposed Change

Pair each design improvement with the smallest sketch that makes the change understandable: a calldiff-style current → proposed call tree for caller or ownership changes, a local code diff for representation changes, or a short state/data-flow comparison for lifecycle changes. Keep actual current symbols and only the branches relevant to the finding. Label the proposed path; do not present an unimplemented suggestion as an observed result. A source-reconstructed tree is not calldiff tool output. Use calldiff when available and useful, but the review must also work from source without an external skill or tool dependency.

Follow the sketch with the obligation or coordinated edit it removes, where legitimate responsibilities remain, and any decision-changing tradeoff. The sketch complements the causal explanation rather than replacing it. A behavioral finding can use the same form when it clarifies the failure path.

### Optional Alternatives

For a general code or PR review, consider whether an existing API, builtin, or direct implementation can meet the same purpose, behavior, and constraints within the changed scope and relevant callers. Use [Caller Obligations](../../principle-caller-obligations/SKILL.md) and [Simplicity and Coupling](../../principle-simplicity-and-coupling/SKILL.md) when comparing inputs, representations, or responsibility placement. Include alternatives with a meaningful supported benefit and consolidate overlap with existing findings. Apply [Show the Proposed Change](#show-the-proposed-change), explaining what becomes simpler and stays equivalent, distinguishing source-supported equivalence from executed proof.

### Review Completion

For a general code or PR review, keep accepted design improvements visibly separate from behavioral findings. Each distinct accepted design improvement examined by Main or a selected reviewer needs a recipient-facing explanation with its applied criterion, actual interface/caller/owner, concrete cost, proposed-change sketch, and decisive supporting reason. Preserve alternatives, counterevidence, and missing evidence when they affect that suggestion or the overall recommendation. A behavioral blocker, low suggestion severity, or no effect on the merge verdict does not justify dropping an accepted improvement. Honor an explicitly narrower review scope. Good-as-is and unresolved dispositions remain internal except for the cases described under [Design Costs](#design-costs).

Before returning, Main reconciles the final draft with the accepted improvements, any other requested or consequential conclusions, and the reasoning from both Main and reviewers. Merge duplicates only when the resulting explanation preserves each distinct judgment and its supporting reason. Restore missing explanations or complete their evidence before finalizing. Mentioning a store, scope, callback, or principle without its decisive argument is a missing explanation. The recipient must be able to assess the returned judgments from the final answer itself; internal coverage does not require publishing every examined question.

When independent source reviewers participated and the final review needs design improvements or other requested/consequential design conclusions, Main has one fresh built-in `default` agent check the final draft for explanation fidelity before returning. Use `fork_turns: "none"` and supply this contract in full, the fixed scope/version, original ask, reasoning from both Main and reviewers including their considered alternatives and counterevidence, Main's validated dispositions and verification limits, and the draft. The checker calls no tools, performs no source review or verification, and does not change findings or severity. It returns `complete` or precise missing/weakened reasons, proposed-change sketches, alternatives, counterevidence, or uncertainty, citing the supplied reasoning and draft. It does not request omitted good-as-is or unresolved judgments unless this contract requires their inclusion. Main repairs supported gaps and obtains a targeted recheck when repairs were needed. Missing source evidence remains unresolved rather than becoming a product blocker. Return the checked text itself; a later shortening or rewrite needs another fidelity check. With no independent source reviewers, Main performs the same comparison directly. This completion check preserves explanations; the separate packet-audit gate still owns disputes about evidence support and correctness.

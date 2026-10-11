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

Open the consolidated review with a concise judgment matching the requested emphasis: material behavior and design conclusions for a general review, or boundaries to preserve and obligations to improve for a design-focused review. Include any consequential must-fix recommendation, then order findings by consequence and separate non-blocking suggestions.

Make each finding understandable on its own: caller goal or expected behavior → current behavior → consequence → smallest correction. For a behavioral issue, show a reachable input/state/call sequence and the violated contract. Explain how the correction removes the cause while preserving legitimate responsibilities. Include severity rationale, counterevidence, uncertainty, and tradeoffs when they affect the decision. Label proposals and inference separately from source or execution observations. Scale detail to the decision and preserve the causal explanation when merging findings. Put essential context beside the issue; a separate walkthrough is useful only when requested or when additional context is needed beyond the findings.

### Design Costs

For a material design judgment, use actual callers or a representative change grounded in current contracts to explain what people must know, coordinate, or repeat, compared with what the requirement needs. Apply the owning principle to show whose knowledge or coordinated edits the proposed boundary removes, or the current boundary prevents. A brief conditional change example can show the recurring benefit; identify it as an example rather than a future requirement. Explain legitimate constraints and defeating evidence, including why an explicitly raised concern is good as-is.

Preserve supported design improvements and choices worth maintaining in the final review, even when behavior is correct; an explicit design review includes the supported good-as-is conclusion when no improvement remains. Demonstrated design costs can support a finding without a runtime failure. Keep suggestions non-blocking unless separate evidence establishes a must-fix consequence. Use the concrete cost and benefit to justify the judgment rather than a pattern label or generic praise.

### Optional Alternatives

For a general code or PR review, consider whether an existing API, builtin, or direct implementation can meet the same purpose, behavior, and constraints within the changed scope and relevant callers. Use [Caller Obligations](../../principle-caller-obligations/SKILL.md) and [Simplicity and Coupling](../../principle-simplicity-and-coupling/SKILL.md) when comparing inputs, representations, or responsibility placement. Briefly explain the obligation removed, where remaining policy/conversion/lifetime duties live, the concrete benefit, and the tradeoff or reason to retain the current boundary. Include alternatives with a meaningful supported benefit and consolidate overlap with existing findings. Make the proposal concrete with a short call-tree diff or local code diff using actual current symbols and a labeled proposed path. Follow it with what becomes simpler and stays equivalent, distinguishing source-supported equivalence from executed proof.

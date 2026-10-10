# Finding Contract

Use this contract for independent reviewer drafts, Main's validation, and the consolidated review. Principles supply judgment criteria; this file owns review evidence, handoff, and explanation.

## Evidence and Handoff

For an actionable candidate, supply:

- precise location and the owning judgment axis;
- the expected behavior or design criterion, with a reachable input/state/call sequence for a behavioral issue, or an actual caller/change example demonstrating avoidable obligations, duplicated responsibility, or maintenance cost for a design issue;
- supporting evidence with provenance: source version and excerpts/locations, requirement or history origin, or exact observed command results;
- the strongest checked counterevidence and its effect on the claim; identify unavailable evidence explicitly;
- the smallest safe correction and the focused verification that would distinguish it;
- provisional severity justified by the consequence; Main owns final severity and disposition.

For diff/PR reviews with a comparison baseline, also classify the relation as `introduced`, `worsened`, `newly_exposed`, `pre_existing`, `unrelated`, or `unknown`. Only the first three are blocker-eligible, with a reachable trigger, material consequence, and counterevidence that does not defeat the claim. A review without a comparison baseline uses contract relevance instead. Incomplete proof stays unresolved or low-confidence rather than becoming a blocker by default.

Use the assigned principle's specific reasoning when it changes the judgment: a caller-obligation comparison for API concerns, the independent-change case and separation costs for coupling, a protected behavior and proof gap for tests, a requirement-to-behavior mapping for specification, or likelihood/recovery for operational risk. These are useful explanations, not extra universal fields.

A design suggestion can be actionable without a runtime failure. Explain the demonstrated cost, why an existing contract or smaller design can meet the requirement, and the counterevidence that would justify the current choice. Keep it non-blocking unless separate evidence establishes a must-fix consequence.

Assess the design's effect on repeated use and change: caller knowledge and ordering obligations, duplicated policy or state, and responsibilities that must be coordinated when a requirement changes. Use actual callers or a representative change grounded in source to show where the cost recurs. Identify choices worth preserving as well as smaller equivalent alternatives, explaining the recurring cost each avoids. Apply the relevant principles rather than treating this as another checklist; a principle's name or a speculative future need is not sufficient justification for an abstraction or finding.

Account for every selected axis and explicitly raised concern as a candidate finding, supported good-as-is conclusion, or unresolved result. Main also records each distinct candidate's disposition internally: accepted, rejected with checked evidence or a concrete cost/tradeoff reason, or unresolved with missing evidence. Low severity alone does not justify dropping a useful design suggestion. Consolidate duplicates under one root cause and preserve the disposition of the merged claim. A no-findings conclusion states the relevant scope and evidence that defeated the concerns. Agreement among reviewers who share evidence or assumptions does not add independent support.

Use the caller's severity scale when supplied; otherwise state provisional severity in terms of the demonstrated consequence, likelihood, and urgency. Main finalizes it consistently across axes. Optional improvements are non-blocking suggestions and do not start a fix loop by themselves.

Stable finding/evidence IDs are needed for an audit exchange; ordinary reviews can use precise locations and provenance without an ID ledger.

## Explain Findings for the Recipient

Lead with the concrete issue and enough context about the caller goal or expected behavior to understand it. Connect the behavioral trigger or actual caller/change example to its consequence. Explain why the criterion applies: the violated contract or invariant, avoidable caller obligation, or concrete maintenance cost comes before the principle's name.

Make the problem understandable before proposing the correction. Show what the current code makes a user or caller experience, or what a concrete maintenance task requires people to know, coordinate, or repeat. For a design concern, compare those obligations with what the accepted requirement actually needs, using source-backed calls or a representative change. A pattern label such as "shallow module" or "duplication" is not an explanation of harm. If the current choice serves a legitimate constraint, account for it; if no meaningful consequence or avoidable cost can be established, do not invent a finding.

Explain how the smallest correction removes the cause while preserving valid behavior and legitimate responsibilities. Include the reason for severity or blocking status, relevant counterevidence/uncertainty, and tradeoffs when they affect the decision.

Scale detail to the decision. A straightforward bug may take a few sentences; an unfamiliar design concern may benefit from a representative call or before/after sketch. Use connected prose, bullets, tables, diagrams, or pseudocode as useful. Preserve this causal explanation when consolidating duplicates; compact handoff metadata does not replace it.

For an optional equivalent alternative, use a few sentences: identify the current purpose, propose the simpler route at a precise location, and explain the concrete reduction in caller knowledge, state, dependencies, or change cost. State what behavior and constraints must remain and any material tradeoff. The current implementation can be valid; do not describe it as broken merely because the alternative is simpler. Source reasoning can support a proposal, but distinguish that from implemented or executed proof of equivalence. Omit alternatives that are only taste, cannot preserve the requirement, or offer no meaningful benefit, and consolidate any overlap with an existing finding.

Make such alternatives concrete with a small before/proposed sketch. When call relationships matter, prefer a compact call-tree diff showing the entrypoint and the meaningful removed, added, or reused calls; for a local expression change, use a short code diff instead. Use actual source symbols for the current path and label the alternative as proposed. Show only the nodes needed to understand the benefit, followed by a sentence explaining what becomes simpler and what stays equivalent. This sketch is a source-backed explanation, not a claim that a diff tool or the proposed code has run.

For example, adapt this shape to the reviewed code and the user's language:

```diff
 entrypoint()
- └─ buildNewOptions()
-    └─ forwardThroughWrapper()
-       └─ existingOperation(options)
+ └─ existingOperation(combinedOptions)  // proposed
```

The recipient should be able to judge when the issue occurs, why it matters, and why the correction addresses it from the finding itself, without first reading a separate change walkthrough. Put the necessary background beside the issue and prioritize that explanation over a general diff summary. For an explicitly raised concern that is good as-is, explain the defeating evidence. Label proposed behavior and inference separately from source and execution observations.

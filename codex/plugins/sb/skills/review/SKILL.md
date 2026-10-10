---
name: review
description: Review a diff, PR, implementation, plan, design, or API boundary using shared principles and evidence-backed findings. Covers caller obligations, module depth, builtin alternatives, responsibility boundaries, and conceptual integrity. Main selects useful independent reviews, validates their evidence, and coordinates a separate audit for material disputes, high-impact judgments, or explicit rigorous-audit requests.
---

# Review

Main owns scope, selection, evidence validation, and final disposition. Review only unless implementation or fixes are already authorized. Use [Shared Principles](../../principles/index.md) to select judgment criteria for the actual artifact and accepted requirement. Planning and implementation use these same criteria.

## Workflow

1. **Establish the evidence.** Honor the supplied files, function, PR, diff, or plan; otherwise use the current branch diff or recent task edits, asking only if scope remains unclear. Main completes relevant deterministic verification and records exact results or unavailable checks. Keep the source version stable during independent inspection.
2. **Establish coverage and select independent questions.** For a general code or PR review, Main examines both observable behavior and the design choices in the change. Read the shared-principle criteria relevant to changed interfaces, callers, ownership, state, abstractions, and names; use actual source and callers to assess whether those choices are justified. This coverage does not require a known bug or a separate request for principle review. Honor an explicitly narrower scope. Read [Reviewer Selection](references/reviewer-selection.md) for independent questions, gates, caps, and ownership. Record the applied criteria and their conclusions internally, then select useful independent reviewers. Main covers relevant questions not delegated; with none eligible, return Main's review with `reviewers: none`.
3. **Hand off the assigned criteria.** Use fresh `sb-thinker` threads with `fork_turns: "none"`, never planning threads. Supply scope/artifact version, original ask or Outcome Contract, constraints, applicable instructions, relevant evidence, and the [Reviewer Assignment](#reviewer-assignment) below. Run independent questions in parallel only when useful. Main waits for every selected reviewer and uses targeted follow-ups when evidence is missing.
4. **Validate and consolidate.** Main checks claims, no-findings conclusions, and explicit user hypotheses against source, contract, verification, and counterevidence. Complete missing evidence directly or ask the originating reviewer; preserve its provenance. Apply the common finding contract and ownership rules, including its candidate-disposition rule, without counting votes.
5. **Audit when warranted.** Use [Packet Audit Protocol](references/packet-audit.md) only when its separate-audit gate passes. That protocol owns the packet, verdict/state meaning, repairs, and targeted exchange.
6. **Return the result or authorized fixes.** Preserve validation, types, security, accessibility, and data-loss safeguards. Use the common finding contract and causal explanation. Main finalizes severity/disposition. Send only validated scoped blockers to the designated writer when fixes are authorized; delegated fixes use `$sb:implement`. Recheck affected behavior and claims after changes. Unresolved evidence cannot itself authorize a fix.

When artifact, contract, or evidence changes, version and recheck affected claims/coverage while retaining still-applicable work. Fast and PoC code workflows do not load review orchestration; Deep and Ultra supply their profiles.

## Reviewer Assignment

Main provides absolute filesystem paths to the selected principle files and [Finding Contract](references/finding-contract.md), plus the absolute [Shared Principles](../../principles/index.md) index path for conditional fallback lookup. Source reviewers read the selected criteria and finding contract. Follow a linked criterion only when a concrete unanswered question within the assigned scope needs its rule; resolve that link from the source file's directory. For another within-scope question without a direct link, use the supplied index path to locate its owner. Keep the assignment to the selected scope; Main injects its evidence and these execution limits into the fresh thread.

Reviewers may read relevant source, existing tests, and history. They do not edit, execute verification, post, or delegate. Return drafts and coverage under the common finding contract, reporting distinct out-of-axis concerns to Main. The packet-only auditor instead receives full instruction contents under [Packet Audit Protocol](references/packet-audit.md).

## Output

Internally include the reviewed scope, selected axes/reasons, and `review_status: validated` or `review_status: unresolved`. A validated result means Main's evidence check is complete and any selected audit has no unresolved material challenge. Distinguish already validated findings within an unresolved review; only those may enter an authorized fix packet.

Read and follow [Explain Findings for the Recipient](references/finding-contract.md#explain-findings-for-the-recipient) for the opening judgment, findings, design conclusions, and optional alternatives.

Keep routine passing checks, command lists, reviewer coverage, and workflow status in internal evidence. Include a decisive observation in the finding it supports. State missing evidence, skipped scope, audit disposition, or disagreement only when it changes a finding or the overall recommendation, at that point in the explanation. Include a separate verification/limits section only when requested.

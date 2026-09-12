---
name: review-with-subagents
description: Select and coordinate zero or more independent sb-thinker reviews for concrete questions about a diff, PR, implementation, plan, or design. Main validates the findings; use a separate packet-only audit when a material dispute, high-impact judgment, or explicit rigorous audit warrants it.
---

# Review With Subagents

Main owns reviewer selection, evidence validation, and final disposition. Start with no reviewers; select a capability only for a concrete question supported by the supplied artifact. Ordinary review ends when Main has checked the source and evidence and consolidated the findings. A separate auditor is conditional, not a consequence of selecting a reviewer. Review only unless the caller already authorized implementation or fixes.

Use fresh `sb-thinker` instances for independent read-only reviews, never a planning thread. Fast and PoC code changes do not load this skill; Deep and Ultra supply their profile. Use the built-in `worker` with `$sb:implement` for a delegated fix, with one designated writer for source and tests.

## Workflow

1. **Establish scope and evidence.** Keep the user-specified files, function, PR, branch diff, or plan authoritative. Otherwise use the current branch diff or recent task edits; ask only if the scope remains unclear. Main completes the selected deterministic verification before handing off and records exact results or unavailable checks. Give reviewers the artifact version, original ask or Outcome Contract, constraints, applicable instructions, relevant source, and verification evidence. Keep source stable while reviewers inspect it. Skip or minimize review for mechanical, generated, documentation-only, or tiny changes unless explicitly requested.
2. **Select bounded capabilities.** Apply [Reviewer Selection](#reviewer-selection). Record each selected capability, concrete trigger evidence, and bounded discovery axis; a table is optional. If no gate passes, return `reviewers: none` with relevant verification evidence. Spawn independent questions in parallel only when useful. Use `fork_turns: "none"` and pass each fresh reviewer the scope and evidence explicitly. The question is a priority hypothesis, not a replacement for the capability's relevant rubric within that scope.
3. **Collect independent findings.** Reviewers may read source, existing tests, and history, but do not edit or run tests, builds, linters, typecheckers, benchmarks, applications, or other verification commands. They return candidate findings with location, evidence and provenance, reachable trigger, material consequence, scoped-change relation when applicable, checked counterevidence, proposed fix, verification, and provisional severity. They also account briefly for their selected axis, including missing evidence or a supported no-findings conclusion. Use diagrams, code sketches, ledgers, and comment drafts only when useful. Wait for every selected reviewer with a long wait per wave and mailbox notifications; inspect status when a focused follow-up or an expired wait requires it.
4. **Validate and consolidate in Main.** Check claims against source, contract, verification, and their strongest available disconfirming evidence. Main may investigate missing evidence directly, run focused verification, or ask the originating reviewer a targeted follow-up; preserve provenance and distinguish Main's evidence from the independent review. Challenge material no-findings conclusions and rejected user hypotheses as well as defects. Record each selected axis and explicit concern as an actionable finding, supported good-as-is conclusion, or unresolved result. Deduplicate by root cause and capability ownership. Agreement between reviewers is not independent evidence when they share the same source or assumptions.
5. **Decide whether a separate audit is needed.** Use [Conditional Packet Audit](#conditional-packet-audit) only for a material unresolved disagreement, a high-impact judgment whose consequence warrants an independent evidence check, or an explicit request for rigorous audit. Name the reason. Without that trigger, Main's evidence validation completes the review.
6. **Return the result or authorized fix.** Main owns final severity and disposition. Lead with actionable findings, supported by location, trigger, consequence, evidence, smallest safe fix, and focused verification. If fixes were authorized, send validated actionable blockers as one scoped packet to the designated writer. Recheck affected behavior after a fix. Unresolved claims stay labeled and cannot themselves authorize a fix.

When source, contract, or evidence changes, identify affected claims and coverage, update their artifact/evidence versions, and recheck only those dependencies. Preserve unaffected work when it still applies; do not restart every reviewer because new context arrived. Do not treat evidence from an earlier artifact as current without checking its continued applicability.

For diff or PR reviews, classify findings as `introduced`, `worsened`, `newly_exposed`, `pre_existing`, `unrelated`, or `unknown`. Only the first three are blocker-eligible. A blocker also requires a reachable trigger, material consequence, and checked counterevidence that does not defeat it. Incomplete evidence means unresolved or low-confidence, not high severity by default. Reviews without a comparison baseline omit only the scoped-change relation.

## Conditional Packet Audit

Load `$sb:review-audit` only after its gate above passes. Main prepares a self-contained packet for the challenged or high-impact claims and any explicitly requested coverage. Preserve the original reviewer claims and material dissent alongside Main's additional evidence. Include the exact scope/artifact version, contract and constraints, relevant capability axes, stable finding and evidence IDs, compact source excerpts or exact observed outputs with provenance, and prior audit exchange. Assign one fixed review envelope version identifier to the audit packet and every included claim; explicitly state which claims and coverage it contains.

Spawn one fresh `sb-thinker` with `fork_turns: "none"` and the audit capability. The auditor receives only this packet, never repository access. It may check support, consistency, completeness, and scope; it may not call tools, discover source evidence, create findings, or assign final severity.

- `AGREE`: the supplied claims and coverage are supported; Main finalizes their disposition.
- `DISAGREE`: Main or the originating reviewer checks the challenged evidence and revises, supports, or drops the claim. Send only the affected claims and relevant exchange back to the auditor in a coherent updated packet.
- `ENVELOPE_CHANGED`: reconcile conflicting versions and resubmit the affected claims; retain unrelated validated findings.
- `UNRESOLVED`: name the missing evidence and keep those claims unresolved.

Continue a targeted exchange while new evidence or a correction can resolve it. Stop when the evidence converges, repeats without progress, requires unavailable authority/evidence, or changes the authorized scope. Preserve disagreement rather than manufacture agreement. Use one non-recursive audit layer; Main cannot silently override an unresolved audit on the same evidence.

## Reviewer Selection

This section is the single source of truth for the review-capability roster, the separately gated Ultra simplifier, signal triggers, concern ownership, deduplication, OOP `Suggestion` policy, and generic selection profiles. Other skills and workflows reference it instead of copying those rules.

Callers may provide a workflow profile and cap. Profiles set upper bounds and capability-specific prompt additions; they never supply trigger evidence or a minimum review count. A caller-provided cap overrides the generic scope cap for that invocation. The auditor never counts against reviewer caps.

Workflow profiles:

- **Deep**: select at most three capabilities whose positive gates pass; zero is valid. When `code-review` has its own concrete question, add this material-simplification checklist to that prompt: requirement overshoot; duplicate state or paths; unnecessary abstractions, dependencies, or residue; and evidence that behavior remains preserved. Apply the [Simplicity and coupling](../simplify-review/SKILL.md#simplicity-and-coupling) criteria to those candidates. Exclude taste or polish and never weaken safeguards.
- **Ultra**: select at most two roster capabilities whose positive gates pass; zero is valid. Also select at most one `simplify-review` outside the regular profile cap only when the diff supplies both a concrete simplification trigger—such as a new abstraction, duplicate state or path, transitional residue, hidden coupling between independently changing concepts, or material complexity—and a question not answered by verification. Record it as skipped otherwise. Ultra rigor comes from investigation, risk handling, and verification, not a mandatory baseline review.
- **Plan review**: Ultra-only; use only when a plan decision is expensive to reverse. Select at most two signal-matched reviewers from the reviewed plan and decision context, with no mandatory baseline or default panel.

Composition classification does not select a reviewer. When the artifact includes positive composition evidence, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) only to identify a concrete caller-obligation or ownership/dependency question; select API or architecture review only when that separate question remains unresolved.

Reviewer positive gates, all opt-in:

- `code-review`: select for an explicit general code-review request over a non-trivial executable diff, or when non-mechanical logic creates a specific correctness, regression, maintainability, dead-code, or leaky-abstraction question not closed by tests or deterministic checks.
- `test-review`: select when observable behavior changed and there is a concrete question about the responsibility boundary, missing scenario, or whether tests prove behavior rather than implementation details.
- `api-review`: select when a non-mechanical changed callable or cross-module interface introduces or changes a caller-obligation axis: setup, ordering, cleanup, lifecycle, error protocol, internal IDs, wrappers, callbacks, configuration, conversions, or a plausible language/runtime builtin. Concrete changed-surface evidence for one axis is sufficient; the reviewer derives hypotheses from real caller patterns instead of requiring Main to know whether a defect exists.
- `architecture-review`: select only when responsibility ownership or dependency direction actually changed and a concrete placement, module-depth, or change-axis question remains independently of caller pain, such as two credible owners or a hidden stateful mechanism. Do not pair it automatically with `api-review`.
- `intent-review`: select when a new abstraction, type, or public name carries a concrete constraint or rationale that may be invisible at its declaration or use sites.
- `oop-review`: select when inheritance, implementation relationships, extension surfaces, mutable domain invariants, or substitutability changed and a concrete behavioral-contract question exists.
- `risk-review`: select when auth, stored-data mutation, deletion, migrations, rollout, feature flags, or production configuration creates a concrete failure, recovery, security, or operational question.
- `spec-review`: select when mapping an explicit spec or acceptance criterion to the implementation leaves a concrete compliance or omission question.

The Ultra-only `simplify-review` supplemental gate remains outside the regular roster cap, but this skill owns its spawning, audit, aggregation, and reporting. Main validates its material findings under the same evidence bar; the conditional audit gate applies equally to this pass.

Use the built-in `explorer` with `$sb:analyze` before review when behavior, call chains, or impact scope is unclear.

Generic caps when no workflow profile overrides them; the auditor and the Ultra-only supplemental simplifier do not consume these slots:

- Small: at most one selected reviewer.
- Medium: at most three selected reviewers.
- Large (cross-module or contract-changing): at most 4 reviewers total; pick the highest-signal add-ons and name the perspectives left out.

Zero reviewers is a normal result at every size. Leave a reviewer out when the changed surface or ownership axis is ambiguous, not merely because the artifact has not yet revealed whether the concrete answer will be a finding or `good-as-is`.

Concern ownership and deduplication:

- Assign a material finding to the capability whose rubric directly owns the triggered concern; retain an overlapping `code-review` finding only when it independently demonstrates a concrete runtime correctness or maintainability risk.
- `api-review` owns the caller mental model, caller obligations, ceremony, leaked implementation knowledge, and module depth as experienced through caller leverage. `architecture-review` owns the distinct, caller-pain-independent question of mechanism placement, cohesion, structural depth, and dependency direction. When one concern supplies only supporting evidence for the other, return one finding rather than two.
- Apply the same ownership rule to coupling found by `simplify-review`: consolidate overlapping caller-obligation or structural findings under API or architecture ownership, retaining the concrete change case and separation costs. Coupling alone does not trigger another reviewer.
- `oop-review` owns semantic substitutability, encapsulation, inheritance/interface contracts, and domain-invariant findings. Deduplicate those findings with `code-review` using the ownership rule above.
- `oop-review` `Suggestion` findings are non-blocking and must not create a fix or convergence loop by themselves.

## Output Contract

The internal handoff includes reviewed scope, selected capabilities and reasons, and `reviewers: none`, `review_status: validated`, or `review_status: unresolved`. A validated status means Main completed evidence validation and, if selected, the audit has no unresolved material challenge. If any material claim remains unresolved, mark the review unresolved and distinguish independently validated findings; only those validated findings may enter an already authorized fix packet.

The user-facing review leads with findings ordered by consequence. Include the owning capability when it helps explain the judgment, precise location, scoped-change relation when relevant, reachable evidence, material consequence, important counterevidence or uncertainty, smallest safe fix, and verification. Include a concise audit disposition when an audit ran. Skipped perspectives, no-findings evidence, and low-confidence concerns need space only when they affect the conclusion. A clean review may be a short evidence-backed result.

Choose prose, bullets, tables, call trees, pseudocode, or state/sequence diagrams according to what makes the causal chain clear. A visual, a ledger, a before/after example, and a comment draft are not mandatory artifacts. Label proposed behavior and inference separately from observed source and execution evidence.

## Guardrails

- Keep scope and behavior-preservation constraints authoritative; review does not authorize widening them.
- Preserve tests, types, validation, security, accessibility, and data-loss safeguards.
- Keep reviewer source access read-only and the auditor packet-only. Main owns evidence completion and final judgment.
- Preserve material disagreement without dumping raw transcripts.
- Apply fixes only within the user's existing implementation or refinement authorization.

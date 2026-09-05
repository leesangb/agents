---
name: review-with-subagents
description: Select, coordinate, and adversarially validate zero or more fresh sb-thinker reviews, using parallel specialists only for independent concrete questions. Use when reviewing a diff, PR, implementation, plan, design, test strategy, or recently changed code, or when Deep or Ultra must decide whether a post-implementation diff has reviewable risks.
---

# Review With Subagents

Start with no reviewers. This skill is the single source of truth for reviewer selection, spawning, waiting, and aggregation, and it also owns packet-only adversarial validation. Select a capability only for a changed surface and bounded discovery axis supported by the current artifact. When at least one reviewer is selected, freeze one review envelope, collect self-contained specialist evidence packets, audit only those packets through one critic role, then consolidate only the validated findings. This skill reviews only by default; apply fixes only when the caller explicitly asks. PoC and Fast code changes do not load this skill; Deep and Ultra callers select an explicit profile.

Use Main for orchestration, the built-in `explorer` for `$sb:analyze`, and the built-in `worker` with `$sb:implement` for any delegated fix. Use the custom `sb-thinker` only for the materially distinct read-only high-reasoning review itself. Preserve explicit capability injection; do not rely on unsupported plugin agent registration.

## Workflow

1. Resolve scope.
   - If the user names files, a function, a PR, a branch diff, or a description, keep that scope authoritative and do not widen it.
   - Otherwise use the current branch diff. If no diff exists, use recent edits from the task. If scope is still unclear, ask.
   - Main must complete every selected deterministic verification command before freezing the envelope. Record the exact test, build, lint, typecheck, or other verification results that reviewers may inspect; do not spawn review agents while planned checks are still running or absent.
   - Build one fixed review envelope containing the exact scope and artifact version, original ask or Outcome Contract, assumptions and behavior-preservation constraints, applicable project instructions and docs, related code, completed verification evidence, and any caller-resolved task-state paths. Version the complete envelope from those contents and give it to every reviewer. Carry the same fixed review envelope version identifier into every reviewer evidence packet and the later adjudication packet.
   - Freeze the complete envelope for the whole reviewer-auditor exchange. No artifact edits or fix packets are allowed until the audit agrees. Agents may derive conclusions from the frozen inputs, but they do not add supplied context to that version. If any supplied context or evidence changes, create a new envelope version and restart or replay every affected reviewer and audit pass even when the artifact bytes are unchanged.
   - Skip or keep minimal for docs-only, generated, mechanical, or tiny changes unless the user explicitly asks for review.

2. Choose review capabilities.
   - Start with an empty set. For every candidate, write `capability | trigger evidence | bounded discovery axis` using the current plan, diff, call sites, tests, or risk context. The axis names the responsibility to inspect without requiring Main to invent the eventual finding.
   - Select a capability only when the changed surface and axis are concrete and belong to that capability. Evidence must cite changed behavior or caller obligation, unresolved ownership/dependency decision, test boundary, or operational risk from the artifact.
   - If no candidate passes, return `reviewers: none` with verification evidence that closes the task and stop without spawning.
   - Prefer parallel spawn only when two or more selected questions are independent.
   - Spawn every fresh reviewer with `fork_turns: "none"` and pass the complete fixed review envelope explicitly. For Deep or Ultra task state, Main passes the exact caller-resolved `state_path` and only explicitly relevant checkpoint/artifact paths; reviewers are read-only and never rederive or mutate the store.
   - Include the capability's trigger evidence and bounded discovery axis in its prompt; do not ask for a general second opinion. Any supplied review question is a priority hypothesis, not a limit on the capability's mandatory rubric scan inside the fixed artifact scope.
   - Reviewers may inspect source, existing tests, history, and supplied verification evidence, but must not run tests, builds, linters, typecheckers, benchmarks, applications, or other verification commands. When runtime evidence is required but absent, record it as missing instead of producing it.
   - Ask for a self-contained reviewer evidence packet with draft findings only. Each response includes the fixed envelope version identifier and the generic coverage line `axis | disposition | required artifacts complete/missing`; each candidate includes a stable local finding ID, its claim, scoped-change relation when the scope is a diff or PR, reachable trigger, material consequence, strongest checked disconfirming evidence, evidence provenance, and provisional severity.
   - For every actionable candidate, also require the smallest source-grounded causal shape that makes the finding understandable without a prose walkthrough: a call-flow tree, before/after pseudocode, sequence flow, state transition, or focused code excerpt. Include the current shape and, when the fix changes that shape, a separately labeled proposed blueprint. The current side must be supported by packet evidence; the proposed side must remain the smallest safe fix rather than an invented implementation plan.
   - Every supporting or disconfirming evidence item must carry a stable evidence ID, provenance, and the shortest relevant excerpt or exact observed output needed to judge the claim without reopening the repository. A bare `path:line`, unsupported conclusion, or instruction to inspect another file is incomplete. The `sb-thinker` must not edit files or assign the final disposition.

3. Collect the draft reviews.
   - Wait for all spawned `sb-thinker` instances. Never reuse a planning thread for review; each review gets a fresh instance even though planning and review share the same execution profile.
   - Wait once per spawn wave with a long timeout and rely on mailbox/final-status notifications. Do not alternate short `wait_agent` timeouts with `list_agents` polling; inspect status only after the long wait expires or when a focused follow-up needs a concrete stalled reviewer.
   - Check the capability-owned coverage line and supplied artifacts. When required artifacts are missing, send one focused follow-up; if they remain incomplete, mark the axis unresolved. Main never authors missing capability artifacts or accepts an incomplete response as `good-as-is`.
   - Prefix or normalize each reviewer-local finding and evidence ID so it stays stable across the audit exchange. Preserve the raw reviewer packets and dissent; do not deduplicate or drop candidates before the auditor sees them. Any missing evidence remains the originating reviewer's responsibility; Main and the auditor never reconstruct it.

4. Adversarially validate the reviews.
   - If no reviewer or separately gated Ultra simplifier was selected, return `reviewers: none` and do not spawn an auditor.
   - Spawn one fresh `sb-thinker` with `$sb:review-audit` and `fork_turns: "none"`. Give it one self-contained adjudication packet: the fixed envelope version identifier and contract metadata, selection ledger, raw reviewer evidence packets, stable finding and evidence IDs, and any prior audit exchange. Do not include source files or repository access in the auditor prompt; compact evidence excerpts supplied by reviewers remain part of their packets.
   - The auditor judges only whether the supplied packet supports its claims, coverage declarations, and scoped relations without contradiction or missing required fields. It does not inspect the artifact, call tools, execute verification, apply a capability rubric, or create evidence. The auditor never discovers or supplies a missed finding.
   - On `AGREE`, the review bundle is validated. On `ENVELOPE_CHANGED`, discard the exchange and restart from scope resolution. On `UNRESOLVED`, return `review_status: unresolved` and name the missing evidence without producing a fix packet.
   - On `DISAGREE`, send one targeted response request to each originating reviewer whose finding or coverage was challenged. Continue the original reviewer when available; otherwise use a fresh thinker with the same capability, fixed review envelope, and full relevant exchange.
   - Apply the verdict-specific response rules: `DISAGREE_EVIDENCE` requires revising or dropping the finding against the cited packet evidence; `DISAGREE_CONCERN` requires concrete confirming evidence or dropping it; `OUT_OF_SCOPE` requires an eligible scoped-change relation plus Outcome Contract relevance or dropping it. Every evidence request returns to the reviewer that owns the selected axis; neither auditor nor Main fills the gap.
   - Continue the original auditor with the revised review bundle and prior exchange for the final pass. Do not spawn a replacement auditor; if the original auditor cannot continue, return `review_status: unresolved`. Allow at most two audit passes total: the initial audit and one final audit after reviewer responses. If the final audit still disagrees or lacks evidence, return `review_status: unresolved`; do not manufacture consensus or edit the artifact.

5. Aggregate the validated review.
   - Deduplicate findings only after adversarial validation. Prefer the capability whose rubric owns the concern.
   - Drop speculative, duplicate, out-of-scope, or behavior-changing suggestions unless they are explicit risks.
   - Main owns final severity and disposition. Independently falsify every validated candidate from the supplied reviewer and audit packets instead of accepting provisional judgment. Main may change a disposition only with cited packet evidence; it must not silently override an unresolved disagreement, reopen the repository to repair a packet, or rerun a capability rubric during aggregation.
   - Map every explicit user concern and selected discovery axis to an actionable finding, an evidence-backed `good-as-is` disposition, or a clearly labeled unresolved/low-confidence result. Silence is not agreement, and one reviewer's positive conclusion cannot substitute for another capability's required analysis.
   - Falsify material `good-as-is` conclusions and rejected user hypotheses with the same discipline as findings, using capability-supplied artifacts rather than re-executing its rubric. A coverage line that claims completeness while omitting named evidence is unresolved, not permission for Main to reconstruct it.
   - For a diff or PR, classify the scoped-change relation as `introduced`, `worsened`, `newly_exposed`, `pre_existing`, `unrelated`, or `unknown`. Only the first three are blocker-eligible; downgrade, omit, or clearly separate the others from the scoped review. Reviews without a comparison baseline skip only this causality gate.
   - A blocker-eligible finding must have a reachable trigger path, a material consequence, and the strongest available disconfirming evidence checked without defeating the claim. Missing evidence makes the candidate low-confidence or non-blocking, not severe by default.
   - Reviewer count is not evidence provenance. Correlated findings based on the same artifact, assumptions, or reasoning collapse into one candidate and never gain confidence merely through agreement.
   - After deduplication, cluster surviving evidence that points to a shared caller obligation or absent owner. Form and falsify one root-cause candidate when the cluster explains the concrete findings better; do not merge independent causes or raise severity because several symptoms share a label.
   - Preserve or trim each surviving finding's packet-supported causal shape for the consolidated review. Main must not invent missing call edges, states, conditions, or proposed behavior during aggregation; return the finding as incomplete or low-confidence when its visual proof is required but unsupported.
   - Keep praise or "good as-is" notes when they explain why no change is needed.

6. Return one consolidated review.
   - Lead with actionable findings ordered by severity.
   - Make each actionable finding visual-first: after its title and location, show the causal shape before explanatory prose. Use sentences only as short labels for consequence, fix, evidence or uncertainty, and verification.
   - Include file references when available.
   - Include skipped/low-confidence findings only when useful.
   - If the caller requested a refinement loop, convert actionable blockers into one scoped fix packet for the designated single writer, using the built-in `worker` with `$sb:implement` when implementation was delegated.

## Reviewer Selection

This section is the single source of truth for the review-capability roster, the separately gated Ultra simplifier, signal triggers, concern ownership, deduplication, OOP `Suggestion` policy, and generic selection profiles. Other skills and workflows reference it instead of copying those rules.

Callers may provide a workflow profile and cap. Profiles set upper bounds and capability-specific prompt additions; they never supply trigger evidence or a minimum review count. A caller-provided cap overrides the generic scope cap for that invocation. The auditor never counts against reviewer caps.

Workflow profiles:

- **Deep**: select at most three capabilities whose positive gates pass; zero is valid. When `code-review` has its own concrete question, add this material-simplification checklist to that prompt: requirement overshoot; duplicate state or paths; unnecessary abstractions, dependencies, or residue; and evidence that behavior remains preserved. Exclude taste or polish and never weaken safeguards.
- **Ultra**: select at most two roster capabilities whose positive gates pass; zero is valid. Also select at most one `simplify-review` outside the regular profile cap only when the diff supplies both a concrete simplification trigger—such as a new abstraction, duplicate state or path, transitional residue, or material complexity—and a question not answered by verification. Record it as skipped otherwise. Ultra rigor comes from investigation, risk handling, and verification, not a mandatory baseline review.
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

The Ultra-only `simplify-review` supplemental gate remains outside the regular roster cap, but this skill owns its spawning, audit, aggregation, and reporting. Its material findings cannot bypass adversarial validation on the way to a fix packet.

Use the built-in `explorer` with `$sb:analyze` before review when behavior, call chains, or impact scope is unclear.

Generic caps when no workflow profile overrides them; the auditor and the Ultra-only supplemental simplifier do not consume these slots:

- Small: at most one selected reviewer.
- Medium: at most three selected reviewers.
- Large (cross-module or contract-changing): at most 4 reviewers total; pick the highest-signal add-ons and name the perspectives left out.

Zero reviewers is a normal result at every size. Leave a reviewer out when the changed surface or ownership axis is ambiguous, not merely because the artifact has not yet revealed whether the concrete answer will be a finding or `good-as-is`.

Concern ownership and deduplication:

- Assign a material finding to the capability whose rubric directly owns the triggered concern; retain an overlapping `code-review` finding only when it independently demonstrates a concrete runtime correctness or maintainability risk.
- `api-review` owns the caller mental model, caller obligations, ceremony, leaked implementation knowledge, and module depth as experienced through caller leverage. `architecture-review` owns the distinct, caller-pain-independent question of mechanism placement, cohesion, structural depth, and dependency direction. When one concern supplies only supporting evidence for the other, return one finding rather than two.
- `oop-review` owns semantic substitutability, encapsulation, inheritance/interface contracts, and domain-invariant findings. Deduplicate those findings with `code-review` using the ownership rule above.
- `oop-review` `Suggestion` findings are non-blocking and must not create a fix or convergence loop by themselves.

## Spawn Prompt Pattern

Use direct instructions like this example where a public hook signature changed caller cleanup obligations:

```text
Spawn a fresh `sb-thinker` with `$sb:api-review` on this scope:
[scope]

Trigger evidence: the public hook now returns a cleanup handle and all callers must retain and invoke it.
Bounded discovery axis: caller-owned versus hook-owned cleanup and lifecycle obligations.

The `sb-thinker` must:
- keep this scope fixed,
- review only,
- avoid file edits,
- use only read-only source and history inspection; do not run tests, builds, linters, typecheckers, benchmarks, applications, or other verification commands,
- return candidate findings with file references and provisional severity, never a final disposition,
- return `axis | disposition | required artifacts complete/missing`,
- give every candidate a stable local finding ID,
- for each candidate include its claim, scoped-change relation when applicable, reachable trigger, material consequence, strongest checked disconfirming evidence, and evidence provenance,
- for each actionable candidate include the smallest source-grounded causal shape; show the current flow or logic and, when useful, a separately labeled proposed blueprint,
- give every evidence item a stable ID and include the shortest excerpt or exact supplied output needed for packet-only audit,
- back any correctness or behavior claim with a concrete trigger path — example code, call sequence, or input/state that actually produces the failure in this codebase; label it speculative if no reachable trigger exists,
- preserve current behavior unless the requested change explicitly changes it.

Return findings ordered by severity.
```

For implementation refinement:

```text
Build `capability | trigger evidence | bounded discovery axis` rows from the current implementation diff, then spawn only concrete candidates, each in a fresh `sb-thinker` thread. For Ultra, apply the separately gated simplification row outside the regular profile cap.
If no row passes, return `reviewers: none` and stop.
Complete deterministic verification, freeze one review envelope, wait for all self-contained reviewer evidence packets, audit the packet-only bundle with `$sb:review-audit`, and resolve at most one targeted reviewer-response round before aggregation.
Only a validated bundle may become one scoped fix packet for the same writer, using the built-in `worker` with `$sb:implement` when the work was delegated. An unresolved bundle returns without edits.
Ask before sending the packet unless the user already asked to apply fixes.
```

## Output Contract

Return the reviewed scope, selection ledger, and exactly one status: `reviewers: none`, `review_status: validated`, or `review_status: unresolved`. When an audit ran, include a concise audit ledger that preserves challenged, dropped, and unresolved finding dispositions without dumping raw transcripts. For a validated review, follow with Main's deduplicated final dispositions ordered by severity, not raw reviewer verdicts. For each finding name the owning capability, precise location, scoped-change relation when applicable, reachable evidence, material consequence, strongest checked disconfirming evidence, evidence provenance, smallest safe fix, and verification. Include skipped or low-confidence findings and good-as-is observations only when useful, then end with the next action: no change, a scoped writer packet, clarification, or further verification. An unresolved review cannot produce a fix packet.

### Visual-First Finding Format

Make each actionable finding understandable without reading a prose explanation. The visual causal shape is the body of the finding; prose only labels what the shape proves.

- Use a diff-style call-flow tree for reachability, ownership, or caller-obligation changes.
- Use before/after pseudocode for conditions, validation, branching, or data transformations.
- Use a compact sequence flow for ordering, lifecycle, retry, cleanup, or side effects.
- Use a state-transition sketch for stateful behavior and recovery paths.
- Use the smallest focused code excerpt for a local defect already visible in one expression; do not inflate it into a diagram.

Prefer this shape:

```text
[severity] finding title — path:line

<current causal shape and, when useful, proposed blueprint>

Consequence: <one concrete reachable outcome>
Fix: <smallest changed seam>
Evidence: <evidence IDs and material disconfirmation or uncertainty>
Verify: <focused check>
```

For a responsibility move, render stable anchors and changed branches in diff form:

```diff
  request()
- └─ caller()
-    ├─ session.open()
-    ├─ session.execute()
-    └─ session.close()
+ └─ session.run()
+    ├─ open()
+    ├─ execute()
+    └─ close()
```

Keep each finding on the causal chain `current flow -> consequence -> changed seam -> expected outcome`. Omit explanatory paragraphs that merely restate the visual. Label inference, proposed behavior, and missing evidence explicitly instead of drawing them as observed facts.

## Guardrails

- Do not use review as permission to broaden scope.
- Do not recommend weakening tests, types, validation, security checks, accessibility affordances, or data-loss-prevention checks.
- Preserve disagreement through a concise audit ledger, but do not leak raw reviewer transcripts.
- Use exactly one centralized, non-recursive audit layer. The auditor never spawns another auditor or reviewer, and callers do not add meta-reviewers around this skill.
- Keep repository discovery and evidence production inside the owning reviewer. The auditor receives packets only and never calls tools.
- Do not apply fixes unless the user explicitly asked for implementation or refinement application.

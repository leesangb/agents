---
name: review-with-subagents
description: Select and coordinate zero or more fresh sb-thinker instances with explicit review capabilities for evidence-driven code review, using parallel reviews only for independent concrete questions. Use when reviewing a diff, PR, implementation, plan, design, test strategy, or recently changed code, or when Deep or Ultra must decide whether a post-implementation diff has reviewable risks.
---

# Review With Subagents

Start with no reviewers. This skill is the single source of truth for reviewer selection, spawning, waiting, and aggregation. Select a capability only for a changed surface and bounded discovery axis supported by the current artifact, spawn independent axes in parallel as fresh `sb-thinker` instances, then consolidate the findings. This skill reviews only by default; apply fixes only when the caller explicitly asks. PoC and Fast code changes do not load this skill; Deep and Ultra callers select an explicit profile.

Use Main for orchestration, the built-in `explorer` for `$sb:analyze`, and the built-in `worker` with `$sb:implement` for any delegated fix. Use the custom `sb-thinker` only for the materially distinct read-only high-reasoning review itself. Preserve explicit capability injection; do not rely on unsupported plugin agent registration.

## Workflow

1. Resolve scope.
   - If the user names files, a function, a PR, a branch diff, or a description, keep that scope authoritative and do not widen it.
   - Otherwise use the current branch diff. If no diff exists, use recent edits from the task. If scope is still unclear, ask.
   - Skip or keep minimal for docs-only, generated, mechanical, or tiny changes unless the user explicitly asks for review.

2. Choose review capabilities.
   - Start with an empty set. For every candidate, write `capability | trigger evidence | bounded discovery axis` using the current plan, diff, call sites, tests, or risk context. The axis names the responsibility to inspect without requiring Main to invent the eventual finding.
   - Select a capability only when the changed surface and axis are concrete and belong to that capability. Evidence must cite changed behavior or caller obligation, unresolved ownership/dependency decision, test boundary, or operational risk from the artifact.
   - If no candidate passes, return `reviewers: none` with verification evidence that closes the task and stop without spawning.
   - Prefer parallel spawn only when two or more selected questions are independent.
   - Pass every fresh thinker the same exact scope, assumptions, and behavior-preservation constraints. For Deep or Ultra task state, Main passes the exact caller-resolved `state_path` and only explicitly relevant checkpoint/artifact paths; reviewers are read-only and never rederive or mutate the store.
   - Include the capability's trigger evidence and bounded discovery axis in its prompt; do not ask for a general second opinion. Any supplied review question is a priority hypothesis, not a limit on the capability's mandatory rubric scan inside the fixed artifact scope.
   - Ask for draft findings only. Each response includes the generic coverage line `axis | disposition | required artifacts complete/missing`; each candidate includes its claim, scoped-change relation when the scope is a diff or PR, reachable trigger, material consequence, strongest checked disconfirming evidence, evidence provenance, and provisional severity. The `sb-thinker` must not edit files or assign the final disposition.

3. Wait and aggregate.
   - Wait for all spawned `sb-thinker` instances. Never reuse a planning thread for review; each review gets a fresh instance even though planning and review share the same execution profile.
   - Deduplicate findings. Prefer the capability whose rubric owns the concern.
   - Check the capability-owned coverage line and supplied artifacts. When required artifacts are missing, send one focused follow-up; if they remain incomplete, mark the axis unresolved. Main never authors missing capability artifacts or accepts an incomplete response as `good-as-is`.
   - Drop speculative, duplicate, out-of-scope, or behavior-changing suggestions unless they are explicit risks.
   - Main owns final severity and disposition. Independently falsify every candidate instead of accepting the reviewer's provisional severity.
   - Map every explicit user concern and selected discovery axis to an actionable finding, an evidence-backed `good-as-is` disposition, or a clearly labeled unresolved/low-confidence result. Silence is not agreement, and one reviewer's positive conclusion cannot substitute for another capability's required analysis.
   - Falsify material `good-as-is` conclusions and rejected user hypotheses with the same discipline as findings, using capability-supplied artifacts rather than re-executing its rubric. A coverage line that claims completeness while omitting named evidence is unresolved, not permission for Main to reconstruct it.
   - For a diff or PR, classify the scoped-change relation as `introduced`, `worsened`, `newly_exposed`, `pre_existing`, `unrelated`, or `unknown`. Only the first three are blocker-eligible; downgrade, omit, or clearly separate the others from the scoped review. Reviews without a comparison baseline skip only this causality gate.
   - A blocker-eligible finding must have a reachable trigger path, a material consequence, and the strongest available disconfirming evidence checked without defeating the claim. Missing evidence makes the candidate low-confidence or non-blocking, not severe by default.
   - Reviewer count is not evidence provenance. Correlated findings based on the same artifact, assumptions, or reasoning collapse into one candidate and never gain confidence merely through agreement.
   - After deduplication, cluster surviving evidence that points to a shared caller obligation or absent owner. Form and falsify one root-cause candidate when the cluster explains the concrete findings better; do not merge independent causes or raise severity because several symptoms share a label.
   - Keep praise or "good as-is" notes when they explain why no change is needed.

4. Return one consolidated review.
   - Lead with actionable findings ordered by severity.
   - Include file references when available.
   - Include skipped/low-confidence findings only when useful.
   - If the caller requested a refinement loop, convert actionable blockers into one scoped fix packet for the designated single writer, using the built-in `worker` with `$sb:implement` when implementation was delegated.

## Reviewer Selection

This section is the single source of truth for the review-capability roster, signal triggers, concern ownership, deduplication, OOP `Suggestion` policy, and generic selection profiles. Other skills and workflows reference it instead of copying those rules.

Callers may provide a workflow profile and cap. Profiles set upper bounds and capability-specific prompt additions; they never supply trigger evidence or a minimum review count. A caller-provided cap overrides the generic scope cap for that invocation. Ultra's separately gated `$sb:simplify-review` is controlled by the Ultra workflow and is outside its review cap; Deep does not run a separate simplification pass.

Workflow profiles:

- **Deep**: select at most three capabilities whose positive gates pass; zero is valid. When `code-review` has its own concrete question, add this material-simplification checklist to that prompt: requirement overshoot; duplicate state or paths; unnecessary abstractions, dependencies, or residue; and evidence that behavior remains preserved. Exclude taste or polish and never weaken safeguards.
- **Ultra**: select at most two capabilities whose positive gates pass; zero is valid. Ultra rigor comes from investigation, risk handling, and verification, not a mandatory baseline review. The Ultra workflow separately gates a read-only `simplify-review` pass outside this review cap.
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

Use the built-in `explorer` with `$sb:analyze` before review when behavior, call chains, or impact scope is unclear.

Generic caps when no workflow profile overrides them:

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
- return candidate findings with file references and provisional severity, never a final disposition,
- return `axis | disposition | required artifacts complete/missing`,
- for each candidate include its claim, scoped-change relation when applicable, reachable trigger, material consequence, strongest checked disconfirming evidence, and evidence provenance,
- back any correctness or behavior claim with a concrete trigger path — example code, call sequence, or input/state that actually produces the failure in this codebase; label it speculative if no reachable trigger exists,
- preserve current behavior unless the requested change explicitly changes it.

Return findings ordered by severity.
```

For implementation refinement:

```text
Build `capability | trigger evidence | bounded discovery axis` rows from the current implementation diff, then spawn only concrete candidates, each in a fresh `sb-thinker` thread.
If no row passes, return `reviewers: none` and stop.
Wait for all results, falsify and deduplicate findings, then aggregate actionable blockers into one scoped fix packet for the same writer, using the built-in `worker` with `$sb:implement` when the work was delegated.
Ask before sending the packet unless the user already asked to apply fixes.
```

## Output Contract

Return the reviewed scope and selection ledger once. If no capability passes, return `reviewers: none`, verification evidence that made review unnecessary, and the next action. Otherwise follow with Main's deduplicated final dispositions ordered by severity, not raw reviewer verdicts. For each finding name the owning capability, precise location, scoped-change relation when applicable, reachable evidence, material consequence, strongest checked disconfirming evidence, evidence provenance, smallest safe fix, and verification. Include skipped or low-confidence findings and good-as-is observations only when useful, then end with the next action: no change, a scoped writer packet, clarification, or further verification.

## Guardrails

- Do not use review as permission to broaden scope.
- Do not recommend weakening tests, types, validation, security checks, accessibility affordances, or data-loss-prevention checks.
- Do not let reviewer disagreements leak raw; resolve them in the aggregate summary.
- Do not apply fixes unless the user explicitly asked for implementation or refinement application.

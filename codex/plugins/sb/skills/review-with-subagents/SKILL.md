---
name: review-with-subagents
description: Select and coordinate zero or more fresh sb-thinker instances with explicit review capabilities for evidence-driven code review, using parallel reviews only for independent concrete questions. Use when reviewing a diff, PR, implementation, plan, design, test strategy, or recently changed code, or when Deep or Ultra must decide whether a post-implementation diff has reviewable risks.
---

# Review With Subagents

Start with no reviewers. Select a capability only for a concrete question supported by the current artifact, spawn independent questions in parallel as fresh `sb-thinker` instances, then consolidate the findings. This skill reviews only by default; apply fixes only when the caller explicitly asks. PoC and Fast code changes do not load this skill; Deep and Ultra callers select an explicit profile.

If custom execution profiles are unavailable, use the built-in `default` for orchestration, `explorer` for `$sb:analyze`, and `worker` with `$sb:implement` for any requested fix. Keep review thinkers read-only and preserve the explicit capability injection; do not rely on unsupported plugin agent registration.

## Workflow

1. Resolve scope.
   - If the user names files, a function, a PR, a branch diff, or a description, keep that scope authoritative and do not widen it.
   - Otherwise use the current branch diff. If no diff exists, use recent edits from the task. If scope is still unclear, ask.
   - Skip or keep minimal for docs-only, generated, mechanical, or tiny changes unless the user explicitly asks for review.

2. Choose review capabilities.
   - Start with an empty set. For every candidate, write `capability | trigger evidence | review question` using the current plan, diff, call sites, tests, or risk context.
   - Select a capability only when both fields are concrete and the question belongs to that capability. Evidence must cite changed behavior or caller obligation, unresolved ownership/dependency decision, test boundary, or operational risk from the artifact.
   - If no candidate passes, return `reviewers: none` with verification evidence that closes the task and stop without spawning.
   - Prefer parallel spawn only when two or more selected questions are independent.
   - Pass every fresh thinker the same exact scope, assumptions, and behavior-preservation constraints. For Deep or Ultra task state, Main passes the exact caller-resolved `state_path` and only explicitly relevant checkpoint/artifact paths; reviewers are read-only and never rederive or mutate the store.
   - Include the capability's trigger evidence and review question in its prompt; do not ask for a general second opinion.
   - Ask for draft findings only. The `sb-thinker` must not edit files.

3. Wait and aggregate.
   - Wait for all spawned `sb-thinker` instances. Never reuse a planning thread for review; each review gets a fresh instance even though planning and review share the same execution profile.
   - Deduplicate findings. Prefer the capability whose rubric owns the concern.
   - Drop speculative, duplicate, out-of-scope, or behavior-changing suggestions unless they are explicit risks.
   - Enforce the evidence bar: a finding is only severe when it comes with a reachable trigger path (example code, inputs, or state producing the failure). No trigger → downgrade or move it to low-confidence; never present an untriggered claim as a blocker.
   - Keep praise or "good as-is" notes when they explain why no change is needed.

4. Return one consolidated review.
   - Lead with actionable findings ordered by severity.
   - Include file references when available.
   - Include skipped/low-confidence findings only when useful.
   - If the caller requested a refinement loop, convert actionable blockers into one scoped fix packet for the same `sb-worker` with `$sb:implement`.

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
- `api-review`: select when caller-visible names, inputs, outputs, ordering, errors, lifecycle, or setup obligations changed and there is a concrete caller-experience question.
- `architecture-review`: select when responsibility ownership or dependency direction actually changed and there is a concrete placement/change-axis question, such as two credible owners or a hidden stateful mechanism.
- `intent-review`: select when a new abstraction, type, or public name carries a concrete constraint or rationale that may be invisible at its declaration or use sites.
- `oop-review`: select when inheritance, implementation relationships, extension surfaces, mutable domain invariants, or substitutability changed and a concrete behavioral-contract question exists.
- `risk-review`: select when auth, stored-data mutation, deletion, migrations, rollout, feature flags, or production configuration creates a concrete failure, recovery, security, or operational question.
- `spec-review`: select when mapping an explicit spec or acceptance criterion to the implementation leaves a concrete compliance or omission question.

Use `sb-explorer` with `$sb:analyze` before review when behavior, call chains, or impact scope is unclear.

Generic caps when no workflow profile overrides them:

- Small: at most one selected reviewer.
- Medium: at most three selected reviewers.
- Large (cross-module or contract-changing): at most 4 reviewers total; pick the highest-signal add-ons and name the perspectives left out.

Zero reviewers is a normal result at every size. When trigger evidence or the review question is ambiguous, leave that reviewer out instead of spawning it for reassurance.

Concern ownership and deduplication:

- Assign a material finding to the capability whose rubric directly owns the triggered concern; retain an overlapping `code-review` finding only when it independently demonstrates a concrete runtime correctness or maintainability risk.
- `oop-review` owns semantic substitutability, encapsulation, inheritance/interface contracts, and domain-invariant findings. Deduplicate those findings with `code-review` using the ownership rule above.
- `oop-review` `Suggestion` findings are non-blocking and must not create a fix or convergence loop by themselves.

## Spawn Prompt Pattern

Use direct instructions like this example where a public hook signature changed caller cleanup obligations:

```text
Spawn a fresh `sb-thinker` with `$sb:api-review` on this scope:
[scope]

Trigger evidence: the public hook now returns a cleanup handle and all callers must retain and invoke it.
Review question: can the hook own cleanup or expose a lower-obligation lifecycle without weakening cancellation behavior?

The `sb-thinker` must:
- keep this scope fixed,
- review only,
- avoid file edits,
- return draft findings with file references,
- back any correctness or behavior claim with a concrete trigger path — example code, call sequence, or input/state that actually produces the failure in this codebase; label it speculative if no reachable trigger exists,
- preserve current behavior unless the requested change explicitly changes it.

Return findings ordered by severity.
```

For implementation refinement:

```text
Build `capability | trigger evidence | review question` rows from the current implementation diff, then spawn only concrete candidates, each in a fresh `sb-thinker` thread.
If no row passes, return `reviewers: none` and stop.
Wait for all results, falsify and deduplicate findings, then aggregate actionable blockers into one scoped fix packet for the same `sb-worker` with `$sb:implement`.
Ask before sending the packet unless the user already asked to apply fixes.
```

## Output Contract

Return the reviewed scope and selection ledger once. If no capability passes, return `reviewers: none`, verification evidence that made review unnecessary, and the next action. Otherwise follow with deduplicated actionable findings ordered by severity. For each finding name the owning capability, precise location, reachable evidence, consequence or why it matters, smallest safe fix, and verification. Include skipped or low-confidence findings and good-as-is observations only when useful, then end with the next action: no change, a scoped worker packet, clarification, or further verification.

## Guardrails

- Do not use review as permission to broaden scope.
- Do not recommend weakening tests, types, validation, security checks, accessibility affordances, or data-loss-prevention checks.
- Do not let reviewer disagreements leak raw; resolve them in the aggregate summary.
- Do not apply fixes unless the user explicitly asked for implementation or refinement application.

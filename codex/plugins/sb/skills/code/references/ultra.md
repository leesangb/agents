# Ultra Code Change Workflow

Use this workflow only after the [Code Change Workflow Router](../SKILL.md) selects Ultra.

The goal is to resolve high-cost uncertainty and expensive decisions before implementation, then converge with the full evidence and review path.

## Contents

- [Interface](#interface)
- [Ownership](#ownership)
- [Decision Dialogue](#decision-dialogue)
- [Workflow](#workflow)
- [Ultra Plan Format](#ultra-plan-format)
- [Guardrails](#guardrails)
- [Task Notes Contract](#task-notes-contract)

## Interface

Ultra accepts tasks where at least one of these is present:

- explicit ultra, max, thorough, or full-path intent;
- irreversible or high-cost risk involving security, privacy, stored data, schema, migration, backfill, rollout, production configuration, or external compatibility;
- long-running coordination across dependent investigations, decisions, environments, or seams;
- any Deep uncertainty that expands into a staged investigation or cannot be resolved in one bounded implementation packet.

Ultra produces an evidence-backed plan, one implementation, evidence-gated independent review when concrete questions remain, and runtime evidence when the changed behavior requires it.

## Ownership

- **Main agent**: dynamically owns routing, scope, investigation and planning orchestration, spawning, follow-up, waiting, the Outcome Contract, all user interaction, conditional Decision Dialogue and Wayfinder invocation, final plan presentation, user confirmation, writer selection, conflict resolution, convergence, and final reporting. Main decides whether to work directly or delegate at each bounded concern.
- **Built-in `explorer` with `$sb:analyze`**: is the default delegated read-only investigation role when a separate pass is useful. It does not implement.
- **`sb-thinker` with `$sb:architecture-plan`**: is an optional materially distinct read-only high-reasoning planner. Main may author the plan directly. When delegated, it quotes Main's fixed Outcome Contract and already-resolved decisions unchanged, returns the tagged planning result, and is never reused for review.
- **Main or a built-in `worker` with `$sb:implement`**: becomes the single writer for code and tests, including every fix iteration. Main chooses once and preserves single-writer ownership.
- **`$sb:review-with-subagents`**: owns reviewer selection, fresh read-only thinker spawning, waiting, and aggregation for concrete questions supported by a plan or diff.
- **`sb-thinker` with `$sb:simplify-review`**: provides a read-only simplification review only when substantive implementation leaves a concrete abstraction, duplication, residue, or complexity question. Its detailed checking criteria remain separate from the shared review roster.

## Decision Dialogue

Read [Decision Dialogue](decision-dialogue.md) with the planning thinker. It is
conditional: workflow tier alone never triggers dialogue. Ultra handles the full
currently eligible frontier round by round; `ready` with no unresolved
discoverable prerequisite and zero eligible decisions remains the immediate
no-dialogue path.

## Workflow

1. Investigate directly or with the built-in `explorer` and `$sb:analyze` when the impact or call path benefits from a separate read-only pass.
   - Read applicable instructions and verify the user's paths, symbols, assumptions, and environment.
   - Trace the relevant call chain, data flow, states, external I/O, and direct and indirect impact.
   - Return contract-relevant observed evidence, clearly labeled inference, and remaining contract-shaping unknowns to Main. Do not draft or synthesize the Outcome Contract.
   - Find existing patterns and co-located learnings relevant to the affected seam.
   - Preserve implementation-relevant exceptions and negative evidence when omitting them could make the writer violate an invariant, repeat an attractive dead end, apply a pattern outside its valid scope, or miss a behavior test. Do not preserve raw exploration or irrelevant paths.

2. Investigate facts and establish the fixed Outcome Contract.
   - Main, optionally assisted by the built-in `explorer`, first finds every fact available from code, documentation, existing patterns, history, logs, and local resources. Do not ask the user for discoverable facts.
   - Separate confirmed facts, inferences, and decisions that only the user can make. Main authors and fixes the Outcome Contract from the user's statements and confirmed evidence: requested outcome and intent, observable behavior and completion evidence, explicit constraints and invariants, out-of-scope boundaries, and implementation-relevant exceptions or negative evidence.
   - Main creates a fixed Outcome Contract snapshot for each planner invocation. That snapshot remains unchanged during the invocation; when a user answer changes the contract, Main authors the next snapshot before resuming the planner.
   - User interaction for unresolved planning decisions happens only through the shared Decision Dialogue result in step 4. Do not implement until its frontier is exhausted and the Outcome Contract is fixed.

3. Decide whether the effort needs Wayfinder.
   - Recommend `$wayfinder` only when the effort is larger than one agent session **and** the path to the destination is still obscured by dependent investigations or decisions.
   - Do not use Wayfinder merely because implementation is large or time-consuming. If the destination and route are already clear, continue to the technical plan.
   - Explain why a shared map is needed and ask the user to confirm starting Wayfinder. Do not invoke it automatically.
   - After the user confirms, name the destination first, chart the frontier on the configured issue tracker, and resolve no more than one ticket per session.
   - Wayfinder is planning by default. Do not start implementation until the map has made the route clear and the resulting Ultra plan is confirmed.
   - Feed Wayfinder evidence and decisions back to Main; Main alone updates the Outcome Contract when the router's plan-update policy permits it.

4. Author and recompute the technical plan directly or with an `sb-thinker` and `$sb:architecture-plan`.
   - Main may apply the planning contract directly or give the thinker Main's current fixed Outcome Contract snapshot unchanged, plus explorer evidence, resolved answers by decision ID, preserved constraints and invariants, implementation-relevant exceptions and negative evidence, relevant learnings, and Wayfinder decisions when present. Read the shared Decision Dialogue reference. The snapshot is fixed for each planning pass.
   - The thinker returns exactly one `ready` or `needs-decisions` result. `ready` contains the complete Ultra plan below; `needs-decisions` contains the current design tree and eligible frontier only. It must not ask the user, infer intent, or silently resolve an eligible choice.
   - For `needs-decisions`, Main presents the full currently eligible frontier as a numbered batch only when it is non-empty, preserving each ID, prerequisites, kind, evidence, credible options, recommendation/reason, and plan consequence. Main returns answers by ID to the same thinker; before the next invocation, Main updates the fixed contract snapshot if an answer changes it, then the thinker records the answers and recomputes the tree round by round until `ready`.
   - If the frontier is empty because a discoverable prerequisite remains, Main resolves that prerequisite from evidence and resumes the same planner without a user question; this is not a dialogue round.
   - Reuse the same planning thinker while resolving the same design tree. After a material reframe or stale evidence, start a fresh planner with the updated contract and evidence. Never reuse a planning thinker for review.
   - Label material decisions in the design tree as `contract-shaping` or `implementation recommendation`; omit trivial local choices and raw exploration. A contract-shaping choice is fixed only by Main from user answers and evidence, never by the thinker.
   - Answers are planning inputs, not approval. When the result is `ready`, Main fixes the final contract snapshot, verifies and presents the complete plan once for explicit approval before implementation. If a new contract-shaping decision or evidence meets a reopen condition, Main updates the next snapshot before continuing.
   - List behavior tests by test file and identify the first tracer-bullet behavior.
   - For an expensive-to-reverse plan decision, load `$sb:review-with-subagents` and apply its **Plan Review** profile. Plan Review is an Ultra-only profile.

5. Present and confirm the Ultra plan.
   - Main verifies that the `ready` technical plan matches the user's confirmed intent and renders it using the required Ultra Plan Format below.
   - Present the Outcome Contract, confirmed facts, and material decision context before the Recommended Implementation Outline so the user can see what is fixed, why the plan has this shape, and what the writer may adapt.
   - Follow the router's **Planning and Resuming** section as the single source of truth for canonical-plan approval, waiting, resume validation, plan updates, and reopen or reroute decisions.
   - If the user changes a contract-shaping decision, return to the relevant investigation, Decision Dialogue, Wayfinder, thinker planning, or final confirmation step before applying the router's plan-update policy.

6. Implement with one writer using `$sb:implement`.
   - Begin this step only after the router's approval and resume-validation policy permits implementation.
   - Send the complete approved Ultra Plan as the canonical handoff, plus only material non-plan-changing context discovered after approval. Do not summarize it into a narrower packet or create a separate handoff artifact.
   - Before sending, apply the router's **Planning and Resuming** policy to any new context.
   - Main decides whether to implement directly or delegate to the built-in `worker`. Keep source and test edits with that same writer through all iterations.
   - Activate durable task notes only when work is expected to cross sessions or explicitly needs durable resume. When active, Main first runs `${CODEX_HOME:-$HOME/.codex}/bin/sb-notes init` for a new task or `resolve --task-path <exact-task-path>` for resume, then passes its returned absolute `task_path` and `state_path` unchanged to the writer. Use those exact paths through every fix, review, resume, and final report; never derive a replacement from the current worktree.
   - The writer holds the Outcome Contract fixed while treating the Recommended Implementation Outline as guidance, and may adjust internal files, seams, order, reversible prefactors, and test placement when the contract and verification meaning remain intact.
   - When task notes are active, the writer reads only the caller-provided `state_path` by default, compares it with live evidence, atomically replaces bounded state through the helper, and appends typed checkpoints. When inactive, it performs no task-state operations. Never inspect, migrate, or modify the legacy repository singleton.
   - Follow vertical TDD when behavior changes: one behavior test, minimal implementation, green, then the next behavior.
   - When the router recorded a positive composition branch, read [Feature Composition and Mechanism Primitives](composition.md), preserve its feature-composition versus mechanism-emergence distinction, and implement and test the approved evidence.
   - When task notes are active, record Outcome Contract progress, non-obvious implementation decisions, verification evidence, and material departures from the Recommended Implementation Outline in the resolved task state.
   - When changing an implementation recommendation while preserving the Outcome Contract, retain its rationale and rejected alternatives as context, log the reason when non-obvious, and continue without approval.
   - If a discovery would change the requested outcome or intent, observable behavior or completion meaning, an explicit constraint or invariant, scope boundary, material exception, or any contract-shaping decision, log it as a blocking contract deviation and return it to Main. For a contract-shaping decision, report the evidence and whether its reopen condition appears met; meeting it triggers Main reconsideration but never authorizes the writer to change the decision. Main reopens investigation, Decision Dialogue, Wayfinder, thinker planning, or final confirmation as appropriate before implementation continues.

7. Verify and review the implemented diff.
   - Run targeted tests, typecheck, and lint, then broaden for shared modules, public contracts, migrations, or cross-runtime behavior.
   - Invoke `$sb:review-with-subagents` with the **Ultra** profile and the actual diff, risk context, and verification evidence. It owns the selection ledger and all reviewer selection, spawning, waiting, and aggregation rules.
   - When task notes are active, pass the same exact `state_path` and only explicit checkpoint/artifact paths relevant to review. If the skill returns `reviewers: none`, record its closing verification evidence.
   - Run one fresh `sb-thinker` with `$sb:simplify-review` only when the diff supplies both a concrete simplification trigger—such as a new abstraction, duplicate state/path, transitional residue, or material complexity—and a question not answered by verification. Record both before spawning; otherwise record it as skipped. Keep this pass outside the Ultra review cap.
   - Every blocker must include a reachable trigger path or observed failing behavior.

8. Fix and converge.
   - Main uses the review skill's deduplicated findings and sends one scoped blocker packet back to the same writer with `$sb:implement` only when actionable blockers remain.
   - If `$sb:simplify-review` identifies a material finding, include it in that packet; after the fix and affected checks, use a fresh thinker to re-review only the changed simplification concern.
   - The same writer applies the packet, updates Outcome Contract progress and deviations, and returns fresh evidence.
   - Re-run affected tests and runtime checks after each fix.
   - Re-review only the changed concern unless the fix materially changes the diff's risk shape.
   - Continue the loop automatically while the completion contract is unmet and meaningful progress is possible. Ultra has no fixed review/fix round cap; stop when evidence-driven convergence is reached or a stop condition below applies.
   - Complete only when the Outcome Contract and its behavior evidence are satisfied, required checks and runtime evidence pass, and blockers are zero. A recommended mechanic need not be followed when the writer records a safer or simpler contract-preserving choice.
   - Stop and return to the user only when the Outcome Contract must change, fixes oscillate, the same blocker repeats without new evidence, an external dependency prevents progress, or continuing would require new authority or scope.

9. Report.
   - Lead with the outcome, then evidence and detail.
   - Summarize behavior, important decisions, observable tests and final status, review fixes, and runtime evidence.
   - Report exact commands and results, including failures and unrun checks.
   - State that Ultra was selected and name the decisive high-cost or coordination signal.
   - Report whether the immediate `ready` path was used and, when dialogue occurred, how many frontier rounds were required.
   - Summarize material implementation choices and contract deviations, including any decision that was reopened; when task notes were active, use the resolved state and name the exact resolved task/state paths.
   - Report the reviewer selection ledger, including `reviewers: none` and a skipped simplification pass when their positive gates did not pass.
   - Report only the learning path returned by `$capture-learning`, or `none`; keep task state as bounded local history rather than a durable report.
   - Mention unresolved risks or assumptions without generating a separate report unless the user asked for one.

## Ultra Plan Format

Main must present this structure in the conversation before implementation. Use concise sections, concrete file or seam references, and behavior language.

Render the `Recommended Implementation Outline` using [Implementation Outline Blueprint](implementation-outline.md). Keep the other sections in ordinary prose and bullets.

```markdown
## Ultra Plan

### Outcome Contract

- Requested outcome:
- Why this matters / intended effect:
- Observable behavior and completion evidence:
- Constraints and invariants to preserve:
- Explicitly out of scope:
- Implementation-relevant exceptions or negative evidence: write `None material` when none

### Confirmed Facts

- Evidence-backed fact — `path:line` or observed runtime evidence
- Separate any remaining inference or unavailable evidence

### Decision Context

- `[contract-shaping]` decision — chosen direction, evidence-backed rationale, rejected alternative, and reopen condition; never writer-adaptable, with the condition serving only as a trigger to return evidence to Main for reconsideration
- `[implementation recommendation]` decision — recommended direction, evidence-backed rationale, rejected alternative, and reconsideration signal; adaptable when the Outcome Contract remains intact
- Include user decisions confirmed through Decision Dialogue when present
- Write `None material` when no decision needs this context

### Feature Assembly and Composition Evidence

- Desired top-level call:
- Existing capabilities and requirement-owned policy:
- Positive branch(es) and evidence, or `None`:
- Existing mechanism(s) to reuse:
- New mechanism candidate and independent obligation, when any:
- Seam consequence and dependency direction:

### Recommended Implementation Outline

- Direction: one-sentence implementation direction and responsibility placement. This is adaptable guidance unless the Outcome Contract explicitly fixes it.

<shallow module/interface/responsibility blueprint>

### Tests

- `path/to/test` (new or existing, placement adaptable) — mark the tracer bullet
  - observable behavior
  - When composition evidence exists, cover mechanism behavior through its interface and requirement policy at the composition layer.

### Verification

- Targeted commands and checks
- Runtime or integration evidence required for completion

### Risks and Reopen Conditions

- Risk, assumption, or condition that would reopen the Outcome Contract
```

Presentation, approval, waiting, and later resumption of this canonical plan follow the router's **Planning and Resuming** policy.

## Guardrails

- Do not let investigation become permission for unrelated cleanup.
- Do not create a reviewer-of-reviewers layer. Delegate reviewer selection to `$sb:review-with-subagents`; Main aggregates findings directly.
- Do not weaken types, assertions, tests, trust-boundary validation, security checks, accessibility, or data-loss prevention to converge.
- Do not commit user changes or create commits unless the user or repository workflow explicitly requests it.
- Do not treat file count alone as complexity; follow the risk and uncertainty that selected this workflow.

## Task Notes Contract

Read [Repository- and Task-Scoped Notes](task-notes.md). It defines the helper lifecycle, exact handoff fields, bounded state schema, checkpoint/artifact selection, evidence priority, permission failures, and separate learning capture. `implementation-notes.local.md` remains untouched legacy ignored content and is never task state.

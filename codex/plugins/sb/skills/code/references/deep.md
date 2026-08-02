# Deep Code Change Workflow

Use this workflow only after the [Code Change Workflow Router](../SKILL.md) selects Deep.

The goal is to resolve meaningful uncertainty before implementation while keeping the review and fix loop bounded.

## Contents

- [Interface](#interface)
- [Ownership](#ownership)
- [Decision Dialogue](#decision-dialogue)
- [Workflow](#workflow)
- [Deep Plan Format](#deep-plan-format)
- [Guardrails](#guardrails)
- [Implementation Notes Contract](#implementation-notes-contract)

## Interface

Deep accepts tasks where at least one of these remains unresolved after the bounded routing read:

- root cause or impact scope;
- interface, ownership, dependency, or data-shape decision;
- cross-seam or public-contract behavior;
- user-visible states, error handling, accessibility behavior, or acceptance priority;
- verification across several related seams.

Deep produces an evidence-backed detailed plan, one implementation, zero to three question-matched reviewers, and bounded fix iterations when review is warranted. Route irreversible or high-cost risk, explicit high-rigor requests, and long-running coordination to Ultra.

## Ownership

- **Main agent**: owns routing, investigation, the Outcome Contract, all user interaction, plan confirmation, reviewer selection through `$sb:review-with-subagents`, conflict resolution, convergence, and final reporting. Main does not edit source or tests.
- **An `sb-thinker` with `$sb:architecture-plan`**: turns Main's confirmed evidence and fixed Outcome Contract into the tagged planning result. Reuse this planning thread while resolving the same design tree; never reuse it for review. Start a fresh planner after a material reframe or stale evidence.
- **`sb-worker` with `$sb:implement`**: is the single writer for source and tests, including every fix iteration.
- **Fresh `sb-thinker` instances with selected review capabilities**: provide independent, read-only evidence only for concrete questions supported by the implementation diff. The Deep profile sets a maximum of three reviews, not a minimum; its selection gates are defined in `$sb:review-with-subagents`.

## Decision Dialogue

Read [Decision Dialogue](decision-dialogue.md) with the planning thinker. It is
conditional: `ready` with no unresolved discoverable prerequisite and zero
eligible decisions is the normal immediate path and adds no dialogue round.
Workflow tier alone never triggers dialogue.

## Workflow

1. Investigate and bound the work.
   - Read applicable instructions, the named targets, direct callers, nearby tests, and relevant history or learnings.
   - Trace the affected call and data flow far enough to identify the root cause or decision surface.
   - Separate confirmed facts, inferences, and questions that require user input.
   - Main owns this investigation; use `sb-explorer` with `$sb:analyze` when a separate bounded investigation is useful, but do not make it a mandatory panel.
   - If evidence reveals an Ultra signal, return to the router before planning.

2. Fix the Outcome Contract and decision context.
   - Main records the requested outcome and intent, observable completion evidence, constraints and invariants, explicit scope boundaries, and implementation-relevant exceptions or negative evidence.
   - Resolve only decisions that can change the contract. Preserve implementation recommendations as adaptable guidance.
   - Main investigates every discoverable fact before any user question. Do not ask the user for facts that code, documentation, history, logs, or an explorer can establish.

3. Author and recompute the plan through the shared Decision Dialogue state machine.
   - Main gives the confirmed evidence, resolved answers (when any), and fixed Outcome Contract to an `sb-thinker` with `$sb:architecture-plan`; the thinker quotes the contract unchanged and returns exactly one `ready` or `needs-decisions` result.
   - For `needs-decisions`, Main presents a numbered batch only when the eligible frontier is non-empty, preserving each decision ID, prerequisites, kind, evidence, credible options, recommended answer/reason, and plan consequence. Ask at most three independent decisions per round; leave any remainder for a later round. If the frontier is empty because a discoverable prerequisite remains, Main investigates it and resumes the same planner without asking a user question; this is not a dialogue round.
   - Main returns the user's answers by decision ID to the same planning thinker. The thinker records the answers, recomputes the design tree, and returns `ready` or a new frontier. The thinker never asks the user or infers intent.
   - Deep allows at most two dialogue rounds. If any eligible frontier remains after round 2, or the frontier keeps expanding or cannot fit one bounded implementation packet, stop and reroute to Ultra before plan approval. A prerequisite-investigation resume does not count as a dialogue round. A material reframe or stale evidence requires a fresh planner; otherwise keep the same planning thread.
   - When the result is `ready`, Main verifies and presents the complete plan. Dialogue answers are inputs, not canonical plan approval; pause once for explicit approval of the ready plan. Main remains the sole author of the fixed Outcome Contract.
   - Do not run a separate plan-review panel on the Deep path; the planning thinker is distinct from every later review thinker.

4. Implement with one `sb-worker` using `$sb:implement`.
   - Begin only after approval and resume validation permit implementation.
   - Send the complete approved Deep Plan as the canonical handoff; do not narrow the Outcome Contract into a separate packet.
   - Keep source and test edits with the same `sb-worker` through all iterations.
   - At the first canonical-plan handoff, overwrite `implementation-notes.local.md` with the shared template. Read it at the start of every implementation or fix iteration and reuse it without reinitializing. Reviewers receive only the current-task notes; never stage or commit the file.
   - Follow vertical TDD where behavior changes: one observable behavior, minimal implementation, green, then the next behavior.
   - When the router recorded a positive composition branch, read [Feature Composition and Mechanism Primitives](composition.md), preserve its feature-composition versus mechanism-emergence distinction, and implement and test the approved evidence.
   - Record non-obvious choices, contract-preserving departures from the recommended outline, and verification evidence in the scratch notes.

5. Verify and review the implementation.
   - Run targeted tests, typecheck, and lint, then broaden only for shared modules, public contracts, or cross-runtime behavior.
   - Load `$sb:review-with-subagents` with the **Deep** profile (maximum three reviews total). Build its required `capability | trigger evidence | review question` selection ledger from the actual diff and verification results.
   - Spawn only fresh thinkers whose selected capability gates pass. If none pass, record `reviewers: none` with verification evidence that closes the task and skip the review/fix loop.
   - Do not add a separate simplification pass on this path.
   - Every blocker must include a reachable trigger path or observed failing behavior.

6. Fix and converge with a hard cap.
   - When review is invoked, **Round 1** is the first post-implementation review. Each round consists of one review invocation, an optional single scoped fix packet to the same worker with `$sb:implement`, and the affected checks after that fix.
   - Re-review only the changed concern in the next round unless the fix materially changes the risk shape.
   - Run no more than **three post-implementation review/fix rounds total**. Round 3 may apply its fix packet and let Main verify the affected checks, but it must not trigger a fourth reviewer invocation. If that evidence cannot close a blocker without another review, report the blocker as unresolved.
   - If a finding would change the Outcome Contract, scope, or a contract-shaping decision, log a blocking contract deviation and return it to Main for replanning instead of adapting it in the fix packet.

7. Report.
   - Lead with the outcome, then changed behavior, files, review findings and fixes, observable evidence, and unresolved risks.
   - List exact commands and results, including failures and checks that could not run.
   - State that Deep was selected and name the decisive uncertainty or cross-seam signal.
   - Report whether the immediate `ready` path was used or how many bounded dialogue rounds were needed; unresolved frontier expansion that caused Ultra rerouting is a routing result, not a hidden decision.
   - Summarize material implementation choices and contract deviations recorded in `implementation-notes.local.md`.
   - Report the reviewer selection ledger, including `reviewers: none` when no positive gate passed.
   - Report only the learning path returned by `$capture-learning`, or `none`; keep the ignored scratch file as current-task history.

## Deep Plan Format

Main must present this structure in the conversation before implementation. Use concise sections, concrete file or seam references, and behavior language.

```markdown
## Deep Plan

### Outcome Contract

- Requested outcome:
- Why this matters / intended effect:
- Observable behaviour and completion evidence:
- Constraints and invariants to preserve:
- Explicitly out of scope:
- Implementation-relevant exceptions or negative evidence: write `None material` when none

### Confirmed Facts

- Evidence-backed fact — `path:line` or observed runtime evidence
- Separate any remaining inference or unavailable evidence

### Decision Context

- `[contract-shaping]` decision — chosen direction, evidence-backed rationale, rejected alternative, and reopen condition; never worker-adaptable
- `[implementation recommendation]` decision — recommended direction, evidence-backed rationale, rejected alternative, and reconsideration signal; adaptable when the Outcome Contract remains intact
- Include user decisions confirmed before plan approval when present
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

1. Responsibility or capability change
   - Likely seam and files
   - Prefactor, if it directly makes the change easier
2. Behaviour change
   - Provider and consumer responsibilities
3. Integration and cleanup required by the agreed scope

### Tests

- `path/to/test` (new or existing, placement adaptable) — mark the tracer bullet
  - observable behaviour
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
- Do not create a reviewer-of-reviewers layer; Main aggregates the selected reviewer findings directly.
- Do not weaken types, assertions, tests, trust-boundary validation, security checks, accessibility, or data-loss prevention to converge.
- Do not commit user changes or create commits unless the user or repository workflow explicitly requests it.
- Do not treat file count alone as complexity; follow the uncertainty and risk that selected this workflow.

## Implementation Notes Contract

`implementation-notes.local.md` is ignored local scratch for exactly one canonical task, not a deliverable. Initialize it from this structure at the first canonical-plan handoff, reuse it for fix iterations, and never archive, stage, or commit it. Reviewers receive only the current-task notes.

```markdown
# Implementation Notes

## Outcome Progress

- [ ] Outcome or observable behaviour goal

## Decisions

- Kind: contract-shaping / implementation recommendation
- Direction, evidence-backed reason, rejected alternative, and reopen condition or reconsideration signal

## Deviations

- Discovery:
- Choice or recommendation:
- Reason:
- Impacted Outcome Contract field, if any:
- Reopen condition status for a contract-shaping decision: met / not met / unclear / not applicable
- Status: contract preserved; continued / blocking contract deviation returned to Main

## Verification

- Command or runtime check — pass / fail / not run
```

Main and the worker treat logged choices as the current task history. Fresh review thinkers receive only the current-task notes so they evaluate deliberate deviations instead of rediscovering them as unexplained changes.

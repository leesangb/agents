---
name: code
description: Use for requests to implement, modify, fix, refactor, migrate, or plan future changes to executable product or tooling behavior, including application source, tests, executable scripts, runtime/build/deployment configuration, or operational agent/workflow behavior. Routes each request to the Fast, Deep, or Ultra code-change workflow.
---

# Code Change Workflow Router

This file only chooses the execution workflow. It does not define implementation steps.

## Execution Profile and Skill Composition

`$sb:code` composes one execution profile with an explicit capability skill at each handoff:

- `sb-explorer` + `$sb:analyze` for bounded read-only investigation.
- `sb-thinker` + `$sb:architecture-plan` for technical planning.
- `sb-worker` + `$sb:implement` for the single writing implementation path.
- A fresh `sb-thinker` + the selected `$sb:*-review` capability for each independent review question; never reuse the planning thinker thread for review.

Install these namespaced profiles with the repository's `codex/install` bootstrap. When they are unavailable, use the built-in `worker`, `explorer`, and `default` execution behavior as a fallback, while preserving the explicit capability skill and read-only/write boundaries. Plugins do not register custom agents; do not invent plugin manifest fields for that purpose.

## Scope: Code Changes Only

Before selecting Fast, Deep, or Ultra, decide whether the requested work changes executable product or tooling behaviour. This router applies to application source, tests, executable scripts, runtime/build/deployment configuration, and operational agent/workflow instructions.

Do not use this router for a non-code deliverable such as:

- prose documentation, specs, plans, reports, release notes, or copy;
- diagrams, charts, visualizations, slide-like artifacts, or explanatory HTML;
- generated images or other design/reference assets that are not shipped as product behaviour.

Creating or editing files does not by itself make a task a code change. HTML, CSS, JavaScript, scripts, or data used only to produce or render a requested non-code artifact do not make that artifact a product code change.

The code package contains only executable-change routing and code investigation, planning, implementation, and review capabilities. Design, documentation, explanation, QA, and other non-code capabilities remain ordinary skills outside `$sb:code` and must be invoked directly.

For non-code work, stop routing here and follow the user's request and any applicable skill directly. Do not create a Fast/Deep/Ultra plan, require plan approval, or invoke implementation/code reviewers unless the user explicitly asks for review. Verify the requested artifact itself in proportion to its purpose.

Use this router normally when the request modifies an application's source, product UI, tests, runtime behavior, build, deployment, or operational automation, even if the user also wants documentation or an explanation. For a mixed request, apply this router only to the code-changing portion; produce the non-code deliverable through its direct workflow.

For every code change, including a request to make a plan for a future code change without implementing it yet:

1. Read the applicable local instructions.
2. Read only enough target code, direct call sites, and nearby tests to classify the task.
3. Apply the routing decision below.
4. Read and follow only the selected workflow.

## Feature Assembly and Composition Gate

For every new user- or system-visible behavior, sketch the desired top-level assembly before routing:

- Desired top-level call:
- Existing capabilities to compose:
- Requirement-owned policy:
- Missing mechanism, if any:

Treat the work as composition-sensitive only when current evidence positively matches at least one branch:

- **Feature composition**: the new capability coordinates two or more existing module interfaces and the requirement owns a cross-capability decision such as ordering, branching, state transition, error or rollback behavior, permission, persistence/cache/network policy, or lifecycle.
- **Mechanism emergence**: behavior that can be named without requirement vocabulary owns an independent invariant, state or lifecycle, ordering/buffering/scheduling, retry/cancellation/cleanup, error or performance contract, or test surface.
- **Seam change**: the change creates or changes an interface, moves ownership, changes dependency direction or caller obligations, relocates test responsibility, or wires a mechanism at a composition root.

When a branch has concrete evidence, read [Feature Composition and Mechanism Primitives](references/composition.md) and record its evidence fields. Otherwise omit composition analysis. Feature composition alone calls for composing existing mechanisms, not extracting a new one. Composition classification alone is neither a Deep signal nor reviewer evidence; use the routing rules below and require a separate unresolved decision or review question.

## Planning and Resuming

- Planning-only and implementation requests follow the same routing and validation or investigation. Produce the selected workflow's Fast, Deep, or Ultra planning presentation; do not make an ordinary preliminary plan first.
- For a clear Fast implementation request, use the Fast workflow's **Inline Fast Note** only when every trivial-change criterion holds. Otherwise present its structured Fast Plan. Either form is **router-authorized**: present it, then continue in the same turn without a second approval.
- An Inline Fast Note is an execution notice, not a canonical plan, and never satisfies a planning-only request. Keep every structured Fast Plan, Deep Plan, or Ultra Plan in the conversation as the canonical plan; do not create a second plan artifact merely because implementation will happen later.
- A planning-only Fast Plan, a materially updated Fast Plan, and every newly presented or materially updated Deep or Ultra Plan must be presented and then paused for explicit user approval before any code edit or implementation packet.
- Treat a follow-up such as "approve", "go ahead", "proceed", "implement", "좋아", "진행해", "구현해", or "ㄱㄱ" as approval only when it clearly refers to the current canonical plan. Plan-shaping answers, questions, and feedback are not final plan approval.
- On a router-authorized Fast presentation or explicit approval, validate it against current intent and code, then resume the selected workflow at implementation without authoring another planning presentation or asking for approval again.
- Use `router-authorized Fast` for the first Fast presentation above; reserve `approved plan` for a structured plan the user explicitly approved.
- Reopen or reroute planning only when the user's intent or Outcome Contract changed, relevant code materially changed and made the plan stale, required fields of the selected plan format are missing, or a new Deep or Ultra signal appears. Return only to the relevant earlier workflow step needed to resolve that condition; otherwise preserve the existing plan and continue from it. If this validation changes the canonical plan, present the updated plan and stop for fresh explicit approval.

## Conditional Decision Dialogue

Deep and Ultra planning may use the shared [Decision Dialogue](references/decision-dialogue.md) state machine. Workflow tier alone never triggers dialogue: `architecture-plan` returns `ready` immediately only when no unresolved discoverable prerequisite and no eligible frontier remain, or `needs-decisions` for Main to investigate a prerequisite or relay a non-empty frontier. Main owns the user interaction and fixed Outcome Contract; answers returned by decision ID are planning inputs, not plan approval. Present and approve the complete `ready` plan once, then preserve Fast's existing path and review-selection rules.

## Routing Decision

Use this order. An Ultra signal overrides Deep and Fast; a Deep signal overrides Fast.

### 1. Route to Ultra when any Ultra signal is present

- **Explicit high-rigor request**: the user asks for ultra, max, thorough, or the current full investigation/review path.
- **Irreversible or high-cost risk**: the change touches authentication, authorization, security, privacy, stored-data mutation, deletion, schema, migration, backfill, rollout, production configuration, or compatibility with external consumers.
- **Long-running coordination**: the work needs staged investigation, dependent design decisions, or verification across multiple environments or seams.

Select [Ultra Code Change Workflow](references/ultra.md).

### 2. Route to Deep when any Deep signal is present

- **Unknown cause or impact**: the root cause, runtime flow, affected callers, or regression surface is still unclear after a bounded read of the target and its direct neighbours.
- **Plan-changing decision**: there are multiple credible approaches that would change an interface, ownership, dependency direction, data shape, or user flow differently.
- **Cross-seam change**: the work changes a caller-visible obligation—such as names, inputs, outputs, required ordering/setup/cleanup, error behavior, lifecycle, or compatibility—or makes a real responsibility/dependency-direction decision across packages or runtimes. The evidence must name that changed obligation or decision.
- **Unresolved product behaviour**: a new user-visible flow has unclear states, error handling, input range, accessibility behaviour, or acceptance priority.
- **Investigation is the work**: the user asks for root-cause analysis, architecture exploration, competing designs, broad impact analysis, or explicitly asks for a deep approach.

Select [Deep Code Change Workflow](references/deep.md).

### 3. Otherwise route to Fast when the task is execution-ready

The task is execution-ready when the expected behaviour and verification can be stated after the bounded routing read, and at least one of these is true:

- The user already supplied an actionable plan, target, acceptance criteria, or concrete implementation direction, and it still matches the current code.
- The change is local and reversible, with bounded callers and no ownership or contract decision.
- The root cause is known and one clear regression test can prove the fix.
- The work is deterministic or mechanical, such as a rename, import rewrite, formatting change, generated update, or codemod, even when it touches many files.
- An existing nearby pattern can be followed without inventing a new abstraction.

Select [Fast Code Change Workflow](references/fast.md).

### 4. If Fast eligibility cannot be established, route to Deep after confirming no Ultra signal is present

Do not guess that a task is small. If the main agent cannot name the target, expected behaviour, and verification after the bounded routing read, use Deep; if the uncertainty is irreversible, high-cost, or long-running, use Ultra.

## Routing Notes

- A positive composition branch does not select Deep by itself. Use Fast when ownership, interface, and dependency direction are known; use Deep only when a plan-changing decision about them remains unresolved.
- File count alone is not a routing signal. A hundred-file deterministic codemod can be Fast; a one-file authorization or data-loss change is Ultra.
- User-provided plans are strong Fast signals, not unquestioned truth. Verify that named files, symbols, assumptions, and tests still match the current code.
- Fast must not invent a second gate for a clear first implementation presentation. If validating the task raises a question about intent, behaviour, ownership, interface, scope, or verification that requires user confirmation, route to Deep; if it reveals irreversible/high-cost risk or long-running coordination, route to Ultra. If a structured Fast Plan is materially updated, present it and wait for explicit approval.
- Prefer Fast when the evidence satisfies its interface. Do not use Deep or Ultra merely because more agents are available.
- If a Fast task reveals a Deep signal before completion, stop expanding the Fast path, return to this router, and continue with Deep; if it reveals an Ultra signal, continue with Ultra.
- State the selected path and the decisive routing evidence in the final response.

## Quick Examples

| Task | Route | Decisive evidence |
| --- | --- | --- |
| Write a spec, report, release note, or prose document | No code workflow | The requested result is a non-code deliverable |
| Create a diagram, chart, or explanatory HTML visualization | No code workflow | Rendering code exists only to produce the artifact |
| Add an interactive chart to the shipped product UI | Fast, Deep, or Ultra by the rules above | The request changes product runtime behaviour |
| Known bug, named function, obvious regression test | Fast | Cause, target, and verification are known |
| User supplies a validated implementation plan for a local change | Fast | Execution-ready plan; no Deep or Ultra signal |
| Mechanical rename across many files | Fast | Deterministic transformation; file count is irrelevant |
| Bug symptom with unknown call path or root cause | Deep | Investigation is required before planning |
| Schema migration or stored-data mutation | Ultra | Irreversible data and compatibility risk |
| New public contract or responsibility moved across packages | Deep | Interface and ownership decision |
| Bounded investigation with an unclear call path or impact surface | Deep | Investigation is needed, but the work remains one bounded plan |
| Multi-stage change whose next step depends on earlier investigation | Ultra | Dependent coordination cannot form one bounded implementation packet |
| Production rollout or long-running cross-environment coordination | Ultra | High-cost coordination and verification |

# Fast Code Change Workflow

Use this workflow only after the [Code Change Workflow Router](../SKILL.md) selects Fast.

The goal is to move directly from a known, bounded request to a verified change.

## Interface

Fast accepts a task only when these facts are known:

- **Target**: where the change belongs.
- **Outcome Contract**: the requested outcome and intent, observable result, constraints, invariants, and scope boundaries that must hold.
- **Verification**: which focused check proves completion.

If any of these becomes unknown, or a Deep or Ultra signal appears, stop and return to the router. Do not compensate by widening the Fast path.

## Ownership

- **Main agent**: validates the task, presents an Inline Fast Note or structured Fast Plan, implements the change directly, resolves genuine blockers, runs focused verification, and reports the evidence.
- Main works alone on the Fast path; no additional agent is required.

## Workflow

1. Validate the execution-ready task.
   - Read the named target, direct callers, nearby tests, and applicable instructions.
   - Verify any user-provided plan against current files, symbols, patterns, and constraints.
   - Follow the router's **Planning and Resuming** section as the single source of truth for canonical-plan approval, waiting, resume validation, plan updates, and reopen or reroute decisions.
   - Choose an Inline Fast Note or structured Fast Plan using the positive criteria below.
   - A clear implementation request follows the router-authorized Fast path and continues after its presentation; a planning-only request always uses a structured Fast Plan and pauses for approval.
   - For new behavior, include the router's Feature Assembly sketch. If the router recorded a positive composition branch, read [Feature Composition and Mechanism Primitives](composition.md), record its compact evidence, and switch to Deep only when ownership, interface, or dependency direction remains unresolved. Otherwise omit composition analysis.
   - If validation raises a question about intent, behaviour, ownership, interface, scope, or verification, return to the router and switch to Deep or Ultra.

2. Implement directly.
   - Main is the sole writer for source and test edits.
   - Keep the change bounded to the Outcome Contract and use existing seams and patterns.

3. Verify the result.
   - Run the focused test or deterministic check that proves the requested behavior.
   - Run targeted typecheck and lint when available.
   - Broaden verification only when the changed code is shared or widely imported.
   - For deterministic mechanical changes, verify the transformation and check for missed or stale occurrences.

4. Fix and converge.
   - If a check fails, make the smallest safe fix directly and rerun the affected checks.
   - Continue only while the Outcome Contract remains clear and meaningful progress is possible.
   - If a fix would change the Outcome Contract, its scope, or a contract-shaping decision, return to the router instead of widening Fast silently.
   - Do not start an unrelated cleanup pass.

5. Report.
   - Lead with the outcome.
   - List changed behavior and files, exact checks and results, and any unverified item.
   - State that Fast was selected and name the decisive execution-ready evidence.
   - Report only the learning path returned by `$capture-learning`, or `none`.

## Fast Presentation

### Inline Fast Note

Use an Inline Fast Note only when every criterion below is positively established:

- The change is one local, reversible, mechanical edit or one equivalent bounded transformation.
- The requested diff and observable outcome are obvious without explaining a separate contract.
- The change introduces no user- or system-visible behaviour and changes no interface, ownership, dependency direction, data shape, or caller obligation.
- No material constraint, exception, alternative, multi-step ordering, or explicit out-of-scope boundary needs to be preserved in the conversation.
- One focused deterministic check proves completion.

Before editing, state one concise line and continue without approval:

```text
Fast — target: <target>; change: <smallest change>; verify: <focused check>.
```

If any criterion is absent or uncertain, use the structured Fast Plan. Do not use file count alone to classify a change as trivial.

### Structured Fast Plan

Use a structured Fast Plan when the work has anything useful to expose beyond target, mechanical change, and one check. This includes multiple meaningful steps or targets, preserved constraints, negative scope, exceptions, feature assembly or composition evidence, non-obvious verification, or a planning-only request.

Keep the plan compact and place it in the conversation. Do not create a separate artifact unless the user asks.

```markdown
## Fast Plan

### Intent
- Requested outcome:
- Why this matters / intended effect:

### Outcome Contract
- Observable behaviour and completion evidence:
- Preserved constraints and invariants:
- Explicitly out of scope:
- Relevant exceptions or negative evidence: omit when none

### Recommended Implementation Outline
- `path/or/seam` — smallest intended change; adaptable when the Outcome Contract remains intact

### Feature Assembly (new behavior)
- Desired top-level call, existing capabilities, requirement-owned policy, and missing mechanism if any

### Composition Evidence (only when a positive gate passed)
- Active branch, concrete evidence, existing mechanism or new candidate, and seam consequence

### Tests and Verification
- Test or focused check that proves completion
```

The structured plan is a short execution packet governed by the router's **Planning and Resuming** policy. If it cannot stay this small without hiding material rationale, a rejected alternative, a reopen condition, or an implementation-relevant exception, use Deep or Ultra.

## Escalation

Return to the router whenever a Deep or Ultra signal appears. Do not continue Fast by quietly widening scope.

---
name: implement
description: Implement a confirmed code-change plan end to end with narrow edits, preserved contracts and safeguards, focused tests, and exact verification evidence. Use when a designated writer must write or fix executable code and tests.
---

# Implement

Implement the approved plan as the single writer for source and tests. The caller may implement directly or delegate to a built-in `worker`; once chosen, keep that same writer responsible through fix iterations. Treat the Outcome Contract as fixed and the Recommended Implementation Outline as adaptable guidance.

## Before editing

1. Determine whether the caller activated durable task state. It is active only when work is expected to cross sessions or explicitly needs durable resume. When active, require the caller-provided absolute `task_path` and `state_path`; do not derive, migrate, or inspect `implementation-notes.local.md`. Read `state.md` with `${CODEX_HOME:-$HOME/.codex}/bin/sb-notes read-state --task-path "$task_path"` only after checking it against current code, Git, tests, and user direction. Record its SHA-256 as the replacement baseline. Read a checkpoint or artifact only when the caller supplies its relevant path. When inactive, do not initialize or derive a store and continue without task-state operations.
2. Confirm the requested outcome, observable completion evidence, constraints, invariants, scope boundaries, negative evidence, and every `contract-shaping` decision.
3. When the approved plan contains positive composition evidence, read [Feature Composition and Mechanism Primitives](../code/references/composition.md) and implement its approved feature assembly, mechanism ownership, and seam consequences.
4. Read [Repository- and Task-Scoped Notes](../code/references/task-notes.md) when the task uses Deep or Ultra. Treat a missing path, malformed state, or notes-root permission failure as actionable and return it to Main; never create a repository-local fallback.

## Implementation rules

- Follow existing patterns and keep changes narrowly scoped. Run the existing relevant tests or deterministic checks first. Add or update a test only when they do not protect the changed observable behavior, or the user explicitly requests one; avoid tests that merely mirror the implementation. When a behavior test is needed, use vertical TDD: one observable test, minimal implementation, green, then continue.
- Preserve trust-boundary validation, assertions, types, security, accessibility, data-loss prevention, error handling, and performance-sensitive behavior.
- Reuse existing mechanisms for feature composition. Extract a new primitive only when the approved plan identifies its independent obligation; otherwise retain the existing seam and record that evidence.
- A simpler internal seam, file, order, or test placement is allowed only when the contract and verification meaning remain intact. Record non-obvious departures and their rationale in the notes.
- If a discovery changes any contract field, scope, invariant, exception, or contract-shaping decision, stop that concern, log a **blocking contract deviation** with evidence and reopen status, and return it to the caller. Never adapt that decision yourself.
- When durable task state is active, replace bounded state only through `sb-notes replace-state --task-path "$task_path" --expected-hash <read-state-sha256> --file <prepared-state>` and append typed evidence through `sb-notes checkpoint --task-path "$task_path" ... --file <prepared-checkpoint>`. A stale baseline is actionable: reread live state and return any conflicting change to Main rather than overwriting it. Do not edit state, metadata, checkpoints, or artifacts directly.
- Keep one writer responsible for all source/test fixes across review iterations. Do not commit unless explicitly authorized.

## Completion

Run the tests or deterministic checks that establish the requested behavior. Run typecheck and lint when applicable to the changed surface, and complete required project checks. After checks pass, broaden or repeat them only when new changes, failures, or unresolved concerns justify it; shared/public/cross-runtime impact informs that judgment rather than automatically requiring a wider suite.

Return exact verification commands and results, changed behavior, and any material deviations, unverified required checks, or unresolved blockers to the caller. When durable task state is active, update the caller-provided bounded state and append a final checkpoint after verification; capture a durable learning only when it is plausibly expensive to rediscover. For a user-facing final response, follow the router's [Reporting](../code/SKILL.md#reporting) guidance.

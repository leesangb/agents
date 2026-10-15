# Fast Code Change Workflow

Use after the [router](../SKILL.md) establishes a known target, expected behavior, and focused verification with no Deep or Ultra signal.

Read [Planning and Resuming](planning.md). Validate the user's direction against the relevant code and preserve meaningful constraints. Present its compact Fast Plan before editing, even for an already-clear request. Continue implementation within the existing grant; planning-only requests return the complete plan, and revisions follow the shared authorization policy.

Main implements directly as the sole writer. Reuse existing seams and keep the Outcome Contract intact. Fast does not load review orchestration or spawn reviewers.

Use relevant existing tests or deterministic checks first; add a behavior test only for missing protection or an explicit request. For a multi-step sweep or retryable state change, apply [Implement's verification guidance](../../implement/SKILL.md#verification). Run applicable typecheck/lint and required project checks. After checks pass, broaden or repeat only for new changes, failures, or unresolved concerns. Mechanical work needs a check for missed or stale occurrences.

Fix failures caused by the change and rerun affected checks. If target, contract, or verification becomes unclear, or a Deep/Ultra signal appears, return to the router rather than widening Fast. Report under the router's reporting policy.

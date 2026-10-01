# Fast Code Change Workflow

Use after the [router](../SKILL.md) establishes a known target, expected behavior, and focused verification with no Deep or Ultra signal.

Read [Planning and Resuming](planning.md). Validate the user's direction against the relevant code and preserve meaningful constraints. Use its conditional overview when explanation is needed; otherwise give a brief execution note. A clear implementation request continues immediately; planning-only and materially updated plans retain the shared approval rule.

Main implements directly as the sole writer. Reuse existing seams and keep the Outcome Contract intact. Fast does not load review orchestration or spawn reviewers.

Use relevant existing tests or deterministic checks first; add a behavior test only for missing protection or an explicit request. Run applicable typecheck/lint and required project checks. After checks pass, broaden or repeat only for new changes, failures, or unresolved concerns. Mechanical work needs a check for missed or stale occurrences.

Fix failures caused by the change and rerun affected checks. If target, contract, or verification becomes unclear, or a Deep/Ultra signal appears, return to the router rather than widening Fast. Report under the router's reporting policy.

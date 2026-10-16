# Fast Code Change Workflow

Use after the [router](../SKILL.md) establishes a known target, expected behavior, and focused verification with no Deep or Ultra signal.

Apply [Planning and Resuming](planning.md). Validate the user's direction against the code and show the compact plan before editing.

Main implements directly using existing seams. Fast does not load review orchestration or spawn reviewers.

Use existing checks first; add a behavior test only for missing protection or an explicit request. Run applicable typecheck/lint and required project checks; mechanical changes also need a missed/stale-occurrence check. For multi-step sweeps or retryable state changes, read [Implement's verification guidance](../../implement/SKILL.md#verification).

Fix change-caused failures and rerun affected checks. Broaden verification only for new changes, failures, or unresolved concerns. Reroute if the target, contract, verification, or risk no longer fits Fast.

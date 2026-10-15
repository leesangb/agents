---
name: blast-radius
description: "Find what a change can break beyond its diff and verify the key safety assumption; use for impact analysis, 'what could this break', or '영향 범위'."
---

# Blast Radius

Identify the fact the change's safety depends on and obtain proportionate proof. A caller list or a persuasive writeup does not establish that fact.

## Investigate and Prove

1. Establish the diff or proposed change, baseline/version, intended behavior, and preserved contracts. Read applicable local instructions. With no implementation diff, label proposed behavior separately from observed behavior.
2. Use [Analyze](../analyze/SKILL.md) for source investigation. Follow connections symbol search misses: pinned dependency behavior and local patches, serialized data or wire formats, flags, teardown timing, retained consumers, and downstream boundaries relevant to this change.
3. State the key safety assumption and trace both a concrete failure scenario and the strongest counterevidence. Use relevant [Shared Principles](../../principles/index.md) for the actual question.
4. Main runs the smallest authorized distinguishing check using the real implementation. Prefer an existing check or a disposable probe; reproduce on the actual consuming path when lower-level proof cannot establish its guarantee. Source-only investigators and reviewers return the needed check rather than running it.

Read-only impact analysis permits source reads and bounded checks within the allowed environment; it does not authorize tracked product edits, destructive probes, production effects, or external writes. Route an authorized implementation or lasting test change through [Code](../code/SKILL.md). When access or permission prevents a check, return the exact proof gap rather than expanding authority.

Report what changes, the key safety assumption, and the strongest observed evidence: source trace, executed real-code check, or consuming-path reproduction. Mark an unproved assumption as unverified. Keep confirmed risks separate from cases checked and cleared; explain the reachable trigger, consequence, and smallest useful next check. Include exact verification in the handoff, with concise user-facing evidence. Use [Review](../review/SKILL.md) when an independent review is needed; this skill does not create a second reviewer system.

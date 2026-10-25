---
name: principle-root-cause-repair
description: "Investigate failures or review causal explanations even without a fix request; validate the failed precondition, trace its first broken guarantee, and identify its responsible owner."
---

# Root-Cause Repair

Use when diagnosing a failure or incident, reviewing an existing causal explanation, or proposing, implementing, or reviewing a bug fix, even without a code-change request. Establish the cause and responsible boundary before recommending a repair. Investigation alone does not authorize edits.

- Identify the precondition demanded at the failure site, whether it is a valid contract, and who must guarantee it. If the contract permits the triggering state, handling it at the failing boundary can be the root-cause fix; an unsupported demand can itself be the defect. If the state violates a valid contract, trace the decision that produced it. Follow the triggering sequence, state/data movement, and relevant callers through the first broken guarantee to the observed symptom. Bound investigation to connections that can explain the failure or change the repair.
- Check the explanation against relevant code and execution evidence; reproduce when possible. Close directly checkable gaps within the current investigation's scope and permitted effects rather than deferring available checks. When a deciding fact is missing, capture the actual error and state through permitted observation or instrumentation before selecting a repair. Distinguish confirmed facts, hypotheses, and the evidence needed to resolve remaining uncertainty; a plausible explanation is not a confirmed cause.
- For failures that appear only after restart, inspect persisted configuration, caches, locks, and serialized state. Search for the demonstrated fault pattern in other reachable owners; for an authorized fix, repair confirmed instances within scope. A shared symptom alone does not justify a repository-wide sweep.
- Judge a repair by whether it restores the broken guarantee at its responsible owner. Use [Responsibility and Change](../principle-responsibility-and-change/SKILL.md) when ownership is unclear; a crash site or available caller is not by itself the right owner. Choose the least extensive change that actually restores the contract there, not a solution merely because its diff is small. A guard, retry, swallowed error, clamped value, or discarded state can hide an earlier fault; distinguish suppressing the visible error from removing its cause. Avoid unrelated redesign and making callers compensate for another owner's broken contract.
- Explain the causal evidence and responsibility judgment. For an authorized fix, verify the original failing scenario and other relevant paths through the same guarantee using [Behavioral Verification](../principle-behavioral-verification/SKILL.md). For diagnosis only, return the supported explanation and remaining evidence needs. Identify containment as mitigation and state any unresolved cause.

If a decisive fact required a deep investigation, propose a cheap operational signal that would expose it sooner; implement it only when justified by the repair's scope.

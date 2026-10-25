---
name: principle-root-cause-repair
description: "Investigate failures or review causal explanations even without a fix request; validate the failed precondition, trace its first broken guarantee, and identify its responsible owner."
---

# Root-Cause Repair

Use when diagnosing a failure or incident, reviewing an existing causal explanation, or proposing, implementing, or reviewing a bug fix, even without a code-change request. Establish the cause and responsible boundary before recommending a repair. Investigation alone does not authorize edits.

- Identify the precondition demanded at the failure site, whether it is a valid contract, and who must guarantee it. An unsupported demand can itself be the defect. Trace the triggering sequence, state/data movement, and relevant callers through the first broken guarantee to the observed symptom. Bound investigation to connections that can explain the failure or change the repair.
- Check the explanation against relevant code and execution evidence. Close directly checkable gaps within the current investigation's scope and permitted effects rather than deferring available checks. Distinguish confirmed facts, hypotheses, and the evidence needed to resolve remaining uncertainty; a plausible explanation is not a confirmed cause.
- Judge a repair by whether it restores the broken guarantee at its responsible owner. Use [Responsibility and Change](../principle-responsibility-and-change/SKILL.md) when ownership is unclear; a crash site or available caller is not by itself the right owner. Distinguish suppressing the visible error from removing its cause. Choose the least extensive change that actually restores the contract there, not a solution merely because its diff is small. Avoid making callers compensate for another owner's broken contract, unrelated redesign, and symptom guards that leave the cause intact.
- Explain the causal evidence and responsibility judgment. For an authorized fix, verify the original failing scenario and other relevant paths through the same guarantee using [Behavioral Verification](../principle-behavioral-verification/SKILL.md). For diagnosis only, return the supported explanation and remaining evidence needs. Identify containment as mitigation and state any unresolved cause.

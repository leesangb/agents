---
name: principle-root-cause-repair
description: "Before proposing a bug fix, trace its cause across the relevant flow and repair the violated guarantee at its responsible owner."
---

# Root-Cause Repair

Use when investigating, proposing, implementing, or reviewing a bug fix. Establish the cause and responsible boundary before choosing the patch's size or location.

- Reconstruct the relevant end-to-end flow: the triggering input or sequence, state and data movement, caller relationships, and ownership. Locate where the expected guarantee first breaks and how that produces the observed symptom. Support the causal explanation with reproduction, traces, or a concrete code path; distinguish hypotheses and unverified behavior. Bound investigation to connections that can explain the failure or change the repair.
- Repair the guarantee where it belongs. Use [Responsibility and Change](../principle-responsibility-and-change/SKILL.md) when ownership is unclear; a crash site or available caller is not by itself the right owner. Avoid making callers compensate for another module's broken contract.
- Choose the least extensive change that removes the demonstrated cause at that owner. A local correction may suffice; an ordering, state, interface, or responsibility change may be necessary. Neither a small diff nor a structural rewrite proves correctness. Avoid unrelated redesign and symptom guards that leave the cause intact.
- Verify the original failing scenario and other relevant paths through the same guarantee, using [Behavioral Verification](../principle-behavioral-verification/SKILL.md). Explain the causal evidence and why this boundary owns the correction. If only containment is feasible, identify it as mitigation and state the unresolved cause.

---
name: hillclimb
description: Repeatedly improve one measurable outcome through isolated hypotheses, a fixed measurement recipe, and keep-or-revert decisions. Use for an explicit sustained optimization loop toward a target; not for a one-off bug fix or an ordinary performance review.
---

# Hillclimb

Main owns the metric, measurement, acceptance decision, and stopping condition. This capability follows the selected [Code](../code/SKILL.md) workflow and its authorization and review rules. Main or the workflow's designated writer owns implementation. Use the existing accepted plan when sufficient, and replan only when its contract or scope changes.

## Define the Experiment

1. Ground the user-visible goal and realistic workload before choosing the metric. Identify the mechanism and confirm the measurement represents the reported cost. If the workload does not reproduce it, repair the measurement premise first.
2. Establish metric/unit/direction, target when supplied, correctness and resource constraints, permitted changes, and a bounded stopping condition. Honor user targets and budgets. When a numeric target is absent, use a meaningful improvement beyond noise and stop when justified affordable hypotheses are exhausted; do not invent a percentage or minimum attempt count.
3. Reuse a suitable measurement recipe or build the smallest needed harness. Verify that it counts completed correct work and responds to relevant contrasting workloads. Capture an uninstrumented baseline, variation, artifact/version, and the existing correctness gate. For performance, apply [Validate a Performance Claim](../principle-performance-evidence/SKILL.md).
4. Hold the workload, harness, comparison conditions, and acceptance criteria fixed across attempts. If the measurement itself is wrong, correct it explicitly and establish a new comparable baseline; prior results do not transfer silently to the changed experiment.

## Run One Hypothesis at a Time

Keep a local [Decision Trail](../principle-decision-trail/SKILL.md) with the hypothesis, task-owned change, before/after result, correctness gate, keep/revert decision, and evidence/version. Read prior attempts before repeating an idea.

- State a falsifiable mechanism, expected effect, and smallest permitted change. Apply [Sequence Verifiable Units](../principle-verifiable-units/SKILL.md); do not stack unmeasured attempts.
- Capture the attempt's starting state and identify exactly which edits belong to it. Preserve pre-existing and concurrent work. Delegate only when the selected workflow permits it; retain one writer. Independent candidates require isolated state under [Separate Independent State](../principle-separate-shared-state/SKILL.md), and reported measurements must avoid contention between candidates.
- Main measures the same successful work under comparable before/after conditions, with repeats sufficient to judge variation, and runs the correctness gate. Profiling that changes cost runs separately.
- Keep a change only when the supported improvement justifies its resource and complexity costs and the contract remains satisfied. A simplification that preserves the metric can be worthwhile if the accepted goal permits it. Faster failures, omitted work, noise, and an unavailable gate do not establish a win.
- Reject an unsuccessful attempt by undoing only its owned edits and checking the intended starting state was restored. If ownership is uncertain, preserve the work and resolve it rather than resetting the whole tree. Record inconclusive or blocked results honestly.

## Stop and Report

On a plateau, use the evidence to revise the next hypothesis rather than repeating guesses. Stop when the accepted target is supported, the budget is reached, remaining plausible benefits do not justify their cost, or required evidence/authority is unavailable. Do not relax the metric, correctness constraints, or target to claim completion.

Report baseline and final outcome with units, conditions, variation, completed-work/error counts, and material memory/I/O/complexity costs. Explain accepted changes, attempt outcomes, remaining uncertainty, and the next useful hypothesis only when relevant. Link detailed trial records. Run the selected workflow's final checks and any gated review before treating the retained code as complete; commits and PRs still require authorization.

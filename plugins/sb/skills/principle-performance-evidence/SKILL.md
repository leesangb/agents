---
name: principle-performance-evidence
description: "Explain measured performance numbers and evaluation scores through comparable completed work, bottlenecks, representative samples, variation, and measurement limits."
---

# Validate Performance and Evaluation Claims

Use before trusting, reporting, or acting on a measured speedup, regression, throughput, latency, or evaluation result. Establish what the number actually measures before trusting it.

## Explain the Number

Ask why the result is not twice as good. For performance, identify the resource or code path that bounds it from a profile or counters and connect it to source; reading the code alone does not establish the limiter. For evaluations, identify the failure classes or scoring constraints behind the result rather than treating a resource bottleneck as a universal requirement.

List plausible alternative explanations and rule them out with evidence: errors, skipped or cached work, work outside the timer, untuned settings, noise, or a measured component too small to affect the user-visible outcome. Keep the run count, spread, conditions, and causal evidence with the number. Distinguish observed measurements from an unverified explanation.

For timing and throughput, follow [Benchmark Checklist](../benchmark-checklist/SKILL.md). Its procedure covers harness inspection, successful completed work, tuning, bounds, repeatability, and end-to-end relevance; use the evaluation criteria below for scores.

## Evaluation Claims

Check that each trial completed the intended task and that its score distinguishes a meaningful failure from a valid solution. Keep workload, rubric, model/configuration, and comparison conditions fixed, or separate their effects from the proposed change. A changed rubric needs a new comparable baseline, not a silent rescore presented as improvement.

Report sample size, repeat variation, failures, and the cases the workload represents. Distinguish instruction-content tests from actual installed behavior and same-task improvement from transfer to new tasks, environments, or models. Use independent cases or checks when those differences matter to the claim. A higher score may reflect the grader, easier tasks, leaked expectations, skipped work, or noise; rule out plausible alternatives before attributing the gain.

## Report the Supported Result

Use **faster**, **slower**, **no measurable difference**, or **inconclusive** with units, run count, variation, relevant conditions, and evidence pointers. Keep an unmeasured gain unverified and distinguish measurement from a causal hypothesis. Put detailed runs in a local artifact rather than filling the user-facing result with the entire harness log.

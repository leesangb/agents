---
name: benchmark-checklist
description: "Validate a benchmark harness and measured speedup or regression: completed work, errors, tuning, bottlenecks, physical limits, repeatability, and user-visible relevance."
---

# Benchmark Checklist

Use before reporting or acting on a performance measurement, including a before/after comparison, a regression, an implementation choice, or a hillclimb result. This is the performance procedure for [Performance and Evaluation Evidence](../principle-performance-evidence/SKILL.md); that principle owns evaluation-score interpretation.

Write the expected claim with its unit, workload, measured region, artifact/version, and environment. Read the harness to establish what it times, counts, and omits. Answer the relevant questions with run evidence.

For a user-requested ballpark, one run is enough: verify errors and completed work (questions 4 and 7), label it as one run, and investigate further if it looks implausible. Choosing a winner between options requires a comparison, even when the user wants a quick answer.

## Check the Measurement

1. **What limits the result?** Identify the limiting resource or code path from a separate profile or counters, and map it to source. Check the load generator as well as the target. Keep profiler overhead out of reported timing. If a change does not improve the result, establish the limiter before concluding that the change has no value. A source-only guess is a hypothesis.
2. **Were the sides tuned fairly?** Match inputs, versions, release builds, production flags, batching, transactions, connection pools, concurrency, and realistic warm/cold cache conditions. A default setting, debug build, or missing index may dominate the comparison. Tune and remeasure before choosing what to adopt. If tuning is unavailable, report that comparison as inconclusive; a narrow observation about today's configuration does not establish the better implementation.
3. **Does the arithmetic fit?** Compare throughput with disk/network bandwidth and available CPU. Time saved cannot exceed the changed part's share of total time: removing 10% of runtime saves at most 10% of elapsed time, or yields about 1.11× speed. Check units, caches, missing work, and errors when a result exceeds its plausible bound.
4. **Did it error?** Count failures, non-success responses, timeouts, and retries. Check output correctness, not merely presence. A faster rejection is not a speedup. Add error counts to a harness that cannot distinguish success from failure.
5. **Does it repeat?** Check machine load and available cores with platform-appropriate tools, such as `uptime` and `sysctl -n hw.logicalcpu` on macOS or `nproc` on Linux. Avoid contention; otherwise interleave A/B runs and record the noise. Start with at least five runs per side for an ordinary comparison, alternate sides, and report median and range. Use the harness's statistics or more runs when the gap is close. A gap within run-to-run variation supports no measurable difference, not a winner.
6. **Does it affect the user?** Measure the end-to-end path with realistic data sizes and concurrency before claiming a user-visible improvement from a microbenchmark. Report the changed part's share of the total, plus material memory, CPU, I/O, and complexity costs.
7. **Did the work happen inside the timer?** Confirm requests reached the target, writes completed, bytes were read, promises were awaited, generators were consumed, and results were used. Exclude skipped work, optimized-away results, or unintended cache hits as explanations for the gain.

## Report the Supported Claim

Lead with **faster**, **slower**, **no measurable difference**, or **inconclusive**. Give before/after values and units, run count, spread, workload and conditions, completed-work/error counts, and the measured limiter. Keep detailed runs and profiles in a linked artifact.

If successful work, correctness, fair tuning, or the limiter is unverified, the comparison verdict is inconclusive. Preserve observed timings and name the missing evidence. Separate measurement from causal inference; a requested one-run estimate cannot establish a winner.

For [Hillclimb](../hillclimb/SKILL.md), validate the harness before freezing it and keep work/error counts in each keep-or-revert check. A changed harness needs a new comparable baseline.

# Validate a Performance Claim

Use when measuring a speedup/regression or choosing an option from benchmark results. Apply the checks that can change the current claim, not a mandatory benchmark suite for every code change.

## Establish What the Number Means

- State the claim, unit, workload, measured region, artifact/version, and environment. Read the measurement harness: what does it time, count, and omit?
- Confirm successful work completed inside the timed region. Count failures, retries, and timeouts; inspect the correctness of outputs. Await lazy work and consume generated results. A faster rejection or skipped operation is not a speedup.
- Compare equivalent inputs, builds, production-relevant settings, concurrency, and warm/cold cache conditions. When choosing implementations, distinguish a configuration difference from the implementation's attainable behavior. If conditions cannot be matched, narrow the claim or keep the comparison inconclusive.
- Control drift and contention. Interleave A/B runs when practical, report run count and spread, and choose enough repeats to distinguish the claimed change from observed variation. A requested one-run estimate stays labeled as such and cannot alone establish a winner.

## Check the Interpretation

- Identify the limiter when needed to explain or act on the result: application code, CPU, allocation/GC, I/O, locks, or the load generator. Profile separately from the reported timing when instrumentation changes cost. A suspected limiter is an inference until supported by counters or a trace.
- Check plausible bounds. Time saved cannot exceed time spent in the changed part; throughput must fit available resources. A result beyond those bounds warrants checking units, caching, missing work, and errors.
- Relate a microbenchmark to the user-visible path before claiming an end-to-end improvement. State material memory, I/O, CPU, and complexity costs alongside the gain.

## Report the Supported Result

Use **faster**, **slower**, **no measurable difference**, or **inconclusive** with units, run count, variation, relevant conditions, and evidence pointers. Keep an unmeasured gain unverified and distinguish measurement from a causal hypothesis. Put detailed runs in a local artifact rather than filling the user-facing result with the entire harness log.

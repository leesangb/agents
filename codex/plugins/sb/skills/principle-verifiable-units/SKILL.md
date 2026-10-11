---
name: principle-verifiable-units
description: "Sequence dependent sweeps and migrations into meaningful units, check each before building on it, then verify the integrated result."
---

# Sequence Verifiable Units

Use for a multi-step sweep or migration where later work depends on earlier changes.

Choose meaningful units whose results can be checked before dependent work starts. Capture the relevant baseline, change one unit, and run the smallest check that distinguishes its intended result before building on it. Group inseparable edits into one unit; a unit need not be a file or commit, and an expected failing regression test can be its recorded result.

Account for unavailable checks rather than treating them as a pass. Complete final integrated verification after the units pass.

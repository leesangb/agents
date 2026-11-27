---
name: interrogate
description: Probe a change for reproducible functional failures and independently rerun each finding. Use for reproduction-focused reviews of observable behavior.
---

# Interrogate

Start with the user's intended behavior, the public entry point and the exact revision or working-tree change under review. Derive the expected result from the contract or its callers. Use [Review](../review/SKILL.md) for a broader assessment of design and maintainability.

Choose scenarios that could distinguish a correct change from a broken one. Run them directly, or assign independent scenarios to agents able to execute local checks. Give each investigator the same source snapshot, including relevant uncommitted edits, and disposable state for probes. Leave the user's checkout and shared services untouched. A fresh run of an existing test or a short script driving the real API is usually sufficient.

For each suspected failure, collect the starting state, exact command, expected result and observed output. Main inspects the probe and reruns it from a fresh instance of that starting state. When attributing a regression, also run it against the comparison revision. If a check depends on an unavailable service or the rerun disagrees, record the limit and leave the finding unconfirmed.

Return confirmed behavior failures with the smallest rerun instructions and their user-visible consequence. Group failures sharing a demonstrated cause. If none reproduce, report the exercised scenarios and any material gaps. Hand back the evidence; product fixes require their own scope.

---
name: swarm
description: "Coordinate independent investigation slices or candidate comparisons and return one evidenced result; use for explicit swarm or useful parallel coverage. Preserve the caller's workflow and writer boundaries."
---

# Swarm

Main frames the work, assigns independent concerns, validates the results, and returns one synthesis. Use the runtime's available [roles](../../roles.md) and tools rather than Cursor cloud-worker parameters or a fixed model roster.

## Frame and Assign

- State the requested outcome, artifact/version, required coverage, execution limits, and completion evidence. Choose partitioned coverage or independent candidates. For candidates, state the selection criteria before comparing results; agreement is not proof.
- Delegate only independent work whose result helps the task. Derive the number of agents from the requested coverage and available capacity, not the concurrency ceiling. Work directly when no useful split exists.
- Use an `explorer` with [Analyze](../analyze/SKILL.md) for read-only code investigation. Use fresh `thinker` review assignments only through [Review](../review/SKILL.md); let it own reviewer selection and audits. Each assignment includes the concrete question, relevant raw evidence, criterion paths when needed, exclusions, and what proof to return.
- For implementation, retain [Code](../code/SKILL.md)'s one designated writer and selected workflow. Read-only agents can investigate independent concerns alongside that writer. Writable candidate experiments require an explicitly permitted experimental scope and isolated owned workspaces; they do not authorize concurrent production writers. Tell every writer they are not alone, preserve others' edits, and define ownership and integration responsibility.
- For measurements, specify the exact artifacts, method, and comparison conditions. Avoid contention that invalidates comparison. Use [Separate Independent State](../principle-separate-shared-state/SKILL.md) for write ownership and [Performance Evidence](../principle-performance-evidence/SKILL.md) for measured claims.

## Collect and Synthesize

Wait for every required slice, while continuing independent work and user updates. An unavailable or incomplete result is a coverage gap. Seek a targeted follow-up when it can resolve that gap; do not treat a missing result as success or respawn indefinitely without new evidence.

Validate decisive claims against the source/version and exact returned evidence. Reconcile disagreements through counterevidence and the declared criteria. A winning candidate still needs the caller's integration, correctness, and review checks before adoption.

Return one report with the answer, supporting evidence, required coverage gaps, and consequential disagreements. Use a compact table when it helps comparison; do not paste agent dumps. This capability preserves the caller's scope, authority, rigor, and reporting requirements. Fast and PoC code workflows remain direct paths.

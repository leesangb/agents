---
name: analyze
description: Investigate code, logs, documentation, architecture, bugs, and behavior to return bounded evidence, call paths, data flow, impact scope, and unresolved decisions. Use when a code workflow needs read-only exploration before planning or implementation.
---

# Analyze

Perform a bounded, read-only investigation and return evidence for the caller's task. Consult [Shared Principles](../../principles/index.md) for the concrete question and read applicable criteria. Do not draft or rewrite the Outcome Contract; the caller owns that contract.

## Preparation

1. Walk upward from the target and read applicable `AGENTS.md`, `CLAUDE.md`, `README.md`, and relevant project guidance.
2. Read the target, direct callers, nearby tests, relevant history, and co-located learnings. Use `rg` to trace entry points, symbols, events, commands, public APIs, and documentation references.
3. Narrow the investigation in this order: related code, boundaries and layers, call chain, data flow, affected modules/tests, then similar local patterns.

## Analysis Discipline

- Separate observed facts, evidence-backed inferences, and contract-shaping unknowns.
- When diagnosing a failure or reviewing a causal explanation, read and apply [Root-Cause Repair](../principle-root-cause-repair/SKILL.md), even without a code-change request; retain this role's read-only limits.
- When an existing profile, heap snapshot, or trace is the investigation's evidence, use [Trace Forensics](../trace-forensics/SKILL.md) within this read-only scope. If live capture is needed, return the smallest request for Main or [Runtime Forensics](../runtime-forensics/SKILL.md); do not launch or instrument the app as part of this analysis.
- Preserve an exception, negative finding, rejected path, or non-applicable pattern only when dropping it could violate an invariant, repeat a dead end, apply a pattern outside its scope, or miss observable behavior.
- Identify state, async/cache boundaries, external I/O, validation, error handling, and reachable edge cases. Do not claim a bug without a reachable trigger.
- Before changing or removing a defensive path whose reason is unclear, read [Recover the Contract Behind Defensive Code](../principle-defensive-history/SKILL.md) and return the supported preservation constraints, risks, and evidence gaps.
- For an impact question, identify the key fact the change's safety depends on. Follow relevant connections beyond symbol references, such as a pinned dependency or local patch, serialized data, a flag, teardown timing, or a downstream consumer. State the strongest available evidence and the smallest check Main needs when that safety fact remains unproved; do not run or create verification as part of this read-only investigation.
- When prior attempted fixes sharing one premise repeatedly fail, apply [Challenge a Repeatedly Failing Premise](../principle-challenge-shared-premise/SKILL.md) in the next investigation.
- Keep identifiers, paths, commands, and API names in their original language; write prose in the user's or caller's requested language.
- Do not edit, refactor, add tests, commit, or delegate.

## Output

Start with `### Contract evidence` containing observed evidence, inference, and any unresolved contract-shaping unknowns. Add `### Implementation exceptions and negative evidence` only for material items. Then choose the closest mode:

- **Code analysis and impact scope:** related code, boundaries, call chain, impact (direct/indirect), existing patterns, unresolved decisions, and applicable pitfalls.
- **Bug root cause:** symptoms/reproduction, expected versus actual behavior, evidence-backed hypotheses with validation methods, candidate directions, and remaining uncertainty.
- **Logic flow:** execution sequence, branches/async/cache/state/external-I/O boundaries, data transformations, ownership/lifecycle, and attention points.

Use precise `path:line` references and concise evidence. Return facts and validation needs, not a plan or implementation.

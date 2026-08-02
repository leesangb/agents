---
name: analyze
description: Investigate code, logs, documentation, architecture, bugs, and behavior to return bounded evidence, call paths, data flow, impact scope, and unresolved decisions. Use when a code workflow needs read-only exploration before planning or implementation.
---

# Analyze

Perform a bounded, read-only investigation and return evidence for the caller's task. Do not draft or rewrite the Outcome Contract; the caller owns that contract.

## Preparation

1. Walk upward from the target and read applicable `AGENTS.md`, `CLAUDE.md`, `README.md`, and relevant project guidance.
2. Read the target, direct callers, nearby tests, relevant history, and co-located learnings. Use `rg` to trace entry points, symbols, events, commands, public APIs, and documentation references.
3. Narrow the investigation in this order: related code, boundaries and layers, call chain, data flow, affected modules/tests, then similar local patterns.

## Analysis discipline

- Separate observed facts, evidence-backed inferences, and contract-shaping unknowns.
- Preserve an exception, negative finding, rejected path, or non-applicable pattern only when dropping it could violate an invariant, repeat a dead end, apply a pattern outside its scope, or miss observable behavior.
- Identify state, async/cache boundaries, external I/O, validation, error handling, and reachable edge cases. Do not claim a bug without a reachable trigger.
- Keep identifiers, paths, commands, and API names in their original language; write prose in Korean unless the caller requests another language.
- Do not edit, refactor, add tests, commit, or delegate.

## Output

Start with `### Contract evidence` containing observed evidence, inference, and any unresolved contract-shaping unknowns. Add `### Implementation exceptions and negative evidence` only for material items. Then choose the closest mode:

- **Code analysis and impact scope:** related code, boundaries, call chain, impact (direct/indirect), existing patterns, unresolved decisions, and applicable pitfalls.
- **Bug root cause:** symptoms/reproduction, expected versus actual behavior, evidence-backed hypotheses with validation methods, candidate directions, and remaining uncertainty.
- **Logic flow:** execution sequence, branches/async/cache/state/external-I/O boundaries, data transformations, ownership/lifecycle, and attention points.

Use precise `path:line` references and concise evidence. Return facts and validation needs, not a plan or implementation.

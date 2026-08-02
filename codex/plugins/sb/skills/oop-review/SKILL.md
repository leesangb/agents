---
name: oop-review
description: Review TypeScript object-oriented design for behavioral contracts, substitutability, encapsulation, inheritance and implementation relationships, domain invariants, API design, and type safety. Use when these extension or invariant surfaces change.
---

# OOP Review

Review only the supplied scope through the object-oriented design capability. Do not edit files, post comments, or spawn more work.

## Review

- Read full changed files, direct callers, implementations, subclasses, interfaces, extension points, mutable state, invariants, and tests.
- Check substitutability and behavioral contracts, encapsulation, inheritance/implementation relationships, mutable domain invariants, lifecycle, type precision, and caller-facing API obligations.
- Keep scope and behavior-preservation constraints authoritative. Do not widen to general correctness, naming, architecture, or tests unless the issue is specifically an OOP contract.
- Use the smallest safe change and require a reachable trigger or observable consequence for blockers. Suggestions are non-blocking and must not start a fix loop alone.

## Output

Return concise finding drafts with severity, `path:line`, contract evidence, consequence, smallest safe fix, and verification. Separate non-blocking suggestions from concrete design blockers. If none remain, report the contract as sound.

---
name: principle-build-the-lever
description: "Make transformations, analyses, or verification reproducible with a small tool when deterministic execution improves correctness or reviewability."
---

# Build the Lever

Use when a mechanically expressible task or its verification is more reliable and reviewable as a rerunnable tool than as a sequence of manual edits or observations. Reuse existing commands, codemods, scripts, generators, or queries before building another.

Establish the rule on a representative unit, then automate the known mechanics. Check that the tool reproduces the intended result and rejects or reports unsupported inputs. Prefer one deterministic pass over agents hand-applying the same rule; leave unresolved design choices outside the automation.

Make the tool's inputs, scope, effects, and verification clear. For retryable mutations, apply [Re-execution Safety](../principle-reexecution-safety/SKILL.md). Keep the tool with the work when future users need to rerun it; otherwise keep scratch tooling out of commits. Describe the actual artifact and evidence when claiming reproducibility.

The tool must save more execution or verification effort than it adds in code, concepts, and maintenance. A few obvious edits can remain direct. Use [Encode Recurring Lessons in Structure](../principle-encode-lessons-in-structure/SKILL.md) instead when the goal is durable prevention of a demonstrated recurring mistake.

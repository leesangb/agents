---
name: principle-behavioral-verification
description: "Express API and function intent as executable guarantees through the owning boundary; use when writing tests or assessing regression evidence."
---

# Behavioral Verification

Use when writing or choosing tests, placing verification, or judging whether evidence protects observable behavior.

Start from accepted requirements, documented contracts, and real callers: what is this API or function for, under which conditions, and what must it guarantee on success and failure? Derive expected outcomes from that intent rather than copying the current implementation into assertions. Resolve unclear intent before encoding assumptions as required behavior.

Verify through the smallest stable public boundary that owns the guarantee: a rule/transform, interaction, or composed use case. A mechanism's interface protects its behavior; the composition point protects requirement-owned ordering and effects.

- Make each test a concrete example of a promised guarantee. For every assertion, identify the caller-visible promise it protects. Compare value objects by semantic value; require reference identity, internal ordering, or a particular representation only when the contract or a real caller depends on it. Name the behavior and keep the distinguishing setup, action, and expected outcome understandable together.
- Cover material behavior changes and reachable boundary, error, retry, concurrency, and regression cases. Prefer returned results, rendered behavior, events, state transitions, persisted values, and request payloads over helper names, private state, incidental call order, or mocks that restate implementation.
- A meaningful test distinguishes a plausible contract violation from a valid implementation: breaking the promised guarantee should fail it, while a behavior-preserving rewrite should keep it valid. When the interaction itself is the contract, an interaction assertion can be appropriate; otherwise prefer the observable result.
- For claimed protection against a concrete regression, seek evidence that the check fails on the buggy version or a representative fault and passes after the correction. Missing execution evidence leaves that protection unverified; identify the smallest distinguishing check. Select this comparison for the claimed regression rather than every unrelated test.
- Check deterministic timing, network, environment, and concurrency assumptions. A broad integration test should expose which responsibilities it actually protects.
- Trace whether fixtures, mocks, or fake clocks replace the behavior an assertion claims to prove. For shared setup/cleanup state, use [Owner and Consumer Lifetimes](../principle-operational-safety/SKILL.md#owner-and-consumer-lifetimes) to establish what cleanup actually restores. Apply that evidence to test validity; a faulty fixture does not itself establish a production defect.
- Distinguish helper-level proof from the real consuming path's guarantee. Place a missing invariant at its owner and select the smallest check that reaches it; a missing guarantee does not automatically need a full end-to-end test.

Use [Responsibility and Change](../principle-responsibility-and-change/SKILL.md) if the production owner of a guarantee is unresolved, and [Operational Safety](../principle-operational-safety/SKILL.md) for a production lifetime risk. Add coverage or infrastructure for an accepted behavior gap, not coverage quantity alone.

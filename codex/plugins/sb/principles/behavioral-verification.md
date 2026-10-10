# Behavioral Verification

Use when choosing tests, placing verification, or judging whether evidence protects observable behavior.

Identify the responsibility and what its caller or user observes on success and failure. Verify through the smallest stable public boundary that owns that behavior: a rule/transform, interaction, or composed use case. A mechanism's interface protects its behavior; the composition point protects requirement-owned ordering and effects.

- Cover material behavior changes and reachable boundary, error, retry, concurrency, and regression cases. Prefer returned results, rendered behavior, events, state transitions, persisted values, and request payloads over helper names, private state, incidental call order, or mocks that restate implementation.
- A behavior-preserving implementation rewrite should keep the test valid. When the interaction itself is the contract, an interaction assertion can be appropriate; otherwise prefer the observable result.
- For claimed protection against a concrete regression, seek evidence that the check fails on the buggy version or a representative fault and passes after the correction. Missing execution evidence leaves that protection unverified; identify the smallest distinguishing check. Select this comparison for the claimed regression rather than every unrelated test.
- Check deterministic timing, network, environment, and concurrency assumptions. Keep scenario-specific setup and expectations understandable together. A broad integration test should expose which responsibilities it actually protects.
- Trace whether fixtures, mocks, or fake clocks replace the behavior an assertion claims to prove. For shared setup/cleanup state, use [Owner and Consumer Lifetimes](operational-safety.md#owner-and-consumer-lifetimes) to establish what cleanup actually restores. Apply that evidence to test validity; a faulty fixture does not itself establish a production defect.
- Distinguish helper-level proof from the real consuming path's guarantee. Place a missing invariant at its owner and select the smallest check that reaches it; a missing guarantee does not automatically need a full end-to-end test.

Use [Responsibility and Change](responsibility-and-change.md) if the production owner of a guarantee is unresolved, and [Operational Safety](operational-safety.md) for a production lifetime risk. Add coverage or infrastructure for an accepted behavior gap, not coverage quantity alone.

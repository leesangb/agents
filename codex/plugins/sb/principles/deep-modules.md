# Deep Modules

Use when designing or changing a module's interface, considering deeper ownership of mechanics, or evaluating whether a seam or abstraction earns its cost.

A module has an interface and an implementation. Its interface includes everything a caller must know: inputs/results, preconditions, invariants, error behavior, ordering, lifecycle, configuration, and material performance characteristics. A seam is where that contract can be satisfied by an implementation or adapter.

## Judge Depth by Caller Leverage

A deep module lets callers obtain useful behavior through a small, honest contract while its owner handles substantial mechanics. Compare the caller's knowledge and duties with the behavior, invariants, and failure/lifecycle work the module fulfills. Implementation size and parameter counts do not measure depth.

Push implementation knowledge and repeatable mechanics into the lowest owner that can enforce them completely. Keep behavior with the state and invariants it changes. Preserve decisions the caller genuinely owns; reducing parameters by silently choosing product policy makes the contract less honest.

Compare representative normal and exceptional uses. A short external facade is not enough: inspect internal collaboration interfaces and the callers that still perform setup, recovery, cleanup, or invariant maintenance. Internal decomposition can remain small and testable while the external contract stays deep.

## Make Depth Reduce Change Cost

Ask what happens if the module is removed. Mechanics or invariant enforcement reappearing across callers is evidence that it earns its keep. Pure indirection disappearing suggests a shallower contract; also account for real compatibility, domain meaning, trust, or effect boundaries before deleting it.

Judge locality by where behavior, knowledge, failures, and verification concentrate. Deepening should reduce repeated caller knowledge and coordinated edits while preserving independent change axes. A large owner mixing unrelated policies, a sequence split into shallow helpers, or a facade hiding equally burdensome internal calls is a counter-signal.

## Add Seams Where Obligations or Variation Are Real

Use a seam for a current independent contract or justified variation, including an actual external conversation and a useful production/test adapter. A single caller or implementation can still own a real invariant or lifecycle. Existing implementations can supply concrete evidence of variation.

Keep private seams private when they serve implementation or verification mechanics. Accept dependencies through the external interface only when callers legitimately supply or choose them; testability alone does not make all wiring caller-owned. Pure transformations can return values while the owning shell handles effects when that separation clarifies the real contract.

Judge the module's claimed contract against evidence at the public responsibility that promises it. Preserve useful lower-level tests for independently owned contracts; retire obsolete tests only after the replacement protects their guarantees. A new seam, wrapper, or generalized option must justify its build, navigation, runtime, and maintenance costs.

## Related Questions

- If the comparison depends on whether a caller truly chooses a value or only forwards wiring, use [Caller Obligations](caller-obligations.md).
- If an ownership/merge proposal leaves a distinct question about shared design knowledge or dependency direction, use [Responsibility and Change](responsibility-and-change.md).

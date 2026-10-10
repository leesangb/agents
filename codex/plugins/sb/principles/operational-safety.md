# Operational Safety

Use when a change creates a concrete trust, data, compatibility, recovery, concurrency, resource, or performance question.

Trace reachable failure scenarios through inputs, state, and event sequences. Assess likelihood and impact using the actual contract and environment. Check security, privacy, permissions, abuse, data integrity/loss, compatibility, migrations, rollout, flags, production configuration, reliability, observability, supportability, and rollback where relevant. Area names alone do not establish a defect.

- Consider structural issues such as circular dependencies, hidden ownership, broad modules, premature abstraction, and mixed change axes when they produce an operational or debugging cost.
- For retry/resume of state-changing operations, use [Re-execution Safety](reexecution-safety.md) to identify repeated-run and partial-failure proof.
- For performance claims or measured choices, use [Validate a Performance Claim](performance-evidence.md) to establish a representative baseline, equivalent successful work, variation, and resource/complexity costs.
- Check guards, caller constraints, and recovery paths that defeat the concern. Distinguish a scenario possible in this system from one merely possible in principle, and identify missing evidence proportionally to the claimed impact.

Compare a practical mitigation with the problem the change solves and the cost of its safeguards. Keep behavior, authorization, and ownership explicit.

## Owner and Consumer Lifetimes

For shared state, caches, subscriptions, or resources, trace what each owner creates, changes, and releases, and what consumers retain. Restoring an owner's value may leave captured references or subscriptions unchanged. Compare consumer lifetimes with the owner's change and cleanup sequence.

Check counterevidence: a consumer may read the current value, be correctly rebound, or be disposed before restoration. Use the actual sequence to establish the consequence, including whether fixture cleanup restores the conditions a test claims to verify. An operational risk requires its reachable failure and operational consequence; incomplete lifetime evidence remains a proof gap.

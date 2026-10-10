# Separate Independent State

Use when deciding whether concurrent actors need one shared mutable target, a lock, or a single-writer procedure.

Ask whether the actors need one canonical mutable object or publish independent facts. Separate independent write targets and combine at the read boundary when the contract allows it; structurally serialize a shared target when domain consistency requires it.

The contract determines whether separation is valid. Independent storage is not a substitute for a required shared invariant, and concurrency alone does not justify a lock.

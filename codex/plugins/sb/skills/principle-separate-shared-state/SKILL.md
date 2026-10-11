---
name: principle-separate-shared-state
description: "Separate independent write targets before adding locks; serialize structurally when one canonical mutable object is a real invariant."
---

# Separate Independent State

Use when deciding whether concurrent actors need one shared mutable target, a lock, or a single-writer procedure.

Ask whether the actors need one canonical mutable object or publish independent facts. Separate independent write targets and combine at the read boundary when the contract allows it; structurally serialize a shared target when domain consistency requires it.

The contract determines whether separation is valid. Independent storage is not a substitute for a required shared invariant, and concurrency alone does not justify a lock.

Trace the actors and the actual write target before choosing coordination. Two workers updating different fields in one `state.json` still share a write target: either can overwrite the other's update. Separate owned files or keys when each publishes an independent fact, and combine them at the read boundary.

When one canonical object protects a real invariant, enforce its write order through an existing transaction, single-writer owner, or equivalent structural mechanism. A convention saying "take turns" does not enforce serialization. Check the invariant and the relevant concurrent sequence; separate storage is wrong when it permits a state the contract forbids.

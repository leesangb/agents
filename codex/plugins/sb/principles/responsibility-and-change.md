# Responsibility and Change

Use when choosing the owner or dependency direction of an identified responsibility, or tracing shared design knowledge and coordinated changes.

Identify which behavior and knowledge change together. Examine requirement policy, rules, input/output conversion, validation, rendering, external integration, and error handling in the relevant flow. Trace which modules know the same design decision or implementation detail and would require coordinated edits if it changed; duplicated knowledge can leak a boundary without duplicated code.

- Derive concepts from states, rules, transitions, and transformations already moving together. A selection, lifecycle, policy, draft, or synchronization concept can make that shared knowledge visible; derive it from the actual behavior.
- Treat newly introduced or distributed ownership as a responsibility change. Identify who knows and enforces the sequence, invariant, lifecycle, and failure contract. Preparing, executing, and restoring one operation can scatter its invariant; required temporal order alone neither justifies separation nor proves a defect.
- Compare logical and physical boundaries, domain state versus framework lifecycle, and which existing owner knows each contract. Keep requirement-specific policy distinct from the identified mechanism's promise.
- Before adding a layer or moving responsibility, compare correcting the existing owner's contract or making a small behavior-preserving prefactor. A proposed owner must enforce the responsibility without learning another module's internal representation or update procedure; relocation alone does not remove leaked knowledge.
- Evaluate dependency cycles, shallow indirection, premature managers/providers/adapters, and mixed change axes by their concrete maintenance or behavior cost. Retain necessary complexity when separation would add a larger cost.

## Related Questions

- If the unresolved question is whether a mechanism should exist or where feature policy is assembled, use [Composition and Mechanisms](composition-and-mechanisms.md).
- If a proposed split/merge needs an independent-change case or cost comparison, use [Simplicity and Coupling](simplicity-and-coupling.md).

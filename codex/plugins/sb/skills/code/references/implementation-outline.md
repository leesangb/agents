# Implementation Outline Blueprint

Use this reference when presenting the `Recommended Implementation Outline` in a Fast, Deep, or Ultra plan.

Keep the rest of the plan in ordinary prose and bullets. Render only the implementation outline as a shallow tree when the change has meaningful module, interface, responsibility, seam, or dependency structure. A single local edit may remain one concise bullet when a tree would add no clarity.

Do not print a legend in the plan. Apply these markers directly where they carry information:

- `=` preserves an existing module, interface, responsibility, or call path.
- `~` extends an existing module, interface, responsibility, or composition point.
- `+` introduces a new module, interface, responsibility, or dependency.
- `×` intentionally excludes a call, dependency, mutation, or side effect.

Make the blueprint describe:

- modules and likely seams or files;
- the interface each caller must know;
- responsibility placement and ownership movement;
- provider-to-consumer dependency direction;
- preserved paths and intentional non-calls when they constrain the design.

Keep the tree shallow, normally two to four levels. A marker on a parent applies to its subtree unless a child overrides it. Use a short inline note only for responsibility, rationale, or an invariant that the tree cannot express by structure alone.

Do not turn the blueprint into a detailed call stack or pseudocode. Unless the Outcome Contract fixes them, omit internal algorithms, helper or hook choices, concrete state containers, exact event sequences, file splitting, and step-by-step control flow. Keep those choices adaptable for implementation.

Prefer this shape:

```text
~ Existing module or composition point (`likely/path`)
├─ interface: caller-visible obligation
├─ responsibility: behavior owned behind the interface
├─ + New collaborating module
│  ├─ interface: smallest useful surface
│  └─ responsibility: hidden behavior or lifecycle
├─ = Existing downstream path
└─ × Forbidden dependency or side effect
```

Treat the entire outline as adaptable guidance unless the Outcome Contract explicitly fixes a node or relationship.

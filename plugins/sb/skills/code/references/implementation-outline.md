# Implementation Outline

Use a structural sketch when it helps explain responsibility, interfaces, or dependency changes. Prose or a short bullet is enough for a local edit.

Show the relevant modules or likely files, caller-visible obligations, ownership, and preserved constraints. Keep implementation mechanics adaptable unless the Outcome Contract fixes them. Choose a tree, before/after sketch, or another compact representation that explains the decision.

For example:

```text
Position capability
  reads and changes page-level coordinates
  reuses the existing movement command
    preserves child movement and undo restoration
```

Include intentional exclusions only when they constrain the design. Do not turn a planning illustration into an unnecessary commitment to helper names, file splits, or internal algorithms.

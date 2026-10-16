# Implementation Outline

Before implementing new behavior or changing interfaces, ownership, or wiring, sketch the affected use case from the consuming caller through collaborating modules to state changes or external effects. Read the actual callers and existing interfaces first; label proposed calls as proposed. A local correction within established boundaries needs only a brief explanation of the affected flow.

Use [Caller Obligations](../../principle-caller-obligations/SKILL.md) to choose the representative call and distinguish the caller's legitimate policy choices from mechanics an owner can handle completely. Establish that call and responsibility split before choosing implementation internals. Include internal collaboration boundaries, not only a short public facade. Use [Deep Modules](../../principle-deep-modules/SKILL.md) if the proposed split still leaves callers managing mechanics, and [Composition and Mechanisms](../../principle-composition-and-mechanisms/SKILL.md) when composing capabilities or deciding whether a separate mechanism is justified.

Show the caller's goal, representative call, owners, and preserved constraints in a few lines. For example, a proposed outline:

```text
User moves a selection
  feature calls moveSelection(selection, displacement)
    movement command owns coordinate conversion and child movement
      history owner preserves undo restoration
```

Reuse existing owners where their contracts fit. Keep mechanics adaptable unless the Outcome Contract fixes them; the sketch does not require new helpers, layers, files, or approval. Revisit it if implementation changes who must know or do what.

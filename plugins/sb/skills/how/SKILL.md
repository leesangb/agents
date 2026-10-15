---
name: how
description: "Explain how code or a subsystem works, including runtime flow, ownership, and layering; use for walkthroughs and '어떻게 동작해'. Use why for historical rationale."
---

# How

Build a working mental model for the person asking the question. Explain the actual behavior and responsibilities rather than returning an investigator's handoff or annotated source.

## Trace and Explain

1. Fix the target and question from the request and current context. State a reasonable interpretation and investigate when the scope is broad; ask only when different interpretations would make the explanation unusable.
2. Read the applicable local instructions, entry point, relevant implementation, and consumers. Trace the trigger, calls, data transformations, branching, state, async work, and effects far enough to explain the requested behavior. Use [Analyze](../analyze/SKILL.md) for bounded evidence gathering when useful.
3. Explain directly for a narrow question. For genuinely independent subsystem slices, Main may use [`explorer`](../../roles.md) agents with bounded read-only assignments, then reconcile their evidence. Use [Swarm](../swarm/SKILL.md) when coordinating several slices needs a shared coverage contract; do not force a separate explainer agent.
4. Check material claims against the actual source and consumers. Distinguish source-observed behavior, executed observations, and unresolved runtime assumptions. For a placement question, use the relevant [Shared Principles](../../principles/index.md), not a preferred layer diagram.

Lead with what the subsystem does. Explain the concepts needed to follow one representative execution, show the flow and where responsibilities live, and include non-obvious constraints only when they matter. Use concrete symbols and precise source links; a short call tree or diagram can replace a long structural paragraph. Keep the depth proportional to the question and preserve uncertainty.

This is an explanation task. Do not edit product code or start live capture. Use [Why](../why/SKILL.md) when the question concerns author intent or the history behind the shape; current code alone does not establish that intent.

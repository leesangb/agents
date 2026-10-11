---
name: principle-experience-first
description: "Prefer the user's core experience over implementation convenience when product, UX, API, or feature-scope tradeoffs arise; justify every control and caller obligation."
---

# Experience First

Use when implementation convenience competes with the experience of the person consuming the work. For an interface that person is the end user; for an API it is the caller; maintainers also bear the cost of the design.

Start from the accepted core task and what the user must do, understand, wait for, or recover from. Prefer a complete, polished core path over extra features that make that path harder. Every control, option, and obligation needs a present purpose.

- Judge feedback, error recovery, accessibility, interaction details, and the clarity of the next action as part of completing the task.
- For an API, compare representative caller code and the duties it imposes. Use [Caller Obligations](../principle-caller-obligations/SKILL.md) for the detailed interface criteria.
- When the tradeoff depends on interaction feel or an unknown behavior, use the smallest authorized sketch or observation that can resolve it before committing to the production design.
- Explain the choice through the user's task: what becomes easier, more reliable, or clearer, and what cost remains.

Preserve correctness, data, accessibility, and the requested scope. Delight does not authorize new features, a visual rewrite, or hidden policy choices. Necessary implementation complexity can earn its cost when it improves the accepted experience; apparent polish that obscures failures or weakens safeguards does not.

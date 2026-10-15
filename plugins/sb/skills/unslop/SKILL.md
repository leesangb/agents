---
name: unslop
description: "Remove vague claims, AI filler, jargon, and over-compression from writing while preserving meaning, evidence, and the requested voice; use for prose cleanup or '자연스럽게 고쳐줘'."
---

# Unslop

Make the text concrete and readable without changing its claims, scope, or confidence. Match the requested language and voice; Korean defaults to calm, friendly banmal unless the user requests another register.

## Edit the Meaning, Then the Sentence

- Replace vague praise, unnamed authorities, and claims of improvement with the actual mechanism, source, or measured result. If none exists, remove or qualify the claim. Never invent evidence to make the text sound stronger.
- State the point directly. Cut chatbot openings, flattery, rhetorical question-and-answer framing, generic conclusions, and comparisons that introduce an alternative the reader did not ask about.
- Prefer concrete verbs and familiar words. Replace ornamental terminology with the real action or concept; preserve accurate technical names, API symbols, and domain terms.
- Split sentences the reader must backtrack to parse. Preserve conditions, exceptions, units, and uncertainty that change the meaning. Avoid forcing every sentence to the same short length.
- Repair over-compression: restore actors, verbs, relationships, and missing explanation. Symbols, fragments, or abbreviations that make the reader decode are not clarity. Keep useful diagrams and code notation when they express structure precisely.
- Reduce decorative headings, repetitive bold labels, redundant bullets, and punctuation used for emphasis. Choose prose, a list, or a table according to the information; do not impose English punctuation rules on every language.
- Keep one name for one concept and retain the author's requested tone. Preserve quotations and executable snippets unless their modification is explicitly part of the task.

Read the result once for meaning and once for fluency. Report substantive ambiguities instead of silently resolving them. A request to rewrite supplied text returns the rewritten text; a request to edit a file authorizes only that document's scope. Use [Technical Writing](../technical-writing/SKILL.md) when the task also needs document structure or procedural guidance.

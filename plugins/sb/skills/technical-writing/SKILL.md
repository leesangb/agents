---
name: technical-writing
description: "Write or review technical docs, RFCs, READMEs, PR descriptions, and procedures around the reader's task, precise conditions, and observable results."
---

# Technical Writing

Write so the intended reader can understand the decision or perform the task on the first read. Use the codebase's actual symbol, file, option, and command names. Read applicable local instructions and existing documentation before changing a document.

## Choose the Reader's Task

Identify the document's main purpose: a tutorial teaches through a successful task; a how-to guides competent execution; a reference describes lookup facts; an explanation develops the reasoning. Separate substantial material serving different purposes when it interrupts the reader's task, and link it rather than forcing every document into a rigid template.

For a procedure, put prerequisites and conditions before the step they govern, give actions in execution order, and state the observable result at meaningful checkpoints. Include failure or recovery behavior when the reader needs it to continue safely. For reference, describe supported values, units, effects, limits, and errors without turning it into a walkthrough. For an explanation or RFC, state the chosen direction and the evidence and tradeoffs that justify it.

## Make the Contract Clear

- Name who does what. Prefer active voice and instructions the reader can execute.
- Keep one meaning for each term and make pronouns point to an obvious subject. Place words such as "only" next to the thing they qualify.
- Preserve the words and conditions that disambiguate a sentence; shortening is useful only when meaning stays clear.
- Give each step one action and keep dependent conditions beside it. Use numbered lists for sequences and tables for genuine comparisons.
- Ground commands, counts, paths, examples, and behavior claims in the relevant artifact/version. Run an authorized example when its execution is needed to establish the claim; mark unavailable execution as unverified.
- Explain otherwise unclear inputs, outputs, ordering, lifecycle, and effects at the owning interface. Keep implementation rationale distinct from caller-visible obligations.

Apply [Unslop](../unslop/SKILL.md) for concrete language, natural rhythm, and removal of filler. Match the user's language and the existing document's conventions; avoid turning style preferences into universal bans.

A PR description leads with the concrete problem and resulting behavior, then the validation and material limits a reviewer needs. Keep investigation logs and agent transcripts out of it. Preserve established templates and destinations. Writing a description or commit message does not authorize posting it, committing, or publishing. Product UI strings follow the product's copy conventions.

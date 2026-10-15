---
name: architecture-plan
description: Plan code changes from confirmed evidence and a fixed Outcome Contract when design or cross-module decisions need investigation.
---

# Architecture Plan

Main may plan directly or delegate a distinct read-only planning concern to a [`thinker`](../../roles.md). The caller alone owns the Outcome Contract; a delegated planner quotes its supplied snapshot unchanged and never asks the user directly. Do not implement or edit files.

Read [Planning and Resuming](../code/references/planning.md) for required plan information and the distinction between fixed contract-shaping choices and adaptable implementation recommendations. Read [Decision Dialogue](../code/references/decision-dialogue.md) for Deep/Ultra or unresolved design choices. Preserve its eligibility and relay rules; discoverable evidence gaps go to Main for investigation rather than automatically becoming user questions.

Use current target/caller/test evidence and relevant local guidance. Consult [Shared Principles](../../principles/index.md) and read those relevant to the accepted use case, proposed interface, and ownership choices. Read [Practical Design Foundations](../principle-design-foundations/SKILL.md) when criteria conflict or a trusted-value, values/effects, or normal-flow question remains. Read [Composition and Mechanisms](../principle-composition-and-mechanisms/SKILL.md) only for a concrete composition, mechanism, or seam question. Explain the evidence behind material design choices.

Return exactly one result:

- `ready`: the complete plan with the supplied Outcome Contract, relevant confirmed facts, implementation direction, material decisions, and verification. No unresolved discoverable prerequisite or eligible decision remains. Required information is fixed; headings, tables, diagrams, and section order are optional.
- `needs-decisions`: the design tree and eligible frontier required by Decision Dialogue, including decision IDs, prerequisites, evidence, options, recommendation/reason, and consequence. The frontier may be empty while Main investigates a prerequisite. Do not infer answers or substitute a partial plan.

Keep verification proportional to the contract. Prefer existing coverage; propose behavior tests only for missing protection or an explicit request. The user-facing plan must make fixed decisions and writer-adaptable recommendations clear.

# PoC Code Change Workflow

Use only after the [router](../SKILL.md#select-a-workflow) selects an explicitly disposable experiment. Its Ultra gate remains authoritative; return there if any such signal appears.

## Establish the Experiment

Define one answerable question, the smallest reversible build, and the direct observation that answers it. State the experiment note and proceed without plan approval:

```text
PoC — question: <question>; build: <smallest experiment>; observe: <direct observation>; omitted: tests/review/hardening.
```

Main is the sole writer and observer. Work directly without subagents or review orchestration. Use relevant shared principles from the router's index to judge the experimental design and evidence while keeping the build limited to the question.

## Build and Observe

Write the smallest disposable implementation and inspect its rendered result, command output, interaction, or equivalent direct evidence. Iterate within the unchanged question and permitted effects. Automated tests, typecheck, lint, review, and production hardening are outside this experimental workflow; record any checks actually performed.

If the question, permitted effects, or risk changes, stop and return to the router. A request to keep, ship, harden, or rely on the result ends PoC: use the experimental diff as evidence for a production workflow, then complete that workflow's authorization and verification requirements.

## Report

Lead with the observed result and whether it answered the question. State the build, direct evidence, omitted checks, and that the output is disposable and not production-ready. Explain experimental selection when needed; speed wording alone does not establish experimental intent.

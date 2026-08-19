# PoC Code Change Workflow

Use this workflow only after the [Code Change Workflow Router](../SKILL.md) selects PoC.

The goal is to answer one bounded experimental question by building and directly observing the smallest safe disposable implementation.

## Interface

PoC accepts a task only when all of these remain true:

- **Question**: the experiment has one answerable question or hypothesis.
- **Smallest build**: the implementation can stay limited to the smallest code needed to observe that question.
- **Direct observation**: Main can inspect a rendered result, command output, interaction, or equivalent direct evidence that answers the question.
- **Ultra-safe boundary**: no Ultra signal is present, including authentication, authorization, security, privacy, stored-data mutation or deletion, schema, migration, backfill, rollout, production configuration, external compatibility, explicit high rigor, or long-running coordination.

PoC is not a lower verification tier for an ordinary change. The user must state experimental purpose explicitly; speed wording alone is insufficient. Its output is experimental and not production-ready.

## Ownership

- **Main agent**: states the experiment note, writes the disposable implementation directly, observes it, iterates within the unchanged experiment boundary, and reports the evidence and non-production status.
- Main is the sole writer. Do not spawn subagents or load review orchestration.

## Workflow

1. Establish the experiment boundary.
   - Confirm the question, smallest build, direct observation, and Ultra-safe boundary.
   - State the following note, then begin without plan approval:

   ```text
   PoC — question: <question>; build: <smallest experiment>; observe: <direct observation>; omitted: tests/review/hardening.
   ```

2. Build and observe directly.
   - Write only the disposable code needed to answer the question.
   - Do not require automated tests, review, typecheck, lint, or production hardening.
   - Perform the smallest direct observation that answers the question.

3. Iterate while the boundary holds.
   - Repeat build and observation without approval while the experiment question and Ultra-safe boundary remain unchanged.
   - Keep the experiment reversible and do not expand it into a production implementation.

4. Reroute when the lifecycle changes.
   - Stop and return to the router if an Ultra signal appears or the question or safety boundary changes.
   - A request to keep, ship, productionize, harden, or otherwise rely on the result ends PoC. Return to the router and treat the PoC diff as evidence for Fast, Deep, or Ultra; do not accept it as production code.

5. Report.
   - Lead with the observed evidence and whether it answered the question.
   - State the implemented experiment, direct observation, omitted checks, and that the result is experimental and not production-ready.
   - State that PoC was selected because the user explicitly requested a safe experiment.

## Guardrails

- Do not infer PoC from “빠르게”, “빨리”, “quickly”, or similar speed wording alone.
- Do not use PoC to bypass Ultra safeguards.
- Do not claim tests, review, typecheck, lint, or hardening were performed when they were intentionally omitted.
- Do not silently promote repeated iterations into production readiness.

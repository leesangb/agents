# Decision Dialogue

This is the shared state machine for conditional planning dialogue in Deep and
Ultra. It keeps the planning thinker read-only with respect to user intent and
lets Main own the user conversation and fixed Outcome Contract.

## Eligibility

An unresolved decision is eligible only when **all** of these gates pass:

1. Discoverable facts have been investigated from code, documentation, history,
   logs, or other available evidence.
2. At least two credible answers remain.
3. The answer materially changes the Outcome Contract, top-level assembly,
   interface, ownership, dependency direction, or verification meaning.

Workflow tier, composition classification, reviewer availability, or a
planner's preference alone never triggers dialogue. Facts that Main or an
explorer can discover are not user questions.

An unresolved discoverable prerequisite is evidence or a fact still needed to
evaluate a later branch. It is not an eligible user decision. `ready` requires
both no unresolved discoverable prerequisite **and** no eligible decision. A
`needs-decisions` design tree may show a discoverable prerequisite blocking a
later branch, and its eligible frontier may therefore be empty; Main resolves
that prerequisite from evidence before presenting any user question.

## Tagged result

`architecture-plan` returns exactly one of these results, never both:

```text
ready
  plan: the complete technical plan in the architecture-plan output format

needs-decisions
  design tree: resolved decisions, unresolved prerequisites, branches, and dependencies
  eligible frontier: the currently eligible decisions only (possibly empty while a discoverable prerequisite is unresolved)
```

`ready` is the normal immediate path when no unresolved discoverable
prerequisite and no eligible decision remain. A `needs-decisions` result must
not ask the user, infer intent, or silently choose among credible
contract-shaping answers.

Each frontier item includes:

```text
ID; prerequisites; kind (`contract-shaping` | `implementation recommendation`);
evidence; credible options; recommended answer and reason; plan consequence
```

## Relay and rounds

- If the eligible frontier is non-empty, Main presents it as a numbered batch,
  preserving each planner-provided ID, evidence, options, recommendation, and
  consequence. Main never presents an empty or non-eligible frontier.
- If the frontier is empty because a discoverable prerequisite remains, Main
  investigates that prerequisite without asking the user, then resumes the
  same planning thinker with the new evidence. This resume is not a dialogue
  round.
- Main returns the user's answers by decision ID to the same planning thinker.
  The thinker records them, recomputes the design tree, and returns `ready` or a
  new `needs-decisions` result. The thinker never addresses the user directly.
- Deep asks at most three independent decisions per round and allows at most
  two dialogue rounds. If any eligible frontier remains after round 2, or the
  frontier keeps expanding or cannot fit one bounded implementation packet,
  Main reroutes to Ultra.
- Ultra works the full currently eligible frontier round by round until the
  result is `ready` (subject to its Wayfinder and plan-review rules).
- Reuse the same planning thinker while resolving the same design tree. Start a
  fresh planner after a material reframe or stale evidence; never reuse a
  planning thinker for review.

Answers are planning inputs, not canonical plan approval. Deep and Ultra
present the complete `ready` plan and obtain approval once after readiness.

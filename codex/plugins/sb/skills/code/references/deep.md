# Deep Code Change Workflow

Use after the [router](../SKILL.md) identifies meaningful uncertainty or a caller/ownership contract change that can be handled in one bounded plan.

Read [Planning and Resuming](planning.md) and [Decision Dialogue](decision-dialogue.md). The shared policies define required plan information, authorization, decision eligibility, and progress-based completion. Deep rigor does not require another approval when the implementation request already covers the work.

## Investigate and Plan

- Main investigates the target, callers, behavior, verification, and relevant history far enough to identify the cause or decision surface. Use an `explorer` with `$sb:analyze` only when a separate bounded investigation helps.
- Main fixes the Outcome Contract from user intent and confirmed evidence. Resolve discoverable facts before asking questions.
- Main authors the plan directly or delegates a distinct read-only planning concern to `sb-thinker` with `$sb:architecture-plan`. Apply Decision Dialogue's readiness, eligible frontier, and relay rules in either case. Reuse a delegated planning thread for the same design tree; start fresh after a material reframe or stale evidence.
- Present the complete ready plan and continue when the existing grant covers implementation. Return the plan for a planning-only request; pause only unresolved decisions or effects needing new authority. Do not run a separate plan-review panel on Deep. Reroute to Ultra if risk or dependent staged decisions exceed one bounded plan.

## Implement, Verify, and Review

After authorization and resume validation, Main or one built-in `worker` uses `$sb:implement` and receives the complete current plan and permitted effects. Keep that writer through fixes. Implementation recommendations may adapt; contract changes return to Main for replanning.

Run the verification needed for the Outcome Contract. Invoke `$sb:review` with the Deep profile and actual diff/verification evidence. It owns reviewer selection and conditional audit. The `simplicity` reviewer remains Ultra-only.

Apply supported scoped fixes through the same writer, rerun affected checks, and re-review only claims affected by new changes or evidence. Follow the shared completion and stopping criteria; do not stop merely because a fixed number of review rounds elapsed. An unresolved review concern must be resolved or reported explicitly, never silently treated as agreement.

Report the outcome, verification, material decisions, and unresolved requirements under the router's reporting policy.

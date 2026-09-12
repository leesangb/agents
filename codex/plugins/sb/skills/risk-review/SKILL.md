---
name: risk-review
description: Review concrete security, privacy, data integrity, compatibility, rollout, performance, reliability, concurrency, and support risks in a code change. Use when the artifact creates an operational or trust-boundary question.
---

# Risk Review

Review the exact supplied scope read-only and return risks ordered by likelihood and impact. Do not edit files or post comments.

## Review

- Check security/privacy/permissions, data integrity and loss, abuse, compatibility, migrations, rollouts, flags, production configuration, performance, reliability, concurrency, observability, supportability, and rollback paths.
- Check structural risks only when they create an operational/debugging consequence: circular dependencies, hidden ownership, unclear source of truth, over-broad modules, premature abstraction, or mixed change axes.
- A high-severity risk needs a concrete reachable scenario (inputs/state/event sequence) in this codebase. If upstream guards prevent it, say so and lower severity; distinguish can happen here from could happen in principle.

## Output

For each risk include precise location and evidence, the reachable failure mode, consequence, likelihood/impact, practical mitigation, and focused validation. Explain the problem the change solves when needed to judge the tradeoff. Avoid speculative or style-only concerns.

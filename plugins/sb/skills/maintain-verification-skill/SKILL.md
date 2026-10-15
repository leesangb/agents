---
name: maintain-verification-skill
description: Check and repair an existing project's verification skill, feature map, and owned harness against source and real application behavior. Use when asked to audit or maintain those verification instructions.
---

# Maintain a Verification Skill

Maintain the specified verification skill and its feature map. Infer the target from the request and project conventions; if none exists, point to [Create a Verification Skill](../create-verification-skill/SKILL.md) instead of inventing one during maintenance.

Limit edits to that skill's directory and its owned harness. Distinguish stale instructions, a harness gap, and a product defect: update the first two with proof and report the third without changing product code or rewriting the expected contract to match a regression. This task does not authorize a PR, publication, or scheduled automation.

## Check Source and Live Behavior

1. Read applicable instructions and the map's index and feature files. Check missing, duplicate, and dead entries against concrete source and current accepted behavior. Keep any requested subset authoritative; otherwise account for every mapped feature.
2. Trace each in-scope feature's real entry points and contract. Produce the smallest live recipe needed to check suspected drift. Parallel source readers are useful only when distinct features justify them; they do not drive a shared app instance or edit the map.
3. Reconcile recipes into as few app states as practical. The coordinator owns live driving: one serially driven instance for a shared UI/server, or isolated fresh invocations for a short-lived CLI, as the skill's launch model requires.
4. Run the skill's doctor before driving and after surprising results. If a healthy process has a wedged UI, restore a known state or relaunch the owned instance. Follow the actual user paths, capture actions and results, and check the listed side effects.
5. Correct proven doc or harness drift and re-drive affected recipes. Clean failed-run residue as well as the final owned instance; keep evidence outside disposable state and verify it survives cleanup. When a prerequisite is missing, record the attempted route and exact prerequisite rather than calling the feature verified.

Source reading alone does not establish that live instructions work. If the requested scope is read-only or live execution is unavailable, return source-only findings with the live pass unverified.

## Report

- **Clean:** every in-scope feature has source and live evidence, with no needed correction.
- **Changed:** corrections within the verification directory were re-driven successfully; report coverage and evidence.
- **Blocked or partial:** name the missing prerequisite, failed route, or remaining unverified feature. Do not report a complete audit from a successful subset.

Keep investigation notes and proof in the project's established local artifact location or a scratch directory. Commit or open a PR only when already authorized.

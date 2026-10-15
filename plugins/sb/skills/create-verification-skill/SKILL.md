---
name: create-verification-skill
description: Create a project-local skill and feature map for driving and verifying an application's real UI, CLI, or service. Use when asked to make reusable app verification instructions or create a project-specific verification skill.
---

# Create a Verification Skill

Create a reusable verification recipe grounded in the target project. Follow the caller's scope and existing skill-directory conventions; otherwise use `.agents/skills/verify-<app>/`. Prefer an existing verification skill over creating a second one. This task does not authorize unrelated product fixes, deployments, or messages to others.

## Ground the Recipe

Read applicable instructions, documented run commands, existing test/control harnesses, and the actual user entry points. Establish:

- **Launch:** exact command, required configuration/auth/seed data, and readiness signal. A short-lived CLI needs a fresh invocation rather than a persistent server.
- **Drive:** available tools and stable handles, such as CLI arguments, routes, accessible names, or application debug controls. Prefer existing project mechanisms; describe the required capability rather than assume a particular browser tool is installed.
- **Observe:** the user action, its resulting output/state, and relevant persistence or other side effects.
- **Isolate:** disposable ports, data directories, accounts, or sessions where supported. State any shared-instance limit instead of concurrently driving the same mutable session.

Check the observed launch path before presenting it as usable. If a prerequisite prevents execution, name the real failure and keep the unexecuted recipe labeled as a draft; do not repair unrelated product code to finish this task.

## Write the Skill and Feature Map

Write `SKILL.md` with valid `name` and `description` frontmatter, the exact launch/readiness and teardown instructions, a **Doctor** check for the intended build/instance and prerequisites, drive instructions, proof location, and cleanup. The doctor should match the surface: a CLI version and fixture check can replace a server health probe.

Add a small `features/README.md` index and feature files for the relevant user-facing behavior. Each recipe identifies its entry points, prerequisites, real actions/commands, expected observable result, and traps. Start with the task's important features rather than claiming an exhaustive inventory. Keep implementation walkthroughs out of this user-facing map.

Capture the action and result together. Confirm persistence or external effects through an independent observable view when they are part of the contract. An internal setter, test-only endpoint, success toast, or file timestamp alone does not prove the real path. If using a dry-run, observe what it actually skips. Keep secrets out of commands recorded as evidence.

Use only installed tools and discovered selectors/commands. Add a helper only when it removes a real repeated or fragile operation, document its invocation, and execute it. Cleanup stops only owned processes and removes disposable state; proof artifacts survive cleanup outside that state.

## Prove the Deliverable

Follow the generated instructions through launch, doctor, one mapped feature, evidence capture, and cleanup. Check that the recorded evidence still exists afterwards. Clean residue after failed iterations and re-drive instructions that changed to fix a failure. Report the exercised feature, exact result, and any unverified map entries; one successful feature is not full-app coverage.

Use [Maintain a Verification Skill](../maintain-verification-skill/SKILL.md) when the caller later requests upkeep. Do not create a maintenance schedule unless requested.

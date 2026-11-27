---
name: arena
description: Compare independent solutions to the same task when choosing between viable designs has material consequences for callers or implementation.
---

# Arena

Use candidate comparison when several plausible solutions to the same task would lead to a consequential choice. If the open question is the API shape, a representative call site can settle it without building every implementation.

1. Fix the deliverable, shared starting material, constraints and decision criteria before dispatch. Give each candidate the same brief in a fresh context and a separate output location. Reserve scoring instructions for the coordinator. Keep writable experiments within the authorized scope, with an isolated workspace per candidate and one writer for production changes.
2. Inspect each completed artifact against the criteria. When independent judgment would help, give a fresh reader the brief, criteria and artifacts under neutral labels. Resolve disagreement by checking the disputed behavior or tradeoff. Record missing candidates as a coverage gap; a single result supports no comparative verdict.
3. Choose a base. If the candidates converge, verify their shared solution and report the convergence. Otherwise, identify useful contributions from the alternatives and adopt only pieces compatible with the chosen design. Explain the consequential choice and name the check that supports it. For a design request, return the selected design and call sites. For authorized implementation, the designated writer integrates and verifies the combined result against the original task.

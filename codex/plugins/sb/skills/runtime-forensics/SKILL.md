---
name: runtime-forensics
description: Capture and analyze evidence from a running app or process to diagnose CPU work, retention, waits, or unexpected activity. Use for an explicit live profiling or runtime investigation request; not for existing-artifact analysis or an automatic product fix.
---

# Runtime Forensics

Return a diagnosis grounded in the target's actual execution. Establish the symptom, process/instance and build, user path or workload, capture window, available tools, and environment. Use the project's existing launch/control recipe and installed diagnostic tools where available.

## Capture the Matching Behavior

1. Observe or reproduce the reported behavior on the relevant surface. Choose the smallest signal that can distinguish the current hypotheses: CPU or allocation profile, heap capture, thread/wait sample, execution trace, or a targeted counter.
2. Use an installed profiler or existing diagnostic facility and record how it was configured, the workload, timestamps, and instance/version. Separate startup, warm/cold state, and other conditions when they affect the question. Capturing nothing relevant is a verification gap, not a clean diagnosis.
3. Store evidence outside disposable process/data state and keep secrets out of captures and recorded commands as far as the tool permits. Stop only captures and processes owned by this task; preserve the evidence after cleanup.
4. Apply [Trace Forensics](../trace-forensics/SKILL.md) to the resulting artifact. Retain the exact observations and map the relevant mechanism to matching source.

## Test the Mechanism

Prefer observation that distinguishes alternatives before changing the process. A bounded reversible probe may confirm a prediction when the user's authorization covers its actual effect and environment. Use temporary counters or other existing controls rather than silently hot-patching application behavior. Runtime injection changes state and must not be described as read-only.

Compare the same trigger under controlled conditions and explain what changed or did not change. Account for probe/profiler overhead and separate instrumented diagnosis from reported performance timing using [Validate a Performance Claim](../../principles/performance-evidence.md). If a probe, symbol map, or target access is unavailable, return the supported observations and the unconfirmed mechanism explicitly.

Restore task-owned probes/configuration and verify the intended runtime state was restored. Remove disposable residue from failed capture attempts as well as the final run, while retaining proof. If restoration is unavailable, name the remaining change and its owner.

## Return the Diagnosis

Explain the symptom, captured signal, source attribution, mechanism, checked alternatives, and confidence with artifact pointers and exact observed results. A profile correlation alone does not prove a root cause. Identify the next discriminating check when needed.

Product fixes and source instrumentation requiring edits use [Code](../code/SKILL.md) within current authorization. Live diagnosis alone does not authorize product changes, deployment, destructive cleanup, or external messages. Do not commit or publish diagnostic artifacts unless requested.

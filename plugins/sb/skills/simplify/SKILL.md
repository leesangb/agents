---
name: simplify
description: Simplify working code and make names, types, and structure express its intent more precisely while preserving behavior. Use for a standalone simplification request or after implementation, before review or handoff.
---

# Simplify

Refine the current implementation within its accepted contract. The implementation writer applies justified changes directly; this pass does not require review orchestration. Honor a read-only request by returning candidates instead of editing.

## Scope and Baseline

Use the supplied target or the current task's edits and their affected callers. Read applicable local instructions and establish the behavior, constraints, and verification to preserve. Inspect nearby code as needed to understand the target; keep unrelated cleanup outside the pass. If no target can be recovered from the request or task context, ask for one.

Reuse current implementation evidence. For a standalone request, establish a baseline with relevant existing checks before editing. Resolve known behavior failures through the owning implementation workflow rather than treating them as simplification.

## Simplify and Clarify

Read [Simplicity and Coupling](../principle-simplicity-and-coupling/SKILL.md) and [Intent and Contracts](../principle-intent-and-contracts/SKILL.md). Use both lenses: remove unnecessary concepts, state, and indirection, and make the remaining representation say exactly what it means. Apply [TypeScript Best Practices](../typescript-best-practices/SKILL.md) when working with TypeScript.

For each candidate, identify the concrete burden or ambiguity in actual use, the smaller or more precise expression, and the evidence that behavior stays intact. Apply it only when the benefit outweighs added navigation, abstraction, or runtime cost. Fewer lines alone do not establish an improvement; keeping the current expression is a valid result.

Preserve observable behavior, public compatibility, failure handling, safeguards, and verification meaning. A rename must still describe the existing contract. Recover the reason for unclear defensive code before removing it using [Defensive History](../principle-defensive-history/SKILL.md). Leave candidates requiring a behavior, ownership, or scope change to the owning task for replanning; continue independent refinements within the accepted scope.

## Verify and Finish

Run affected checks after edits and inspect the final diff for behavior changes and stale names or explanations. Reuse still-valid evidence; a pass with no edits needs no repeat test run. Apply [Completion Evidence](../principle-completion-evidence/SKILL.md) before claiming preservation or completion.

Finish when the scoped candidates have been applied and verified or left unchanged for a concrete reason. Reopen only concerns affected by new edits or evidence. Hand the resulting implementation and verification back to the calling workflow; its required review still follows. Report what became simpler or more precise, the preservation evidence and any limits, or briefly state that no justified change was found.

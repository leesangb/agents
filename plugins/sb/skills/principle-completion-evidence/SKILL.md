---
name: principle-completion-evidence
description: "Before claiming completion, directly verify the final artifact or requested behavior and show the evidence supporting that claim."
---

# Completion Evidence

Use before reporting work complete, a behavior fixed, or a check passing. Limit each claim to what was actually verified in the final relevant state.

- Check the real artifact or behavior at the boundary the claim concerns. Compilation, a helper test, file presence, cached output, or a delegate's report proves only what it directly checks; none alone establishes that the requested user path works. Use the permitted environment and distinguish direct observation from inference.
- Run the checks needed for the requested guarantee and inspect their actual results. Recheck evidence invalidated by later changes. For a bug fix, compare the original failure with the corrected behavior on the same relevant path; label missing reproduction or runtime execution as unverified.
- Include concise, inspectable evidence in the completion response: what command or interaction ran, its actual result or decisive output, and what that establishes. Cite an artifact when useful. A bare "verified" or "tests pass" is insufficient; do not invent commands, results, or links. Keep evidence proportional to the claim rather than dumping logs.
- Failed, inconclusive, blocked, or unexecuted checks are not passes. State the limitation and narrow the completion claim; partial evidence cannot justify declaring the whole task done. Use [Behavioral Verification](../principle-behavioral-verification/SKILL.md) when the unresolved question is whether a test actually proves its promised behavior.

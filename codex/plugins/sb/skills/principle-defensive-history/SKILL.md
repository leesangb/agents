---
name: principle-defensive-history
description: "Recover the incident or contract behind unclear defensive code before removing it; missing rationale is not proof it is unnecessary."
---

# Recover the Contract Behind Defensive Code

Use before changing or removing a defensive path whose reason is unclear.

Anchor its relevant history with blame, patches through renames, tests, and linked decisions as available. Identify the behavior or incident it protects and whether the current contract still requires it; the newest edit alone does not establish the rationale. Carry the supported preservation constraints and risks into the handoff.

If no rationale is found, distinguish that gap from proof that the path is unnecessary. Widen to another evidence source only when the unresolved fact can change the decision.

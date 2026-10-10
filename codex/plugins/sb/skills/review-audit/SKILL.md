---
name: review-audit
description: Audit a fixed self-contained review packet for evidence support, consistency, completeness, and scope. Use only when sb:review selects a separate audit for a material dispute, high-impact judgment, or explicit rigorous-audit request.
---

# Review Audit

Apply the in-context contents of [Packet Audit Protocol](../review/references/packet-audit.md) for required inputs, verdicts, states, and responses. Main supplies this skill, that protocol, and [Finding Contract](../review/references/finding-contract.md) in full alongside the packet. If either reference content is absent from the supplied instructions, return `audit_status: UNRESOLVED` naming the missing guidance; do not fetch it.

Perform the packet-only assignment under that protocol's evidence-access and authority limits.

Return the protocol's overall state, finding ledger, coverage challenges, and exact correction or missing input/evidence needed from Main or the originating reviewer. Main handles evidence completion and final disposition.

# Packet Audit Protocol

Main and the auditor use this contract for a separate audit. Open one only for a material unresolved disagreement, a high-impact judgment warranting an independent evidence check, or an explicit rigorous-audit request. Main states the reason; ordinary reviews end with Main's validation.

## Prepare the Packet

Main supplies a self-contained packet with:

- one fixed envelope version and exact scope/artifact version, accepted contract, assumptions, and preservation constraints;
- the challenged/high-impact claims and any explicitly requested coverage, with their selected axes;
- stable finding/evidence IDs, original reviewer claims and material dissent, relevant source excerpts or exact observed outputs with provenance, and Main's additions attributed separately;
- prior audit/reviewer exchange for a subsequent pass.

Every included claim names the same envelope version. Include the evidence needed by [Finding Contract](finding-contract.md), with scoped-change relation only when a comparison baseline exists. Before spawning, Main reads `$sb:review-audit`, this protocol, and Finding Contract, then injects their full contents alongside the evidence packet into one fresh `sb-thinker` using `fork_turns: "none"`. File paths or links alone do not supply these instructions to a fresh thread. The auditor uses the supplied in-context rules and receives no repository access or tool task.

## Judge Only Supplied Evidence

The auditor calls no tools, reads no repository, runs no verification, edits nothing, and spawns no work. It evaluates support, consistency, completeness, and scope of supplied claims and declared coverage; it does not recover omitted evidence, discover findings, or decide final severity/disposition. Main or the originating reviewer owns additional evidence.

Apply the same evidence bar to findings, good-as-is conclusions, and no-findings coverage. Confidence, silence, and votes are not evidence. Judge contract relevance for every claim; for baseline-backed reviews also judge whether the scoped change introduced, worsened, or newly exposed it.

## Verdicts and Overall State

Apply these overall-state checks in order:

1. Conflicting envelope/artifact versions → `ENVELOPE_CHANGED`.
2. An absent required packet input above → `UNRESOLVED`, naming the field needed to begin adjudication.
3. With the required inputs present, any unsupported finding, inconsistent/incomplete claim evidence, or unsupported declared coverage → `DISAGREE`.
4. Every supplied finding and coverage conclusion supported and complete → `AGREE`.

For each supplied finding assign one verdict:

| Verdict | Meaning | Main's response |
| --- | --- | --- |
| `AGREE` | Supported, in scope, and materially complete. | Finalize disposition under the common evidence bar. |
| `DISAGREE_EVIDENCE` | A supplied evidence ID or contract field contradicts the claim. | Check the cited evidence; revise, support with new evidence, or drop the claim. |
| `DISAGREE_CONCERN` | Inputs are present but claim evidence is missing, ambiguous, or inconsistent. | Supply confirming/disconfirming evidence or drop the claim. |
| `OUT_OF_SCOPE` | Supplied metadata/evidence establishes irrelevance; for baseline-backed blockers this includes unchanged pre-existing/unrelated issues. | Establish eligible relation and relevance, reclassify as non-blocking context if useful, or drop it. |

The three non-AGREE finding verdicts produce overall `DISAGREE`. Input absence means that scope/version/contract, claims or declared coverage, the evidence bundle, or required prior exchange is absent. A present bundle with insufficient support for a claim is `DISAGREE_CONCERN`. Missing claim proof is distinct from an absent required packet input. `UNRESOLVED` requests packet repair, not agreement or automatic closure of the concern.

Return exactly one overall line, then the ledger and any declared-coverage challenges:

```text
audit_status: AGREE | DISAGREE | UNRESOLVED | ENVELOPE_CHANGED
finding_id | verdict | supplied evidence or epistemic objection | needed evidence or correction
```

## Resolve the Exchange

Main repairs required input/version problems and resubmits a coherent packet; when the needed input is unavailable, keep the affected review concern unresolved. For disagreements, Main or the originating reviewer investigates and sends affected claims plus relevant exchange with updated versions. Retain unaffected validated work.

Continue while new evidence or a correction can resolve the issue. Stop at convergence, repeated exchange without new evidence, unavailable evidence/authority, or changed authorized scope. An unresolved exchange yields Main's `review_status: unresolved`, distinct from the auditor's input-defect `UNRESOLVED`. Preserve material disagreement; Main cannot override an unresolved audit on unchanged evidence. Keep one non-recursive audit layer.

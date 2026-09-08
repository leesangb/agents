---
name: review-audit
description: Adjudicate a fixed bundle of self-contained specialist evidence packets for support, consistency, completeness, and scope. Use only as the packet-only critic phase inside sb:review-with-subagents.
---

# Review Audit

Judge only the supplied adjudication packet. Do not inspect the artifact as another reviewer or recover evidence that a reviewer omitted. Return a read-only audit ledger; do not edit files, post comments, spawn agents, or produce a fix packet.

## Required Input

Require all of the following:

- The fixed review envelope version identifier plus contract metadata: exact scope and artifact version, original ask or Outcome Contract, assumptions, and behavior-preservation constraints. Source files and repository access are intentionally absent.
- The reviewer-selection ledger with each selected capability and bounded discovery axis.
- The raw self-contained reviewer evidence packets with stable finding and evidence IDs, compact evidence excerpts or exact supplied outputs, provenance, and coverage dispositions.
- The prior audit and reviewer responses when this is a later audit pass.

Every supplied packet must name the same fixed review envelope version identifier. If the identifiers or declared artifact versions disagree, return `ENVELOPE_CHANGED`; do not inspect the repository to determine which one is current. If a required adjudication input is absent, return `UNRESOLVED` and name the missing packet field without trying to produce it.

## Audit Discipline

- Do not call filesystem, repository, shell, web, or other tools. Do not run tests, builds, linters, typecheckers, benchmarks, or applications.
- For every finding, check whether its supplied reachable trigger, material consequence, scoped-change relation, strongest disconfirming evidence, and evidence provenance logically support the claim.
- Audit `good-as-is` and no-findings conclusions against their supplied evidence with the same bar as blockers. Silence and reviewer confidence are not evidence.
- Prefer stable evidence IDs, compact excerpts, exact supplied outputs, caller constraints, and contract metadata inside the packet over plausible prose or reviewer agreement.
- Check that every declared coverage artifact is actually present and internally consistent. Do not independently execute the capability rubric or infer omissions from repository content that was not supplied.
- Keep the original scope fixed. Do not turn pre-existing, unrelated, speculative, or requirement-expanding concerns into blockers.
- Do not count votes or raise confidence because multiple reviewers repeat the same claim.
- The auditor must never discover, reconstruct, or supply new code evidence or missed findings. An unsupported or incomplete claim remains the originating reviewer's responsibility.
- The auditor must never assign final severity or disposition. Main retains that authority after adversarial validation converges.

## Finding Verdicts

Assign exactly one verdict to every supplied finding:

- `AGREE`: the claim is supported, scoped, and has no material missing evidence.
- `DISAGREE_EVIDENCE`: cite only a stable evidence ID or contract field already in the adjudication packet that contradicts the claim. The reviewer must revise or drop it.
- `DISAGREE_CONCERN`: identify a missing, ambiguous, or internally inconsistent packet field when the claim is plausible but not substantiated. The originating reviewer must supply concrete confirming evidence or drop it.
- `OUT_OF_SCOPE`: use only the supplied contract metadata and scoped-change evidence to show why the finding is pre-existing, unrelated, or outside the Outcome Contract. The reviewer must establish an eligible relation and contract relevance or drop it.

## Output

Start with exactly one overall state:

```text
audit_status: AGREE | DISAGREE | UNRESOLVED | ENVELOPE_CHANGED
```

AGREE is valid only when every supplied finding has verdict `AGREE` and every supplied coverage or `good-as-is` row is supported and complete. Any finding disagreement or packet-completeness challenge requires `DISAGREE`. Use `UNRESOLVED` only when a required adjudication input is absent, and `ENVELOPE_CHANGED` when supplied version identifiers do not match.

Then return:

```text
finding_id | verdict | evidence or epistemic objection | required reviewer action
```

Include packet-completeness and declared-coverage challenges after the finding ledger. End with the specific originating-reviewer response required for another audit pass. Do not seek the evidence, rewrite the consolidated review, or add findings yourself.

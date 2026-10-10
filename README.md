# agents

Portable agent workflows and capability bundles for multiple coding-agent runtimes.

The repository currently contains the Codex distribution of the `sb` plugin. Other runtimes can live beside `codex/` without sharing runtime-specific packaging.

## Codex

`codex/plugins/sb` packages composable code-change workflows around Codex's built-in execution roles plus one materially distinct custom profile:

- built-in `worker`: default delegated implementation role
- built-in `explorer`: default delegated investigation role
- `sb-thinker`: Astra xhigh with read-only access

`$sb:code` is the main entry point for routing executable changes through Fast, Deep, Ultra, or PoC workflows. Main dynamically owns orchestration: it decides when to work directly, delegate bounded investigation or implementation, use the read-only thinker for planning or review, wait, follow up, and converge. Deep and Ultra retain explicit plan approval and evidence-gated review. `$sb:review` is the single entry point for reviewing code, PRs, implementations, plans, and designs. It owns reviewer selection and coordination; Main validates findings, with an independent audit reserved for material disagreements, high-impact judgments, or an explicit request for strict review. The remaining skills provide distinct workflows or execution capabilities.

Fast shows a brief plan before editing: the change, implementation approach, and completion check. Clear implementation requests then proceed without another approval; Deep and Ultra present their complete plans for explicit approval.

Judgment criteria live in [Shared Principles](codex/plugins/sb/principles/index.md). Code routing, investigation, planning, implementation, and review select applicable files from this index. A general code or PR review covers behavior and relevant design principles by default; independent reviewer selection does not limit Main's coverage. Independent reviewers receive the selected principles and the common finding contract; Main coordinates and validates their results. Invoke `$sb:review` for the current diff or a specified scope, optionally emphasizing a principle such as caller obligations or behavioral verification.

For an API-boundary review, invoke `$sb:review` with the target interface and caller concern. [Caller Obligations](codex/plugins/sb/principles/caller-obligations.md) owns caller ceremony and builtin alternatives; [Deep Modules](codex/plugins/sb/principles/deep-modules.md), [Responsibility and Change](codex/plugins/sb/principles/responsibility-and-change.md), and [Intent and Contracts](codex/plugins/sb/principles/intent-and-contracts.md) cover depth, leaked knowledge, and conceptual meaning when those questions arise. These criteria also apply during planning and implementation.

[Composition and Mechanisms](codex/plugins/sb/principles/composition-and-mechanisms.md) guides feature assembly and independent mechanism ownership; [Deep Modules](codex/plugins/sb/principles/deep-modules.md) guides interface depth and locality. Detailed criteria have one owning file. Start from its question in the index and follow a related link only when an actual unanswered question needs it; design foundations provide priority and navigation for broader tradeoffs. Structural explanation remains a code-workflow reference.

Review evidence, candidate disposition, and explanation follow the shared [Finding Contract](codex/plugins/sb/skills/review/references/finding-contract.md). Its [recipient-facing explanation rules](codex/plugins/sb/skills/review/references/finding-contract.md#explain-findings-for-the-recipient) apply to both specialist drafts and the consolidated review.

### Verification, diagnosis, and learning

| Capability | Use |
| --- | --- |
| `$sb:create-verification-skill` | Create project-local launch, doctor, drive, evidence, and cleanup instructions with a feature map; prove one real user path before handing them over. |
| `$sb:maintain-verification-skill` | Audit an existing map against source and live behavior, repairing verification instructions and owned harnesses while reporting product defects separately. |
| `$sb:correct` | Prevent demonstrated recurring mistakes through scoped ownership, types, or executable checks, with proof that the mechanism rejects the bad case. |
| `$sb:reflect` | Propose durable improvements from a scoped session, distinguishing missing guidance, missed selection, execution errors, and structurally preventable patterns. |
| `$sb:recall` | Recover scoped prior decisions, failed approaches, and work status across sessions, then reconcile them with current source and available live records. |
| `$sb:trace-forensics` | Diagnose an existing profile, heap snapshot, or trace, preserving the capture and separating observations from causal inference. |
| `$sb:runtime-forensics` | Capture the reported behavior on the running target, analyze its evidence, and test a mechanism with authorized bounded probes. |
| `$sb:hillclimb` | Improve one fixed metric through bounded hypotheses, comparable measurements, correctness gates, and keep-or-revert decisions within the code workflow. |

Shared judgment criteria live in [principles/index.md](codex/plugins/sb/principles/index.md). Each code/review entry point consults the index for the accepted task and relevant source or proposed use case. The active workflow retains approval, writer/reviewer roles, execution, and reporting. Read a principle before applying or citing it, and explain the material choice it changes rather than only naming it. These are reference documents, not separate skill entry points. A code task uses their criteria while choosing the implementation; an independent reviewer uses the same criteria to challenge it.

The collection covers [design foundations](codex/plugins/sb/principles/design-foundations.md), [independent shared-state decisions](codex/plugins/sb/principles/separate-shared-state.md), [verifiable units](codex/plugins/sb/principles/verifiable-units.md), [re-execution safety](codex/plugins/sb/principles/reexecution-safety.md), [defensive-code history](codex/plugins/sb/principles/defensive-history.md), [challenging failed premises](codex/plugins/sb/principles/challenge-shared-premise.md), [performance evidence](codex/plugins/sb/principles/performance-evidence.md), [structural enforcement](codex/plugins/sb/principles/encode-lessons-in-structure.md), and a conditional [decision trail](codex/plugins/sb/principles/decision-trail.md).

### Install or update

```sh
cd codex
./install
```

The command registers this repository as a local Codex marketplace when needed, installs or refreshes `sb@agents`, updates `sb-thinker`, and safely retires only proven SB-managed copies of the deprecated `sb-worker` and `sb-explorer` profiles. Start a new Codex session after installation so the refreshed plugin and profile are loaded.

Verify the installed plugin and profiles with:

```sh
cd codex
./install --check
```

The installer preserves user-edited agent profiles by comparing them with SHA-256 hashes recorded under `$CODEX_HOME/sb/state/`. It refuses to overwrite `sb-thinker` when it differs from the last SB-installed version, and preserves deprecated profiles unless their ownership is proven by prior install state or a matching legacy snapshot.

## Layout

```text
codex/
├── .agents/plugins/marketplace.json  # local marketplace
├── install                            # install, update, and verification entry point
└── plugins/sb/
    ├── .codex-plugin/plugin.json      # plugin manifest
    ├── assets/agents/                 # read-only sb-thinker profile
    ├── principles/                    # shared planning/implementation/review criteria
    ├── scripts/install-agents         # profile installer and conflict protection
    └── skills/                         # workflow and capability skills
```

## Third-Party Attribution

The verification, history, diagnosis, optimization, and learning skills
(create-verification-skill, maintain-verification-skill, correct, reflect, recall,
trace-forensics, runtime-forensics, and hillclimb) and portions of the shared
principles collection are adapted from pstack by Lauren Tan:
https://github.com/cursor/plugins/tree/main/pstack

The original license for those portions follows. This notice does not relicense
unrelated SB files.

MIT License

Copyright (c) 2026 Lauren Tan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

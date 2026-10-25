# agents

Portable agent workflows and capability bundles for multiple coding-agent runtimes.

The `sb` plugin has one source in `plugins/sb` and installs into both Codex and Claude Code. Skills, principles, and references are shared; each runtime adds only its own manifest and agent profile.

## One source, two runtimes

Skill text names roles and linked skills without runtime syntax. [Runtime Roles](plugins/sb/roles.md) is the only place that maps them to a runtime:

| Role | Codex | Claude Code |
| --- | --- | --- |
| `explorer` | built-in `explorer` | built-in `Explore` agent |
| `thinker` | `sb-thinker`: Astra xhigh with read-only access | `sb:thinker`: Opus xhigh without edit tools |
| `worker` | built-in `worker` | built-in `general-purpose` agent |

Skills are invoked as `$sb:<name>` in Codex and `/sb:<name>` in Claude Code; the sections below use the Codex form. When changing a skill, keep runtime names out of it and extend Runtime Roles instead. The thinker instructions are the one text stored per runtime format, and `plugins/sb/tests/thinker-parity.test.sh` fails when the two copies diverge.

## Workflows

`$sb:code` is the main entry point for routing executable changes through Fast, Deep, Ultra, or PoC workflows. Main owns orchestration and chooses useful investigation, planning, implementation, and review roles. Deep and Ultra retain deeper investigation and evidence-gated review while authorization is judged separately. `$sb:review` is the single entry point for reviewing code, PRs, implementations, plans, and designs. Main selects reviewers and validates their findings, with an independent audit reserved for material disagreements, high-impact judgments, or an explicit request for strict review.

Production workflows share [Planning and Resuming](plugins/sb/skills/code/references/planning.md) for plans, authority, and completion. Before editing, show the change, approach, and completion checks using agreed context: Fast can use one sentence; Deep and Ultra explain consequential facts and choices without fixed headings. For new behavior or changed interfaces, ownership, or wiring, first sketch the [caller-first outline](plugins/sb/skills/code/references/implementation-outline.md): the consuming caller's goal and representative call, feature composition, and the owners of mechanics and effects. Continue a clear implementation request within its authorized scope and effects; planning-only requests return a plan. Read Decision Dialogue only for unresolved prerequisites in delegated planning or consequential choices that evidence and reasonable defaults cannot settle. Higher rigor does not add an approval round. External messages and production effects still require their actual grants.

Judgment criteria live in independently discoverable `principle-*` skills, with [Shared Principles](plugins/sb/principles/index.md) as their navigation index. Skill descriptions expose the trigger and core rule; the full body is read when selected. They are not all permanently loaded, and an initial skill-list budget can shorten descriptions or omit entries. Code routing, investigation, planning, implementation, and review use the same canonical criteria. Code completion requires explaining consequential choices through the principles actually applied, source/caller evidence, resulting responsibilities or behavior, and verification; reconcile the result with that intent before claiming completion. A general review covers behavior and relevant design principles by default; independent reviewer selection does not limit Main's coverage. Invoke `$sb:review` for the current diff or a specified scope, optionally emphasizing a principle such as caller obligations or behavioral verification.

For an API-boundary review, invoke `$sb:review` with the target interface and caller concern. [Caller Obligations](plugins/sb/skills/principle-caller-obligations/SKILL.md) owns caller ceremony and builtin alternatives; [Deep Modules](plugins/sb/skills/principle-deep-modules/SKILL.md), [Responsibility and Change](plugins/sb/skills/principle-responsibility-and-change/SKILL.md), and [Intent and Contracts](plugins/sb/skills/principle-intent-and-contracts/SKILL.md) cover depth, leaked knowledge, and conceptual meaning when those questions arise. These criteria also apply during planning and implementation.

Failure diagnosis and review of existing causal explanations apply [Root-Cause Repair](plugins/sb/skills/principle-root-cause-repair/SKILL.md), even without a code-change request. Validate the failed precondition and its owner, trace the first broken guarantee, and close directly checkable evidence gaps within the investigation's permitted scope. For bug fixes, do this before proposing a repair or selecting Fast; choose a correction that restores the guarantee at its owner. Minimal scope follows diagnosis; it does not replace it. Investigation does not authorize edits.

Before claiming completion, apply [Completion Evidence](plugins/sb/skills/principle-completion-evidence/SKILL.md): verify the relevant final artifact or behavior directly, then show the actual check or interaction, observed result, and what it proves. Proxy checks and unexecuted or inconclusive verification cannot establish that the requested behavior works.

[Composition and Mechanisms](plugins/sb/skills/principle-composition-and-mechanisms/SKILL.md) guides feature assembly and independent mechanism ownership; [Deep Modules](plugins/sb/skills/principle-deep-modules/SKILL.md) guides interface depth and locality. Detailed criteria have one owning file. Start from its question in the index and follow a related link only when an actual unanswered question needs it; design foundations provide priority and navigation for broader tradeoffs. Structural explanation remains a code-workflow reference.

Review evidence, candidate disposition, and explanation follow the shared [Finding Contract](plugins/sb/skills/review/references/finding-contract.md). Its [recipient-facing explanation rules](plugins/sb/skills/review/references/finding-contract.md#explain-findings-for-the-recipient) apply to both specialist drafts and the consolidated review. Final reviews show behavioral findings and accepted design improvements, with decisive reasoning and a small current-to-proposed call tree, code diff, or state/data-flow sketch for each design improvement. Good-as-is and unresolved judgments remain internal unless requested, needed to answer an explicit concern, or consequential to a finding or recommendation. When independent source reviewers participated and the final review needs design improvements or other requested/consequential design conclusions, a fresh agent checks the draft for lost reasons, sketches, alternatives, and uncertainty. Main repairs supported gaps and returns the checked text without another summary; this explanation check does not replace the conditional evidence audit.

### Explanation, writing, and parallel investigation

| Capability | Use |
| --- | --- |
| `$sb:how` | Explain actual runtime flow, concepts, ownership, and layering at the depth the question needs. |
| `$sb:why` | Reconstruct design rationale from relevant history and decision records, distinguishing recorded intent from inference and gaps. |
| `$sb:restate` | Restate the user's goals and underlying problem in your own words to check shared understanding, making material assumptions explicit. |
| `$sb:blast-radius` | Identify what can break beyond the diff and connect source investigation to a distinguishing check of the key safety assumption. |
| `$sb:swarm` | Coordinate useful independent investigation slices or candidate comparisons, preserving the selected workflow and one production writer. |
| `$sb:unslop` | Remove vague claims, filler, jargon, and excessive compression without changing meaning or evidence. |
| `$sb:technical-writing` | Structure docs, RFCs, procedures, and PR descriptions around the reader's task, conditions, and observable results. |
| `$sb:bro` | Explicitly request a simpler restatement of the previous answer while preserving consequential caveats. |

`how` and `why` explain rather than modify code. `blast-radius` reuses `analyze` for source investigation and leaves execution to Main within the authorized environment. `swarm` uses the runtime's roles and scoped evidence instead of a fixed cloud-worker or model roster; Fast and PoC code workflows remain direct paths. These capabilities do not add mandatory phases to every task.

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

Each principle has one canonical `skills/principle-*/SKILL.md` body. Select a criterion directly or through [principles/index.md](plugins/sb/principles/index.md), read it before applying its details, and explain the material choice it changes. For example, invoke `$sb:principle-separate-shared-state` when deciding whether actors need one write target, or `$sb:principle-experience-first` when implementation convenience competes with the user's core experience. Invoking a principle supplies judgment criteria; it does not authorize edits, external effects, or a new execution workflow.

The collection includes [experience first](plugins/sb/skills/principle-experience-first/SKILL.md), [design foundations](plugins/sb/skills/principle-design-foundations/SKILL.md), [independent shared-state decisions](plugins/sb/skills/principle-separate-shared-state/SKILL.md), [verifiable units](plugins/sb/skills/principle-verifiable-units/SKILL.md), [re-execution safety](plugins/sb/skills/principle-reexecution-safety/SKILL.md), [defensive-code history](plugins/sb/skills/principle-defensive-history/SKILL.md), [challenging failed premises](plugins/sb/skills/principle-challenge-shared-premise/SKILL.md), [performance and evaluation evidence](plugins/sb/skills/principle-performance-evidence/SKILL.md), [reproducible tooling](plugins/sb/skills/principle-build-the-lever/SKILL.md), [structural enforcement](plugins/sb/skills/principle-encode-lessons-in-structure/SKILL.md), and a conditional [decision trail](plugins/sb/skills/principle-decision-trail/SKILL.md). [Simplicity and Coupling](plugins/sb/skills/principle-simplicity-and-coupling/SKILL.md) considers both reader navigation and hidden mutable context, preferring derived values to synchronized copies while preserving meaningful snapshots, drafts, and caches. [Deep planning](plugins/sb/skills/code/references/deep.md) compares small alternative sketches or authorized prototypes when a novel design remains uncertain; it does not require multiple prototypes for established patterns.

### Install or update

```sh
./install codex
./install claude
```

For Codex, the command registers this repository as a local marketplace when needed, moving a registration left at the former `codex/` root; installs or refreshes `sb@agents`; updates `sb-thinker`; and safely retires only proven SB-managed copies of the deprecated `sb-worker` and `sb-explorer` profiles. Codex installs a copy, so rerun it after changing the plugin and start a new Codex session.

For Claude Code, the command registers the same repository as a local marketplace and installs `sb@agents`. Claude Code reads the plugin from this folder, so edits load at the next session start or `/reload-plugins` without reinstalling.

Verify either installation with:

```sh
./install codex --check
./install claude --check
```

The Codex installer preserves user-edited agent profiles by comparing them with SHA-256 hashes recorded under `$CODEX_HOME/sb/state/`. It refuses to overwrite `sb-thinker` when it differs from the last SB-installed version, and preserves deprecated profiles unless their ownership is proven by prior install state or a matching legacy snapshot.

## Layout

```text
.agents/plugins/marketplace.json   # Codex local marketplace
.claude-plugin/marketplace.json    # Claude Code local marketplace
install                            # install, update, and verification entry point
plugins/sb/
├── .codex-plugin/plugin.json      # Codex manifest
├── .claude-plugin/plugin.json     # Claude Code manifest
├── agents/thinker.md              # Claude Code thinker agent
├── assets/agents/                 # Codex sb-thinker profile
├── roles.md                       # role and invocation mapping per runtime
├── principles/index.md            # navigation to canonical criterion skills
├── scripts/install-agents         # Codex profile installer and conflict protection
├── tests/                         # installer and thinker parity checks
└── skills/                        # shared workflows, capabilities, and principle-* skills
```

## Third-Party Attribution

The verification, history, diagnosis, optimization, learning, explanation,
parallel investigation, and writing skills
(create-verification-skill, maintain-verification-skill, correct, reflect, recall,
trace-forensics, runtime-forensics, hillclimb, how, why, blast-radius, swarm,
unslop, technical-writing, bro, and restate) and portions of the shared
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

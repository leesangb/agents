#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
router="$repo_root/codex/plugins/sb/skills/code/SKILL.md"
deep="$repo_root/codex/plugins/sb/skills/code/references/deep.md"
ultra="$repo_root/codex/plugins/sb/skills/code/references/ultra.md"
architecture_plan="$repo_root/codex/plugins/sb/skills/architecture-plan/SKILL.md"
implement="$repo_root/codex/plugins/sb/skills/implement/SKILL.md"
review="$repo_root/codex/plugins/sb/skills/review-with-subagents/SKILL.md"
code_review="$repo_root/codex/plugins/sb/skills/code-review/SKILL.md"
api_review="$repo_root/codex/plugins/sb/skills/api-review/SKILL.md"
manifest="$repo_root/codex/plugins/sb/.codex-plugin/plugin.json"

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

grep -Fq 'Main dynamically owns orchestration' "$router" || fail 'router does not give Main dynamic orchestration ownership'
grep -Fq 'built-in `explorer` and `worker`' "$router" || fail 'router does not make built-in execution roles the default'
grep -Fq 'only custom execution profile is `sb-thinker`' "$router" || fail 'router does not retain thinker as the only custom profile'

for workflow in "$deep" "$ultra"; do
  grep -Fq 'Main decides whether to work directly or delegate' "$workflow" || fail "Main cannot choose direct or delegated work in $workflow"
  grep -Fq 'built-in `explorer`' "$workflow" || fail "built-in explorer is not the default investigation role in $workflow"
  grep -Fq 'built-in `worker`' "$workflow" || fail "built-in worker is not the default writing role in $workflow"
  grep -Fq 'review-with-subagents' "$workflow" || fail "review selection is not delegated in $workflow"
  if rg -q 'Spawn only fresh thinkers|Give every reviewer|maximum (two|three) reviews|capability \| trigger evidence \| review question' "$workflow"; then
    fail "reviewer spawn or selection choreography is duplicated in $workflow"
  fi
done

grep -Fq 'The caller decides whether to invoke this planner' "$architecture_plan" || fail 'architecture-plan assumes mandatory planner delegation'
grep -Fq 'The caller may implement directly or delegate to a built-in `worker`' "$implement" || fail 'implement assumes a custom worker handoff'
grep -Fq 'single source of truth for reviewer selection, spawning, waiting, and aggregation' "$review" || fail 'review orchestration is not centralized'
grep -Fq 'built-in `explorer`' "$review" || fail 'review skill does not use the built-in explorer'
grep -Fq 'built-in `worker`' "$review" || fail 'review skill does not use the built-in worker'

grep -Fq 'Main owns final severity and disposition' "$review" || fail 'Main does not own the final review verdict'
grep -Fq '`introduced`, `worsened`, `newly_exposed`, `pre_existing`, `unrelated`, or `unknown`' "$review" || fail 'review aggregation lacks scoped-change causality'
grep -Fq 'strongest available disconfirming evidence checked' "$review" || fail 'review aggregation does not require falsification'
grep -Fq 'Reviewer count is not evidence provenance' "$review" || fail 'correlated reviewer agreement can inflate confidence'
grep -Fq 'Do not pair it automatically with `api-review`' "$review" || fail 'API and architecture review are coupled without independent questions'
grep -Fq 'module depth as experienced through caller leverage' "$review" || fail 'API review does not own caller-facing module depth'
grep -Fq 'caller-pain-independent question of mechanism placement, cohesion, structural depth, and dependency direction' "$review" || fail 'architecture review does not own independent structural depth'

grep -Fq 'Return candidate findings ordered by provisional severity' "$code_review" || fail 'code-review still owns final severity'
grep -Fq 'compare the candidate with the baseline' "$code_review" || fail 'code-review does not compare diff findings with the baseline'
grep -Fq 'strongest available normal-behavior explanation' "$code_review" || fail 'code-review does not check disconfirming evidence'

grep -Fq 'caller goal | caller-owned policy | module-owned mechanics | leaked implementation knowledge | builtin alternative' "$api_review" || fail 'api-review lacks a caller-obligation ledger'
grep -Fq 'For each materially distinct caller pattern' "$api_review" || fail 'api-review expands equivalent call sites into duplicate ledger entries'
grep -Fq 'Group equivalent call sites' "$api_review" || fail 'api-review does not group repeated caller obligations'
grep -Fq 'Judge module depth by caller leverage' "$api_review" || fail 'api-review does not assess deep interfaces from the caller'
grep -Fq 'internal IDs, wrappers, callback wiring, provider configuration' "$api_review" || fail 'api-review does not detect leaked implementation mechanics'
grep -Fq 'legitimate caller decision' "$api_review" || fail 'api-review can mistake requirement policy for caller burden'
grep -Fq 'Defer a distinct ownership or dependency-direction question' "$api_review" || fail 'api-review does not separate caller burden from structural placement'

if rg -q 'sb-worker|sb-explorer' "$manifest"; then
  fail 'plugin manifest still claims deprecated custom profiles'
fi

printf '%s\n' 'workflow-orchestration tests passed'

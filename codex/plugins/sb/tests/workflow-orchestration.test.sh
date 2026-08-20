#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
router="$repo_root/codex/plugins/sb/skills/code/SKILL.md"
deep="$repo_root/codex/plugins/sb/skills/code/references/deep.md"
ultra="$repo_root/codex/plugins/sb/skills/code/references/ultra.md"
architecture_plan="$repo_root/codex/plugins/sb/skills/architecture-plan/SKILL.md"
implement="$repo_root/codex/plugins/sb/skills/implement/SKILL.md"
review="$repo_root/codex/plugins/sb/skills/review-with-subagents/SKILL.md"
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

if rg -q 'sb-worker|sb-explorer' "$manifest"; then
  fail 'plugin manifest still claims deprecated custom profiles'
fi

printf '%s\n' 'workflow-orchestration tests passed'

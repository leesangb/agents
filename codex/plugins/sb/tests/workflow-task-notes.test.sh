#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
deep="$repo_root/codex/plugins/sb/skills/code/references/deep.md"
ultra="$repo_root/codex/plugins/sb/skills/code/references/ultra.md"
implement="$repo_root/codex/plugins/sb/skills/implement/SKILL.md"
review="$repo_root/codex/plugins/sb/skills/review-with-subagents/SKILL.md"
router="$repo_root/codex/plugins/sb/skills/code/SKILL.md"
fast="$repo_root/codex/plugins/sb/skills/code/references/fast.md"
poc="$repo_root/codex/plugins/sb/skills/code/references/poc.md"
reference="$repo_root/codex/plugins/sb/skills/code/references/task-notes.md"

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

for workflow in "$deep" "$ultra"; do
  grep -Fq 'sb-notes init' "$workflow" || fail "missing Main init handoff in $workflow"
  grep -Fq 'resolve --task-path <exact-task-path>' "$workflow" || fail "missing exact-path resume in $workflow"
  grep -Fq 'task_path' "$workflow" || fail "missing exact task path in $workflow"
  grep -Fq 'state_path' "$workflow" || fail "missing exact state path in $workflow"
  grep -Fq 'fix, review, resume' "$workflow" || fail "missing fixed-path fix/review/resume handoff in $workflow"
  grep -Fq 'worker' "$workflow" || fail "missing worker path handoff in $workflow"
  grep -Fq 'report' "$workflow" || fail "missing fixed-path reporting handoff in $workflow"
  grep -Fq 'legacy repository singleton' "$workflow" || fail "missing singleton guard in $workflow"
done

grep -Fq 'caller-provided absolute `task_path` and `state_path`' "$implement" || fail 'implement does not require caller paths'
grep -Fq 'read-state --task-path' "$implement" || fail 'implement does not default to state-only read'
grep -Fq 'replace-state --task-path' "$implement" || fail 'implement does not require atomic state replacement'
grep -Fq -- '--expected-hash <read-state-sha256>' "$implement" || fail 'implement does not require compare-and-swap state replacement'
grep -Fq 'checkpoint --task-path' "$implement" || fail 'implement does not require typed checkpoints'
grep -Fq 'state_path' "$review" || fail 'reviewers do not receive exact state path'
grep -Fq 'never rederive or mutate the store' "$review" || fail 'reviewers are not constrained to read-only task state'
grep -Fq 'Fast and PoC do not use task state' "$router" || fail 'router does not preserve Fast and PoC semantics'
grep -Fq 'Current code, Git state, tests, runtime evidence, and user direction outrank every note.' "$reference" || fail 'live evidence priority is missing'
grep -Fq 'resolve` validates the complete store' "$reference" || fail 'resume does not validate complete task state'
grep -Fq 'same exact paths for fix packets, review, resume, and final reporting' "$reference" || fail 'task path propagation is incomplete'
grep -Fq 'without a generated hash' "$reference" || fail 'task notes still describe hashed repository keys'
grep -Fq 'immutable `.md` files' "$reference" || fail 'task notes do not require Markdown checkpoints'
grep -Fq 'migrate-layout --dry-run' "$reference" || fail 'task notes do not document safe layout migration'
grep -Fq 'old_task_path' "$reference" || fail 'task notes do not require emitted migration path mappings'
grep -Fq 'layout-coordination lock' "$reference" || fail 'task notes do not document migration quiescence'
grep -Fq 'owner PID is confirmed no longer alive' "$reference" || fail 'task notes do not document safe stale layout-lock recovery'
grep -Fq 'atomically published by hard link' "$reference" || fail 'task notes do not document atomic layout-lock publication'
grep -Fq 'unique-owner-token' "$reference" || fail 'task notes do not document ownership-aware layout-lock release'
grep -Fq 'exclusive `.reclaim` election' "$reference" || fail 'task notes do not document exclusive stale-reclaimer election'
grep -Fq 'does not claim `fsync`-durability' "$reference" || fail 'task notes do not document the filesystem durability residual'
if rg -q 'init --task-path' "$deep" "$ultra" "$implement" "$reference"; then
  fail 'workflow still exposes duplicate init resume operation'
fi

if rg -q 'implementation-notes\.local\.md' "$fast" "$poc"; then
  fail 'Fast or PoC unexpectedly uses task notes'
fi

printf '%s\n' 'workflow-task-notes tests passed'

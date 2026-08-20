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

grep -Fq 'only when the work is expected to cross sessions or durable resume is explicitly needed' "$router" || fail 'router does not make durable notes conditional'
grep -Fq 'Fast and PoC do not use task state' "$router" || fail 'router does not preserve Fast and PoC semantics'

for workflow in "$deep" "$ultra"; do
  grep -Fq 'Activate durable task notes only when work is expected to cross sessions or explicitly needs durable resume.' "$workflow" || fail "notes activation is not conditional in $workflow"
  grep -Fq 'When inactive, it performs no task-state operations.' "$workflow" || fail "inactive notes behavior is missing in $workflow"
  grep -Fq 'sb-notes init' "$workflow" || fail "active notes init is missing in $workflow"
  grep -Fq 'resolve --task-path <exact-task-path>' "$workflow" || fail "exact-path resume is missing in $workflow"
  grep -Fq 'task_path' "$workflow" || fail "exact task path is missing in $workflow"
  grep -Fq 'state_path' "$workflow" || fail "exact state path is missing in $workflow"
  grep -Fq 'every fix, review, resume' "$workflow" || fail "fixed-path propagation is incomplete in $workflow"
  grep -Fq 'legacy repository singleton' "$workflow" || fail "singleton guard is missing in $workflow"
done

grep -Fq 'When active, require the caller-provided absolute `task_path` and `state_path`' "$implement" || fail 'implement does not require caller paths when notes are active'
grep -Fq 'When inactive, do not initialize or derive a store' "$implement" || fail 'implement does not support inactive notes'
grep -Fq 'read-state --task-path' "$implement" || fail 'implement does not read the active state baseline'
grep -Fq 'replace-state --task-path' "$implement" || fail 'implement does not require atomic state replacement'
grep -Fq -- '--expected-hash <read-state-sha256>' "$implement" || fail 'implement does not require compare-and-swap replacement'
grep -Fq 'checkpoint --task-path' "$implement" || fail 'implement does not require typed checkpoints'
grep -Fq 'state_path' "$review" || fail 'reviewers do not receive exact active state paths'
grep -Fq 'never rederive or mutate the store' "$review" || fail 'reviewers are not constrained to read-only task state'

grep -Fq 'optional durable local state mechanism' "$reference" || fail 'task notes reference still makes notes mandatory'
grep -Fq 'When inactive, do not initialize or derive a store.' "$reference" || fail 'task notes reference lacks inactive behavior'
grep -Fq 'Current code, Git state, tests, runtime evidence, and user direction outrank every note.' "$reference" || fail 'live evidence priority is missing'
grep -Fq 'resolve` validates the complete store' "$reference" || fail 'resume does not validate complete task state'
grep -Fq 'same exact paths for fix packets, review, resume, and final reporting' "$reference" || fail 'active task path propagation is incomplete'
grep -Fq 'without a generated hash' "$reference" || fail 'task notes still describe hashed repository keys'
grep -Fq 'immutable `.md` files' "$reference" || fail 'task notes do not require Markdown checkpoints'
grep -Fq 'migrate-layout --dry-run' "$reference" || fail 'task notes do not document safe layout migration'
grep -Fq 'old_task_path' "$reference" || fail 'task notes do not require emitted migration mappings'
grep -Fq 'layout-coordination lock' "$reference" || fail 'task notes do not document migration quiescence'
grep -Fq 'owner PID is confirmed no longer alive' "$reference" || fail 'task notes do not document safe stale-lock recovery'
grep -Fq 'atomically published by hard link' "$reference" || fail 'task notes do not document atomic lock publication'
grep -Fq 'unique-owner-token' "$reference" || fail 'task notes do not document ownership-aware release'
grep -Fq 'exclusive `.reclaim` election' "$reference" || fail 'task notes do not document stale-reclaimer election'
grep -Fq 'does not claim `fsync`-durability' "$reference" || fail 'task notes do not document the durability residual'

if rg -q 'init --task-path' "$deep" "$ultra" "$implement" "$reference"; then fail 'workflow exposes duplicate init resume operation'; fi
if rg -q 'implementation-notes\.local\.md' "$fast" "$poc"; then fail 'Fast or PoC unexpectedly uses task notes'; fi

printf '%s\n' 'workflow-task-notes tests passed'

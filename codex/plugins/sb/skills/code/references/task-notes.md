# Repository- and Task-Scoped Notes

Deep and Ultra implementation notes belong to one repository, branch, and canonical task. They are durable local state, not a repository file and never a replacement for current code, Git, or test evidence.

## Ownership and Handoff

- **Main** initializes a new store once, after plan approval, with `${CODEX_HOME:-$HOME/.codex}/bin/sb-notes init`; a later session resumes only through `sb-notes resolve --task-path <exact-task-path>`. Both return the same two absolute fields, `task_path` and `state_path`, which Main passes unchanged to the worker and every reviewer.
- **Worker** receives those exact paths. It reads only `state.md` by default, compares it with live code/Git/tests, records that state's SHA-256, replaces it through compare-and-swap `sb-notes replace-state --expected-hash <sha256>`, and appends its own typed checkpoint through `sb-notes checkpoint`.
- **Reviewers** are read-only. They receive `state_path` and only explicitly relevant checkpoint or artifact paths; they never derive a task location or load history by default.
- **Main** uses the same exact paths for fix packets, review, resume, and final reporting. `resolve` validates the complete store; it must not rederive identity from its current directory.

## Store Contract

`sb-notes init` creates this private hierarchy:

```text
${SB_NOTES_ROOT:-$HOME/.notes}/<repo-key>/<created-yymmdd>/<branch-key>/<task-key>/
```

The helper owns safe component construction and validates the Git worktree. `repo-key` is the readable normalized origin owner/repository without a generated hash, so equivalent protocol or SSH-alias forms converge; raw origin identity stays in metadata. Without `origin`, it is the readable repository basename, while the canonical `git rev-parse --git-common-dir` remains the identity: linked worktrees converge, and an existing clean root with a different common directory fails before a task is created. Origin canonical `owner/repo` is authoritative for clean-root reuse. `branch-key` is a readable branch slug plus hash, or `detached-<short-sha>`. Explicit task IDs become readable hashed keys; an omitted task ID becomes a collision-checked local timestamp key. An explicit task ID searches all created-date directories for its repo/branch/task key: exactly one valid match resumes it, multiple matches fail with candidate paths, and an incomplete match fails rather than becoming a new task. The current worktree path is provenance only, never repository identity.

`sb-notes migrate-layout --dry-run` inventories legacy hashed repository roots without changing durable task data, and `--execute` preflights every root and collision before staging private copies. Both emit machine-readable `old_task_path` → `new_task_path`, `new_state_path`, and checkpoint-path mappings; callers must take the emitted new absolute paths as their post-migration authority rather than deriving them. Execute publishes its prepared write-ahead manifest before creating transaction work areas, rewrites each store's `repo_key` and exact absolute root/checkpoint references, renames extensionless checkpoints to `.md`, validates staged clean roots, and only then moves legacy roots into a hidden transaction-owned backup. An absent manifest is discarded only for allowlisted pre-publication staged/temp remnants with no reservation token or moved source; a prepared manifest with no published mapping may additionally contain only complete, strictly named hidden first-mapping temporaries while every source remains valid and every destination is absent. Otherwise a later public helper operation either finishes a validated clean authority or restores the complete old authority. A sibling reservation token is atomically created before a clean destination directory; recovery removes only a matching-token empty destination with `rmdir`, and never recursively deletes an unmarked external destination. Interrupted `.checkpoint-*` files make legacy migration fail actionably rather than becoming history. It refuses an active old-and-clean pair, an unowned destination reservation race, a destination/checkpoint collision, or multiple identities that normalize to the same clean key; it never merges them. A successful later run is a no-op. Workflow handoff still propagates the exact returned `task_path` and `state_path` fields.

The helper returns only machine-readable absolute `task_path` and `state_path`. Every public task-store operation (`init`, `resolve`, `read-state`, `replace-state`, `checkpoint`, `artifact`, and migration) first holds one private root layout-coordination lock, so migration cannot snapshot or retire a live writer; task-state replacement still takes its finer per-task mutation lock. The lock is a private regular PID-and-unique-owner-token file atomically published by hard link, so readers never see a missing-owner lock directory, and release removes it only while that token still matches. A retained layout lock is reclaimed only when its private owner PID is confirmed no longer alive; reclaim first hard-links the exact stale file as an exclusive `.reclaim` election, so contenders cannot acquire or remove a successor during that handoff. Live, missing, malformed, or otherwise unsafe ownership remains an actionable bounded-wait failure. A crash during that very narrow stale-reclaimer election may leave its `.reclaim` file for manual inspection rather than risking unsafe automatic recovery. It reserves task initialization with a private POSIX directory lock so concurrent explicit callers converge and same-second automatic callers receive separate keys. A retained lock fails actionably after a bounded wait; it is not automatically reclaimed because safe stale-owner recovery requires a separate lifecycle design. `init` refuses to create a clean root when a legacy hashed root already has the same canonical identity, requiring migration first. It rejects non-Git worktrees, mismatched or incomplete stores, malformed component input, unsafe roots, and write failures. `SB_NOTES_ROOT` may override the default only with a non-empty absolute directory that is neither `/` nor the user's home directory; it never falls back into the repository. All helper mutations stay below the resolved notes root, and created directories are private. Direct filesystem writers and older helpers that do not participate in this lock remain outside this coordination guarantee, and the helper does not claim `fsync`-durability across sudden power loss.

`metadata.env` records the raw and canonical identity, keys, creation date, branch, task ID, and worktree provenance. It is helper metadata, not conversational state.

## Bounded Current State

Only `state.md` is a default read. It is atomically compare-and-swap replaced through the helper and capped at **24 KiB**. Its first YAML frontmatter block has these fields exactly once; required fields elsewhere in the body, duplicates, unknown fields, and identity mismatches are rejected:

```text
schema, task_id, task_key, title, status,
repo_raw_identity, repo_canonical_identity, repo_key,
branch_raw, branch_key, worktree_provenance,
areas, risk, contract_version, last_verified_sha,
created_at, updated_at
```

It contains these sections, in this order:

```markdown
## Outcome Contract
## Confirmed Facts
## In Progress
## Remaining
## Decisions
## Risks and Uncertainty
## Resume
```

`Resume` names the last checkpoint, exact next action, first verifier, any human decision, worktree provenance, and relevant checkpoint references. State is a bounded current summary: no raw transcripts, credentials, tokens, or copied secret material.

`replace-state` requires the SHA-256 observed from the current `state.md`. It acquires a per-task mutation lock, rechecks that hash immediately before its same-directory atomic rename, and rejects stale writers without changing the current state.

## Checkpoints and Artifacts

Checkpoints are append-only, immutable `.md` files under `checkpoints/`, created through a hidden collision-resistant temporary file and atomically published only when the final filename is absent. They are capped at **16 KiB**. The helper writes their frontmatter: `schema`, `kind`, `actor`, `time`, `input_sha`, `output_sha`, and `worktree_provenance`. Their body contains:

```markdown
## Observation
## Actions
## Decision Delta
## Attempts and Failures
## Verification
## Handoff
```

Use a typed checkpoint for implementation, fix, verification, review, decision, or handoff events. `artifacts/` contains explicit, lazy path references only; do not copy logs, transcripts, or artifacts into state. Read either a checkpoint or artifact only when its path is specifically relevant to the current question.

## Evidence Priority and Learning

Notes can be stale. Current code, Git state, tests, runtime evidence, and user direction outrank every note. Record a discrepancy in the next checkpoint and update bounded state; do not silently trust stale notes.

Reusable learnings remain separate: consider `$capture-learning` only after final verification. Do not turn task state or checkpoints into automatic learning capture.

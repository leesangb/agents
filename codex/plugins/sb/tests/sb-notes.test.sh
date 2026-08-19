#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
helper_source="$repo_root/codex/plugins/sb/assets/bin/sb-notes"
temporary_root=$(mktemp -d)
temporary_root=$(CDPATH= cd -- "$temporary_root" && pwd -P)
trap 'rm -rf "$temporary_root"' 0 1 2 15
helper="$helper_source"
if [ "${SB_NOTES_HELPER_SHELL:-sh}" = dash ]; then
  helper="$temporary_root/sb-notes-dash"
  cat > "$helper" <<EOF
#!/bin/sh
exec dash "$helper_source" "\$@"
EOF
  chmod 700 "$helper"
fi

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

value() {
  printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -n 1
}

metadata_value() {
  sed -n "s/^$2=//p" "$1/metadata.env" | head -n 1
}

mode() {
  if stat -f '%Lp' "$1" >/dev/null 2>&1; then
    stat -f '%Lp' "$1"
  else
    stat -c '%a' "$1"
  fi
}

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

create_repo() {
  directory=$1
  mkdir "$directory"
  git -C "$directory" init -q
  git -C "$directory" config user.email 'sb-notes-test@example.test'
  git -C "$directory" config user.name 'SB Notes Test'
  printf '%s\n' 'initial' > "$directory/README"
  git -C "$directory" add README
  git -C "$directory" commit -qm initial
}

notes_root="$temporary_root/notes"
repo_one="$temporary_root/repo-one"
repo_two="$temporary_root/repo-two"
repo_origin_one="$temporary_root/repo-origin-one"
repo_origin_two="$temporary_root/repo-origin-two"
same_name_parent_one="$temporary_root/same-name-one"
same_name_parent_two="$temporary_root/same-name-two"
same_name_repo_one="$same_name_parent_one/shared-repository"
same_name_repo_two="$same_name_parent_two/shared-repository"
create_repo "$repo_one"
create_repo "$repo_two"
create_repo "$repo_origin_one"
create_repo "$repo_origin_two"
mkdir "$same_name_parent_one" "$same_name_parent_two"
create_repo "$same_name_repo_one"
create_repo "$same_name_repo_two"

default_home="$temporary_root/default-home"
mkdir "$default_home"
default_init=$(cd "$repo_one" && HOME="$default_home" "$helper" init --task-id 'default root task' --title 'Default root task')
case "$(value "$default_init" state_path)" in
  "$default_home/.notes/"*) ;;
  *) fail 'default notes root is not HOME/.notes' ;;
esac

first_init=$(cd "$repo_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id 'tracer task' --title 'Tracer task')
first_task_path=$(value "$first_init" task_path)
first_state_path=$(value "$first_init" state_path)
[ "$(printf '%s\n' "$first_init" | wc -l | tr -d ' ')" = 2 ] || fail 'init returned metadata beyond contracted paths'
[ -f "$first_state_path" ] || fail 'init did not create state.md'
case "$first_state_path" in
  "$notes_root"/*/*/*/*/state.md) ;;
  *) fail "init hierarchy is not repo/date/branch/task: $first_state_path" ;;
esac
[ "$(metadata_value "$first_task_path" repo_raw_identity)" != '' ] || fail 'metadata did not record repository identity'
[ "$(metadata_value "$first_task_path" repo_key)" = repo-one ] || fail 'no-origin repository key is not the clean readable basename'
printf '%s\n' "$(metadata_value "$first_task_path" branch_key)" | grep -Eq '^master-[0-9a-f]{12}$|^main-[0-9a-f]{12}$' || fail 'branch key no longer retains its hash suffix'
[ "$(metadata_value "$first_task_path" task_key)" = tracer-task-4028379d1dc9 ] || fail 'task key no longer retains its hash suffix'
case "$(metadata_value "$first_task_path" repo_canonical_identity)" in
  common-dir:*) ;;
  *) fail 'no-origin repository did not use common-dir identity' ;;
esac

custom_notes_root="$temporary_root/custom-notes-root"
mkdir "$custom_notes_root"
chmod 750 "$custom_notes_root"
custom_root_mode_before=$(mode "$custom_notes_root")
custom_root_task=$(cd "$repo_one" && SB_NOTES_ROOT="$custom_notes_root" "$helper" init --task-id 'custom root task' --title 'Custom root task')
custom_root_task_path=$(value "$custom_root_task" task_path)
SB_NOTES_ROOT="$custom_notes_root" "$helper" resolve --task-path "$custom_root_task_path" >/dev/null
SB_NOTES_ROOT="$custom_notes_root" "$helper" read-state --task-path "$custom_root_task_path" >/dev/null
[ "$(mode "$custom_notes_root")" = "$custom_root_mode_before" ] || fail 'helper changed an existing SB_NOTES_ROOT mode'

resolved=$(SB_NOTES_ROOT="$notes_root" "$helper" resolve --task-path "$first_task_path")
[ "$resolved" = "$first_init" ] || fail 'resolve did not validate and return the canonical paths'
cp "$first_state_path" "$temporary_root/state-before-resume.md"
second_init=$(cd "$repo_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id 'tracer task' --title 'Tracer task')
[ "$second_init" = "$first_init" ] || fail 'explicit task init did not resume the original task'
cmp -s "$temporary_root/state-before-resume.md" "$first_state_path" || fail 'resume modified state.md'

fake_bin="$temporary_root/fake-bin"
mkdir "$fake_bin"
cat > "$fake_bin/date" <<'EOF'
#!/bin/sh
day=${SB_NOTES_TEST_DAY:-260101}
stamp=${SB_NOTES_TEST_STAMP:-20260101T010101}
case "$*" in
  *%Y-%m-%dT%H:%M:%SZ*) printf '%sZ\n' "${stamp%T*}T01:01:01" ;;
  *%Y%m%dT%H%M%S*) printf '%s\n' "$stamp" ;;
  *%y%m%d*) printf '%s\n' "$day" ;;
  *) exec /bin/date "$@" ;;
esac
EOF
chmod 700 "$fake_bin/date"

cross_date_one=$(cd "$repo_one" && PATH="$fake_bin:$PATH" SB_NOTES_ROOT="$notes_root" SB_NOTES_TEST_DAY=260101 SB_NOTES_TEST_STAMP=20260101T010101 "$helper" init --task-id 'cross date task' --title 'Cross date task')
cross_date_path=$(value "$cross_date_one" task_path)
cross_date_state=$(value "$cross_date_one" state_path)
cp "$cross_date_state" "$temporary_root/cross-date-before.md"
cross_date_two=$(cd "$repo_one" && PATH="$fake_bin:$PATH" SB_NOTES_ROOT="$notes_root" SB_NOTES_TEST_DAY=260102 SB_NOTES_TEST_STAMP=20260102T010101 "$helper" init --task-id 'cross date task' --title 'Cross date task')
[ "$cross_date_two" = "$cross_date_one" ] || fail 'explicit task did not resume across created dates'
[ "$(metadata_value "$cross_date_path" created_date)" = 260101 ] || fail 'cross-date resume changed created date'
cmp -s "$temporary_root/cross-date-before.md" "$cross_date_state" || fail 'cross-date resume changed state'
[ "$(find "$notes_root" -path '*/cross-date-task-*/metadata.env' -type f | wc -l | tr -d ' ')" = 1 ] || fail 'cross-date resume created another metadata store'

other_task=$(cd "$repo_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id 'other task' --title 'Other task')
[ "$(value "$other_task" task_path)" != "$first_task_path" ] || fail 'distinct tasks collided'
git -C "$repo_one" checkout -qb feature/task-notes
branch_task=$(cd "$repo_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id 'tracer task' --title 'Tracer task')
[ "$(value "$branch_task" task_path)" != "$first_task_path" ] || fail 'branch stores collided'
[ "$(metadata_value "$(value "$branch_task" task_path)" branch_key)" != "$(metadata_value "$first_task_path" branch_key)" ] || fail 'branch key did not change'

other_repo=$(cd "$repo_two" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id 'tracer task' --title 'Tracer task')
[ "$(metadata_value "$(value "$other_repo" task_path)" repo_key)" != "$(metadata_value "$first_task_path" repo_key)" ] || fail 'no-origin repositories collided'

same_name_one=$(cd "$same_name_repo_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id same-name --title same-name)
[ "$(metadata_value "$(value "$same_name_one" task_path)" repo_key)" = shared-repository ] || fail 'same-basename repository did not use its readable clean key'
if (cd "$same_name_repo_two" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id same-name --title same-name) >/dev/null 2>&1; then
  fail 'different no-origin repositories with the same basename unexpectedly shared a clean key'
fi

git -C "$repo_origin_one" remote add origin 'git@personal:octo/demo-repository.git'
git -C "$repo_origin_two" remote add origin 'ssh://personal/octo/demo-repository.git'
origin_one=$(cd "$repo_origin_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id origin --title origin)
origin_two=$(cd "$repo_origin_two" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id origin --title origin)
[ "$(metadata_value "$(value "$origin_one" task_path)" repo_key)" = "$(metadata_value "$(value "$origin_two" task_path)" repo_key)" ] || fail 'equivalent origin forms produced different repository keys'
[ "$(metadata_value "$(value "$origin_one" task_path)" repo_key)" = octo-demo-repository ] || fail 'origin repository key is not the clean owner-repository key'
[ "$(metadata_value "$(value "$origin_one" task_path)" repo_canonical_identity)" = 'origin:octo/demo-repository' ] || fail 'origin canonical identity is incorrect'

linked_worktree="$temporary_root/linked-worktree"
git -C "$repo_one" worktree add -qb linked/task-notes "$linked_worktree"
linked_task=$(cd "$linked_worktree" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id linked --title linked)
[ "$(metadata_value "$(value "$linked_task" task_path)" repo_key)" = "$(metadata_value "$(value "$branch_task" task_path)" repo_key)" ] || fail 'linked worktree changed repo key'
[ "$(metadata_value "$(value "$linked_task" task_path)" branch_key)" != "$(metadata_value "$(value "$branch_task" task_path)" branch_key)" ] || fail 'linked worktree did not get a distinct branch key'
git -C "$repo_two" checkout -q --detach
detached_task=$(cd "$repo_two" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id detached --title detached)
case "$(metadata_value "$(value "$detached_task" task_path)" branch_key)" in
  detached-*) ;;
  *) fail 'detached HEAD did not get detached branch key' ;;
esac

for number in 1 2 3 4 5 6; do
  mkfifo "$temporary_root/explicit-$number.fifo"
  (
    read ignored < "$temporary_root/explicit-$number.fifo"
    cd "$repo_one"
    SB_NOTES_ROOT="$notes_root" "$helper" init --task-id 'concurrent explicit' --title 'Concurrent explicit' > "$temporary_root/explicit-$number.out"
  ) &
  eval "explicit_pid_$number=\$!"
done
for number in 1 2 3 4 5 6; do
  printf '%s\n' go > "$temporary_root/explicit-$number.fifo"
done
for number in 1 2 3 4 5 6; do
  eval "wait \$explicit_pid_$number"
done
concurrent_explicit_path=$(value "$(cat "$temporary_root/explicit-1.out")" task_path)
for number in 2 3 4 5 6; do
  [ "$(value "$(cat "$temporary_root/explicit-$number.out")" task_path)" = "$concurrent_explicit_path" ] || fail 'concurrent explicit init did not converge'
done
[ "$(find "$notes_root" -path '*/concurrent-explicit-*/metadata.env' -type f | wc -l | tr -d ' ')" = 1 ] || fail 'concurrent explicit init created multiple stores'
[ "$(find "$notes_root" -name '.state.md.*' -o -name '.metadata.env.*' | wc -l | tr -d ' ')" = 0 ] || fail 'concurrent init left hidden temporary state'

for number in 1 2 3 4; do
  mkfifo "$temporary_root/automatic-$number.fifo"
  (
    read ignored < "$temporary_root/automatic-$number.fifo"
    cd "$repo_one"
    PATH="$fake_bin:$PATH" SB_NOTES_ROOT="$notes_root" SB_NOTES_TEST_DAY=260103 SB_NOTES_TEST_STAMP=20260103T010101 "$helper" init --title 'Automatic concurrent task' > "$temporary_root/automatic-$number.out"
  ) &
  eval "automatic_pid_$number=\$!"
done
for number in 1 2 3 4; do
  printf '%s\n' go > "$temporary_root/automatic-$number.fifo"
done
for number in 1 2 3 4; do
  eval "wait \$automatic_pid_$number"
done
automatic_paths=$(for number in 1 2 3 4; do value "$(cat "$temporary_root/automatic-$number.out")" task_path; done | sort -u | wc -l | tr -d ' ')
[ "$automatic_paths" = 4 ] || fail 'same-second automatic init did not reserve distinct task paths'

checkpoint_body="$temporary_root/checkpoint-body.md"
cat > "$checkpoint_body" <<'EOF'
## Observation
Created a tracer task.

## Actions
Ran the helper.

## Decision Delta
None.

## Attempts and Failures
None.

## Verification
State exists.

## Handoff
Continue with tests.
EOF
checkpoint_one=$(SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$first_task_path" --kind implementation --actor worker --input-sha before --output-sha after --file "$checkpoint_body")
checkpoint_one_path=$(value "$checkpoint_one" checkpoint_path)
checkpoint_two=$(SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$first_task_path" --kind verification --actor worker --input-sha after --output-sha verified --file "$checkpoint_body")
[ "$(value "$checkpoint_two" checkpoint_path)" != "$checkpoint_one_path" ] || fail 'checkpoint append overwrote an existing checkpoint'
case "$checkpoint_one_path" in *.md) ;; *) fail 'checkpoint did not publish a Markdown filename' ;; esac
case "$(basename "$checkpoint_one_path")" in .*) fail 'checkpoint exposed its hidden temporary filename' ;; esac
checkpoint_dir="$first_task_path/checkpoints"
checkpoint_count=$(find "$checkpoint_dir" -type f | wc -l | tr -d ' ')
{
  cat "$checkpoint_body"
  dd if=/dev/zero bs=16000 count=1 2>/dev/null | tr '\000' x
} > "$temporary_root/large-checkpoint.md"
if SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$first_task_path" --kind verification --actor worker --input-sha after --output-sha verified --file "$temporary_root/large-checkpoint.md" >/dev/null 2>&1; then
  fail 'oversized published checkpoint unexpectedly succeeded'
fi
[ "$(find "$checkpoint_dir" -type f | wc -l | tr -d ' ')" = "$checkpoint_count" ] || fail 'checkpoint size failure left a checkpoint file'
[ "$(find "$checkpoint_dir" -name '.*checkpoint*' -type f | wc -l | tr -d ' ')" = 0 ] || fail 'checkpoint publication left a hidden temporary file'

artifact_source="$temporary_root/verification-output.txt"
printf '%s\n' 'explicit artifact content' > "$artifact_source"
artifact_result=$(SB_NOTES_ROOT="$notes_root" "$helper" artifact --task-path "$first_task_path" --name verification-output --path "$artifact_source")
[ -f "$(value "$artifact_result" artifact_path)" ] || fail 'artifact reference was not created'
newline_artifact="$temporary_root/artifact
path"
if SB_NOTES_ROOT="$notes_root" "$helper" artifact --task-path "$first_task_path" --name invalid-artifact --path "$newline_artifact" >/dev/null 2>&1; then
  fail 'newline artifact path unexpectedly succeeded'
fi

expected_hash=$(hash_file "$first_state_path")
replacement_state="$temporary_root/replacement-state.md"
sed 's/^status: "initialized"/status: "in-progress"/' "$first_state_path" > "$replacement_state"
SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$first_task_path" --expected-hash "$expected_hash" --file "$replacement_state" >/dev/null
grep -Fqx 'status: "in-progress"' "$first_state_path" || fail 'valid state replacement did not update state.md'
second_replacement="$temporary_root/second-replacement.md"
sed 's/^status: "in-progress"/status: "reviewed"/' "$first_state_path" > "$second_replacement"
if SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$first_task_path" --expected-hash "$expected_hash" --file "$second_replacement" >/dev/null 2>&1; then
  fail 'stale state writer unexpectedly succeeded'
fi
grep -Fqx 'status: "in-progress"' "$first_state_path" || fail 'stale writer changed the first successful replacement'
cp "$first_state_path" "$temporary_root/state-before-rejection.md"

malformed_state="$temporary_root/malformed-state.md"
printf '%s\n' 'not a state file' > "$malformed_state"
if SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$first_task_path" --expected-hash "$(hash_file "$first_state_path")" --file "$malformed_state" >/dev/null 2>&1; then
  fail 'malformed state replacement unexpectedly succeeded'
fi
duplicate_state="$temporary_root/duplicate-state.md"
awk '/^schema:/{print; print; next} {print}' "$first_state_path" > "$duplicate_state"
if SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$first_task_path" --expected-hash "$(hash_file "$first_state_path")" --file "$duplicate_state" >/dev/null 2>&1; then
  fail 'duplicate frontmatter state unexpectedly succeeded'
fi
body_field_state="$temporary_root/body-field-state.md"
cp "$first_state_path" "$body_field_state"
printf '\nrepo_key: "body-conflict"\n' >> "$body_field_state"
if SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$first_task_path" --expected-hash "$(hash_file "$first_state_path")" --file "$body_field_state" >/dev/null 2>&1; then
  fail 'body-only required field unexpectedly succeeded'
fi
conflicting_identity_state="$temporary_root/conflicting-identity-state.md"
sed 's/^repo_key: .*/repo_key: "wrong"/' "$first_state_path" > "$conflicting_identity_state"
if SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$first_task_path" --expected-hash "$(hash_file "$first_state_path")" --file "$conflicting_identity_state" >/dev/null 2>&1; then
  fail 'conflicting identity state unexpectedly succeeded'
fi
conflicting_schema_state="$temporary_root/conflicting-schema-state.md"
sed 's|^schema: .*|schema: sb-task-notes/v2|' "$first_state_path" > "$conflicting_schema_state"
if SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$first_task_path" --expected-hash "$(hash_file "$first_state_path")" --file "$conflicting_schema_state" >/dev/null 2>&1; then
  fail 'conflicting schema state unexpectedly succeeded'
fi
cmp -s "$temporary_root/state-before-rejection.md" "$first_state_path" || fail 'rejected replacement changed state bytes'

incomplete_task=$(cd "$repo_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id incomplete --title incomplete)
incomplete_path=$(value "$incomplete_task" task_path)
rm -f "$(value "$incomplete_task" state_path)"
if (cd "$repo_one" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id incomplete --title incomplete) >/dev/null 2>&1; then
  fail 'incomplete task store was treated as a valid resume'
fi
if SB_NOTES_ROOT="$notes_root" "$helper" resolve --task-path "$incomplete_path" >/dev/null 2>&1; then
  fail 'resolve accepted an incomplete task store'
fi

newline_repo="$temporary_root/repo
newline"
create_repo "$newline_repo"
if (cd "$newline_repo" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id newline-worktree --title newline-worktree) >/dev/null 2>&1; then
  fail 'newline worktree path unexpectedly succeeded'
fi

other_notes_root="$temporary_root/other-notes"
mkdir "$other_notes_root"
if SB_NOTES_ROOT="$other_notes_root" "$helper" resolve --task-path "$first_task_path" >/dev/null 2>&1; then
  fail 'mismatched notes root unexpectedly resolved a task'
fi
if (cd "$repo_one" && SB_NOTES_ROOT=/ "$helper" init --task-id unsafe --title unsafe) >/dev/null 2>&1; then
  fail 'unsafe notes root unexpectedly succeeded'
fi

printf '%s\n' 'sb-notes tests passed'

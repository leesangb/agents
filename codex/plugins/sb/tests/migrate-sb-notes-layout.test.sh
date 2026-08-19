#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
helper_source="$repo_root/codex/plugins/sb/assets/bin/sb-notes"
temporary_root=$(mktemp -d)
temporary_root=$(CDPATH= cd -- "$temporary_root" && pwd -P)
cleanup_temporary_root() {
  cleanup_status=$?
  if [ "${SB_NOTES_KEEP_TEST_TEMP:-no}" = yes ]; then
    printf '%s\n' "preserved_test_root=$temporary_root" >&2
  else
    rm -rf "$temporary_root"
  fi
  return "$cleanup_status"
}
trap 'cleanup_temporary_root' 0 1 2 15
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

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'; else shasum -a 256 "$1" | awk '{print $1}'; fi
}

mode() {
  if stat -f '%Lp' "$1" >/dev/null 2>&1; then stat -f '%Lp' "$1"; else stat -c '%a' "$1"; fi
}

mtime() {
  if stat -f '%m' "$1" >/dev/null 2>&1; then stat -f '%m' "$1"; else stat -c '%Y' "$1"; fi
}

snapshot_tree() {
  tree_root=$1
  find "$tree_root" -mindepth 1 \( -type d -o -type f \) -print | LC_ALL=C sort | while IFS= read -r file; do
    relative=${file#"$tree_root"/}
    if [ -d "$file" ]; then
      printf 'directory %s %s\n' "$relative" "$(mode "$file")"
    else
      printf 'file %s %s %s %s\n' "$relative" "$(hash_file "$file")" "$(mode "$file")" "$(mtime "$file")"
    fi
  done
}

replace_prefix() {
  path_value=$1
  old_prefix=$2
  new_prefix=$3
  case "$path_value" in
    "$old_prefix"/*) printf '%s/%s\n' "$new_prefix" "${path_value#"$old_prefix"/}" ;;
    *) fail "path does not use expected prefix: $path_value" ;;
  esac
}

rewrite_literal() {
  source_file=$1
  old_text=$2
  new_text=$3
  temporary_file="$source_file.rewrite"
  awk -v old_text="$old_text" -v new_text="$new_text" '
    { remaining = $0; while ((offset = index(remaining, old_text)) != 0) { printf "%s%s", substr(remaining, 1, offset - 1), new_text; remaining = substr(remaining, offset + length(old_text)) } print remaining }
  ' "$source_file" > "$temporary_file"
  mv "$temporary_file" "$source_file"
}

create_repo() {
  directory=$1
  mkdir "$directory"
  git -C "$directory" init -q
  git -C "$directory" config user.email 'sb-notes-migration-test@example.test'
  git -C "$directory" config user.name 'SB Notes Migration Test'
  printf '%s\n' initial > "$directory/README"
  git -C "$directory" add README
  git -C "$directory" commit -qm initial
}

write_checkpoint_body() {
  body_file=$1
  cat > "$body_file" <<'EOF'
## Observation
Existing history is being migrated.

## Actions
Created a representative checkpoint.

## Decision Delta
None.

## Attempts and Failures
None.

## Verification
The checkpoint is valid.

## Handoff
Continue migration verification.
EOF
}

convert_clean_root_to_old_layout() {
  notes_root=$1
  clean_key=$2
  old_key=$3
  clean_root="$notes_root/$clean_key"
  old_root="$notes_root/$old_key"
  mv "$clean_root" "$old_root"
  find "$old_root" -name metadata.env -type f | while IFS= read -r metadata; do
    rewrite_literal "$metadata" "repo_key=$clean_key" "repo_key=$old_key"
    state_file="$(dirname "$metadata")/state.md"
    rewrite_literal "$state_file" "repo_key: \"$clean_key\"" "repo_key: \"$old_key\""
    rewrite_literal "$state_file" "$clean_root" "$old_root"
  done
}

copy_old_root_as_clean_layout() {
  old_root=$1
  clean_root=$2
  old_key=$3
  clean_key=$4
  mkdir "$clean_root"
  cp -pR "$old_root"/. "$clean_root"
  find "$clean_root" -name metadata.env -type f | while IFS= read -r metadata; do
    rewrite_literal "$metadata" "repo_key=$old_key" "repo_key=$clean_key"
    state_file="$(dirname "$metadata")/state.md"
    rewrite_literal "$state_file" "repo_key: \"$old_key\"" "repo_key: \"$clean_key\""
  done
  find "$clean_root" \( -name state.md -o -path '*/checkpoints/*' \) -type f | while IFS= read -r file; do
    rewrite_literal "$file" "$old_root" "$clean_root"
  done
}

new_value_for_old() {
  output=$1
  old_field=$2
  old_value=$3
  new_field=$4
  printf '%s\n' "$output" | awk -v old_field="$old_field" -v old_value="$old_value" -v new_field="$new_field" '
    $0 == old_field "=" old_value { found = 1; next }
    found && index($0, new_field "=") == 1 { print substr($0, length(new_field) + 2); exit }
  '
}

new_root_for_old() {
  output=$1
  old_root=$2
  printf '%s\n' "$output" | awk -v old_root="$old_root" '
    $0 == "old_repo_root=" old_root { found = 1; next }
    found && index($0, "new_repo_root=") == 1 { print substr($0, 15); exit }
  '
}

append_expected_mappings() {
  old_root=$1
  clean_root=$2
  mapping_file=$3
  find "$old_root" -name metadata.env -type f -print | LC_ALL=C sort | while IFS= read -r metadata; do
    task_path=$(dirname "$metadata")
    relative_task=${task_path#"$old_root"/}
    printf 'old_task_path=%s\n' "$old_root/$relative_task" >> "$mapping_file"
    printf 'new_task_path=%s\n' "$clean_root/$relative_task" >> "$mapping_file"
    printf 'new_state_path=%s\n' "$clean_root/$relative_task/state.md" >> "$mapping_file"
  done
  find "$old_root" -path '*/checkpoints/*' -type f -print | LC_ALL=C sort | while IFS= read -r checkpoint; do
    relative_checkpoint=${checkpoint#"$old_root"/}
    case "$relative_checkpoint" in *.md) new_checkpoint="$clean_root/$relative_checkpoint" ;; *) new_checkpoint="$clean_root/$relative_checkpoint.md" ;; esac
    printf 'old_checkpoint_path=%s\n' "$old_root/$relative_checkpoint" >> "$mapping_file"
    printf 'new_checkpoint_path=%s\n' "$new_checkpoint" >> "$mapping_file"
  done
}

write_transaction_manifest() {
  transaction=$1
  final_backup=$2
  phase=$3
  {
    printf '%s\n' 'schema=sb-notes-layout-transaction/v1'
    printf 'phase=%s\n' "$phase"
    printf 'final_backup=%s\n' "$final_backup"
  } > "$transaction/manifest.env"
}

write_transaction_mapping() {
  transaction=$1
  old_root=$2
  clean_root=$3
  backup_root=$4
  identity=$5
  old_key=$6
  clean_key=$7
  published=${8:-yes}
  mkdir -p "$transaction/mappings"
  {
    printf 'old_root=%s\n' "$old_root"
    printf 'clean_root=%s\n' "$clean_root"
    printf 'stage_root=%s\n' "$transaction/staged/$clean_key"
    printf 'backup_root=%s\n' "$backup_root"
    printf 'canonical_identity=%s\n' "$identity"
    printf 'old_repo_key=%s\n' "$old_key"
    printf 'clean_repo_key=%s\n' "$clean_key"
    printf 'reservation_token=%s\n' "$(dirname "$transaction")/.sb-notes-layout-reservation-$(basename "$transaction")-$clean_key"
    printf 'published=%s\n' "$published"
  } > "$transaction/mappings/1.env"
}

write_reservation_token() {
  transaction=$1
  clean_root=$2
  clean_key=$3
  token="$(dirname "$transaction")/.sb-notes-layout-reservation-$(basename "$transaction")-$clean_key"
  {
    printf '%s\n' "$transaction"
    printf '%s\n' "$clean_root"
  } > "$token"
}

notes_root="$temporary_root/notes"
agents_repo="$temporary_root/agents-source"
canvas_repo="$temporary_root/canvas-source"
create_repo "$agents_repo"
create_repo "$canvas_repo"
git -C "$agents_repo" remote add origin 'git@personal:octo/agents.git'
git -C "$canvas_repo" remote add origin 'ssh://personal/miri/canvas.git'
checkpoint_body="$temporary_root/checkpoint-body.md"
write_checkpoint_body "$checkpoint_body"

agents_main=$(cd "$agents_repo" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id agents-main --title 'Agents main')
agents_main_task=$(value "$agents_main" task_path)
agents_main_checkpoint=$(SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$agents_main_task" --kind implementation --actor worker --input-sha agents-before --output-sha agents-after --file "$checkpoint_body")
agents_main_checkpoint=$(value "$agents_main_checkpoint" checkpoint_path)
git -C "$agents_repo" checkout -qb feature/migration-history
agents_feature=$(cd "$agents_repo" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id agents-feature --title 'Agents feature')
agents_feature_task=$(value "$agents_feature" task_path)
agents_feature_checkpoint=$(SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$agents_feature_task" --kind verification --actor worker --input-sha feature-before --output-sha feature-after --file "$checkpoint_body")
agents_feature_checkpoint=$(value "$agents_feature_checkpoint" checkpoint_path)
canvas_task=$(cd "$canvas_repo" && SB_NOTES_ROOT="$notes_root" "$helper" init --task-id canvas-main --title 'Canvas main')
canvas_task_path=$(value "$canvas_task" task_path)
canvas_checkpoint_one=$(SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$canvas_task_path" --kind implementation --actor worker --input-sha canvas-before --output-sha canvas-after --file "$checkpoint_body")
canvas_checkpoint_one=$(value "$canvas_checkpoint_one" checkpoint_path)
canvas_checkpoint_two=$(SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$canvas_task_path" --kind verification --actor worker --input-sha canvas-after --output-sha canvas-verified --file "$checkpoint_body")
canvas_checkpoint_two=$(value "$canvas_checkpoint_two" checkpoint_path)

agents_old_key='octo-agents-111111111111'
canvas_old_key='miri-canvas-222222222222'
agents_clean_root="$notes_root/octo-agents"
canvas_clean_root="$notes_root/miri-canvas"
agents_old_root="$notes_root/$agents_old_key"
canvas_old_root="$notes_root/$canvas_old_key"
convert_clean_root_to_old_layout "$notes_root" octo-agents "$agents_old_key"
convert_clean_root_to_old_layout "$notes_root" miri-canvas "$canvas_old_key"
agents_main_old_task=$(replace_prefix "$agents_main_task" "$agents_clean_root" "$agents_old_root")
agents_feature_old_task=$(replace_prefix "$agents_feature_task" "$agents_clean_root" "$agents_old_root")
canvas_old_task=$(replace_prefix "$canvas_task_path" "$canvas_clean_root" "$canvas_old_root")
agents_main_old_checkpoint=$(replace_prefix "$agents_main_checkpoint" "$agents_clean_root" "$agents_old_root")
agents_feature_old_checkpoint=$(replace_prefix "$agents_feature_checkpoint" "$agents_clean_root" "$agents_old_root")
canvas_old_checkpoint_one=$(replace_prefix "$canvas_checkpoint_one" "$canvas_clean_root" "$canvas_old_root")
canvas_old_checkpoint_two=$(replace_prefix "$canvas_checkpoint_two" "$canvas_clean_root" "$canvas_old_root")
for checkpoint in "$agents_main_old_checkpoint" "$agents_feature_old_checkpoint" "$canvas_old_checkpoint_one" "$canvas_old_checkpoint_two"; do mv "$checkpoint" "${checkpoint%.md}"; done
agents_main_old_checkpoint=${agents_main_old_checkpoint%.md}
agents_feature_old_checkpoint=${agents_feature_old_checkpoint%.md}
canvas_old_checkpoint_one=${canvas_old_checkpoint_one%.md}
canvas_old_checkpoint_two=${canvas_old_checkpoint_two%.md}
agents_main_old_state="$agents_main_old_task/state.md"
rewrite_literal "$agents_main_old_state" '- Relevant checkpoints: none' "- Relevant checkpoints: $agents_main_old_checkpoint"
printf '\nCross-repository checkpoint: %s\n' "$canvas_old_checkpoint_one" >> "$agents_main_old_checkpoint"

mkdir "$notes_root/.obsidian"
printf '%s\n' keep > "$notes_root/.obsidian/layout.json"
printf '%s\n' legacy > "$notes_root/implementation-notes.local.md"
obsidian_sentinel="$notes_root/.obsidian/layout.json"
legacy_sentinel="$notes_root/implementation-notes.local.md"
obsidian_hash_before=$(hash_file "$obsidian_sentinel")
obsidian_mode_before=$(mode "$obsidian_sentinel")
obsidian_mtime_before=$(mtime "$obsidian_sentinel")
legacy_hash_before=$(hash_file "$legacy_sentinel")
legacy_mode_before=$(mode "$legacy_sentinel")
legacy_mtime_before=$(mtime "$legacy_sentinel")
expected_mapping_file="$temporary_root/expected-mappings"
append_expected_mappings "$agents_old_root" "$agents_clean_root" "$expected_mapping_file"
append_expected_mappings "$canvas_old_root" "$canvas_clean_root" "$expected_mapping_file"
expected_path_mappings=$(LC_ALL=C sort "$expected_mapping_file")
before_dry_run=$(snapshot_tree "$notes_root")
dry_run=$(SB_NOTES_ROOT="$notes_root" "$helper" migrate-layout --dry-run)
[ "$(value "$dry_run" migration)" = dry-run ] || fail 'dry run did not identify itself'
[ "$before_dry_run" = "$(snapshot_tree "$notes_root")" ] || fail 'dry run changed the notes tree'
agents_new_root=$(new_root_for_old "$dry_run" "$agents_old_root")
canvas_new_root=$(new_root_for_old "$dry_run" "$canvas_old_root")
agents_main_new_task=$(new_value_for_old "$dry_run" old_task_path "$agents_main_old_task" new_task_path)
agents_main_new_state=$(new_value_for_old "$dry_run" old_task_path "$agents_main_old_task" new_state_path)
agents_main_new_checkpoint=$(new_value_for_old "$dry_run" old_checkpoint_path "$agents_main_old_checkpoint" new_checkpoint_path)
canvas_new_checkpoint_one=$(new_value_for_old "$dry_run" old_checkpoint_path "$canvas_old_checkpoint_one" new_checkpoint_path)
[ -n "$agents_new_root" ] && [ -n "$agents_main_new_task" ] && [ -n "$agents_main_new_state" ] && [ -n "$agents_main_new_checkpoint" ] && [ -n "$canvas_new_checkpoint_one" ] || fail 'dry run did not emit exact path mappings'
dry_path_mappings=$(printf '%s\n' "$dry_run" | awk '/^(old_task_path|new_task_path|new_state_path|old_checkpoint_path|new_checkpoint_path)=/' | LC_ALL=C sort)
[ "$dry_path_mappings" = "$expected_path_mappings" ] || fail 'dry run mappings do not cover the independently derived legacy task and checkpoint paths'

agents_metadata_expected="$temporary_root/agents-metadata.expected"
agents_state_expected="$temporary_root/agents-state.expected"
agents_checkpoint_expected="$temporary_root/agents-checkpoint.expected"
agents_metadata_mode_before=$(mode "$agents_main_old_task/metadata.env")
agents_metadata_mtime_before=$(mtime "$agents_main_old_task/metadata.env")
agents_state_mode_before=$(mode "$agents_main_old_state")
agents_state_mtime_before=$(mtime "$agents_main_old_state")
agents_checkpoint_mode_rewritten_before=$(mode "$agents_main_old_checkpoint")
agents_checkpoint_mtime_rewritten_before=$(mtime "$agents_main_old_checkpoint")
cp "$agents_main_old_task/metadata.env" "$agents_metadata_expected"
cp "$agents_main_old_state" "$agents_state_expected"
cp "$agents_main_old_checkpoint" "$agents_checkpoint_expected"
rewrite_literal "$agents_metadata_expected" "repo_key=$agents_old_key" 'repo_key=octo-agents'
rewrite_literal "$agents_state_expected" "repo_key: \"$agents_old_key\"" 'repo_key: "octo-agents"'
rewrite_literal "$agents_state_expected" "$agents_main_old_checkpoint" "$agents_main_new_checkpoint"
rewrite_literal "$agents_state_expected" "$agents_old_root" "$agents_new_root"
rewrite_literal "$agents_checkpoint_expected" "$canvas_old_checkpoint_one" "$canvas_new_checkpoint_one"
agents_checkpoint_hash_before=$(hash_file "$agents_feature_old_checkpoint")
agents_checkpoint_mode_before=$(mode "$agents_feature_old_checkpoint")
agents_checkpoint_mtime_before=$(mtime "$agents_feature_old_checkpoint")

execute_result=$(SB_NOTES_ROOT="$notes_root" "$helper" migrate-layout --execute)
[ "$(value "$execute_result" migration)" = completed ] || fail 'layout migration did not complete'
[ "$(new_value_for_old "$execute_result" old_task_path "$agents_main_old_task" new_task_path)" = "$agents_main_new_task" ] || fail 'execute path mapping differs from dry run'
execute_path_mappings=$(printf '%s\n' "$execute_result" | awk '/^(old_task_path|new_task_path|new_state_path|old_checkpoint_path|new_checkpoint_path)=/' | LC_ALL=C sort)
[ "$execute_path_mappings" = "$expected_path_mappings" ] || fail 'execute mappings do not preserve the independently derived legacy task and checkpoint paths'
[ ! -e "$agents_old_root" ] && [ ! -e "$canvas_old_root" ] || fail 'migration left old roots active'
cmp -s "$agents_metadata_expected" "$agents_main_new_task/metadata.env" || fail 'metadata changed beyond the permitted repository-key rewrite'
cmp -s "$agents_state_expected" "$agents_main_new_state" || fail 'state changed beyond permitted path and repository-key rewrites'
cmp -s "$agents_checkpoint_expected" "$agents_main_new_checkpoint" || fail 'checkpoint changed beyond permitted cross-repository reference rewrite'
[ "$(mode "$agents_main_new_task/metadata.env")" = "$agents_metadata_mode_before" ] && [ "$(mtime "$agents_main_new_task/metadata.env")" = "$agents_metadata_mtime_before" ] || fail 'rewritten metadata mode or timestamp was not preserved'
[ "$(mode "$agents_main_new_state")" = "$agents_state_mode_before" ] && [ "$(mtime "$agents_main_new_state")" = "$agents_state_mtime_before" ] || fail 'rewritten state mode or timestamp was not preserved'
[ "$(mode "$agents_main_new_checkpoint")" = "$agents_checkpoint_mode_rewritten_before" ] && [ "$(mtime "$agents_main_new_checkpoint")" = "$agents_checkpoint_mtime_rewritten_before" ] || fail 'rewritten checkpoint mode or timestamp was not preserved'
[ "$(hash_file "$(new_value_for_old "$dry_run" old_checkpoint_path "$agents_feature_old_checkpoint" new_checkpoint_path)")" = "$agents_checkpoint_hash_before" ] || fail 'unchanged checkpoint content was not preserved'
[ "$(mode "$(new_value_for_old "$dry_run" old_checkpoint_path "$agents_feature_old_checkpoint" new_checkpoint_path)")" = "$agents_checkpoint_mode_before" ] || fail 'unchanged checkpoint mode was not preserved'
[ "$(mtime "$(new_value_for_old "$dry_run" old_checkpoint_path "$agents_feature_old_checkpoint" new_checkpoint_path)")" = "$agents_checkpoint_mtime_before" ] || fail 'unchanged checkpoint timestamp was not preserved'
[ "$(find "$agents_new_root" -type d -name .locks | wc -l | tr -d ' ')" = 0 ] || fail 'migration published transient lock directories'
[ "$(hash_file "$obsidian_sentinel")" = "$obsidian_hash_before" ] && [ "$(mode "$obsidian_sentinel")" = "$obsidian_mode_before" ] && [ "$(mtime "$obsidian_sentinel")" = "$obsidian_mtime_before" ] || fail 'migration changed the Obsidian sentinel'
[ "$(hash_file "$legacy_sentinel")" = "$legacy_hash_before" ] && [ "$(mode "$legacy_sentinel")" = "$legacy_mode_before" ] && [ "$(mtime "$legacy_sentinel")" = "$legacy_mtime_before" ] || fail 'migration changed the unrelated legacy sentinel'
SB_NOTES_ROOT="$notes_root" "$helper" resolve --task-path "$agents_main_new_task" >/dev/null
SB_NOTES_ROOT="$notes_root" "$helper" read-state --task-path "$agents_main_new_task" >/dev/null
replacement_state="$temporary_root/replacement-state.md"
sed 's/^status: "initialized"/status: "migrated"/' "$agents_main_new_state" > "$replacement_state"
SB_NOTES_ROOT="$notes_root" "$helper" replace-state --task-path "$agents_main_new_task" --expected-hash "$(hash_file "$agents_main_new_state")" --file "$replacement_state" >/dev/null
new_checkpoint=$(SB_NOTES_ROOT="$notes_root" "$helper" checkpoint --task-path "$agents_main_new_task" --kind verification --actor worker --input-sha migrated --output-sha verified --file "$checkpoint_body")
case "$(value "$new_checkpoint" checkpoint_path)" in *.md) ;; *) fail 'new checkpoint is not Markdown' ;; esac
[ "$(SB_NOTES_ROOT="$notes_root" "$helper" migrate-layout --execute)" = 'migration=not-needed' ] || fail 'second migration was not a no-op'

legacy_init_root="$temporary_root/legacy-init"
legacy_init_task=$(cd "$canvas_repo" && SB_NOTES_ROOT="$legacy_init_root" "$helper" init --task-id legacy-init --title legacy-init)
legacy_init_clean="$legacy_init_root/miri-canvas"
legacy_init_old='miri-canvas-333333333333'
legacy_init_old_root="$legacy_init_root/$legacy_init_old"
convert_clean_root_to_old_layout "$legacy_init_root" miri-canvas "$legacy_init_old"
legacy_init_snapshot=$(snapshot_tree "$legacy_init_root")
if (cd "$canvas_repo" && SB_NOTES_ROOT="$legacy_init_root" "$helper" init --task-id must-not-split --title must-not-split) >/dev/null 2>&1; then fail 'init created a clean store beside legacy history'; fi
[ ! -e "$legacy_init_clean" ] && [ "$legacy_init_snapshot" = "$(snapshot_tree "$legacy_init_root")" ] || fail 'legacy init refusal changed the notes tree'

collision_root="$temporary_root/checkpoint-collision"
collision_task=$(cd "$canvas_repo" && SB_NOTES_ROOT="$collision_root" "$helper" init --task-id checkpoint-collision --title checkpoint-collision)
collision_task_path=$(value "$collision_task" task_path)
collision_checkpoint=$(SB_NOTES_ROOT="$collision_root" "$helper" checkpoint --task-path "$collision_task_path" --kind implementation --actor worker --input-sha before --output-sha after --file "$checkpoint_body")
collision_checkpoint=$(value "$collision_checkpoint" checkpoint_path)
collision_clean="$collision_root/miri-canvas"
collision_old='miri-canvas-444444444444'
collision_old_root="$collision_root/$collision_old"
convert_clean_root_to_old_layout "$collision_root" miri-canvas "$collision_old"
collision_old_checkpoint=$(replace_prefix "$collision_checkpoint" "$collision_clean" "$collision_old_root")
mv "$collision_old_checkpoint" "${collision_old_checkpoint%.md}"
collision_old_checkpoint=${collision_old_checkpoint%.md}
printf '%s\n' 'extensionless sentinel' > "$collision_old_checkpoint"
printf '%s\n' 'markdown sentinel must survive' > "$collision_old_checkpoint.md"
collision_snapshot=$(snapshot_tree "$collision_root")
if SB_NOTES_ROOT="$collision_root" "$helper" migrate-layout --execute >/dev/null 2>&1; then fail 'checkpoint destination collision unexpectedly succeeded'; fi
[ "$collision_snapshot" = "$(snapshot_tree "$collision_root")" ] && [ ! -e "$collision_clean" ] || fail 'checkpoint collision changed the old tree or published a clean root'

transient_root="$temporary_root/checkpoint-transient"
transient_task=$(cd "$canvas_repo" && SB_NOTES_ROOT="$transient_root" "$helper" init --task-id checkpoint-transient --title checkpoint-transient)
transient_task_path=$(value "$transient_task" task_path)
transient_checkpoint=$(SB_NOTES_ROOT="$transient_root" "$helper" checkpoint --task-path "$transient_task_path" --kind implementation --actor worker --input-sha before --output-sha after --file "$checkpoint_body")
transient_checkpoint=$(value "$transient_checkpoint" checkpoint_path)
transient_clean="$transient_root/miri-canvas"
transient_old='miri-canvas-444444444445'
transient_old_root="$transient_root/$transient_old"
convert_clean_root_to_old_layout "$transient_root" miri-canvas "$transient_old"
transient_old_checkpoint=$(replace_prefix "$transient_checkpoint" "$transient_clean" "$transient_old_root")
transient_checkpoint_dir=$(dirname "$transient_old_checkpoint")
: > "$transient_checkpoint_dir/.checkpoint-killed-empty"
printf '%s\n' partial > "$transient_checkpoint_dir/.checkpoint-killed-partial"
transient_snapshot=$(snapshot_tree "$transient_root")
if SB_NOTES_ROOT="$transient_root" "$helper" migrate-layout --execute >/dev/null 2>&1; then fail 'legacy checkpoint transients unexpectedly migrated'; fi
[ "$transient_snapshot" = "$(snapshot_tree "$transient_root")" ] && [ ! -e "$transient_clean" ] || fail 'legacy checkpoint transient failure changed history or published a clean root'

same_root="$temporary_root/same-basename"
mkdir "$temporary_root/same-a" "$temporary_root/same-b"
same_repo_a="$temporary_root/same-a/shared"
same_repo_b="$temporary_root/same-b/shared"
create_repo "$same_repo_a"
create_repo "$same_repo_b"
same_a=$(cd "$same_repo_a" && SB_NOTES_ROOT="$same_root" "$helper" init --task-id one --title one)
convert_clean_root_to_old_layout "$same_root" shared 'shared-555555555555'
same_b=$(cd "$same_repo_b" && SB_NOTES_ROOT="$same_root" "$helper" init --task-id two --title two)
convert_clean_root_to_old_layout "$same_root" shared 'shared-666666666666'
same_snapshot=$(snapshot_tree "$same_root")
if SB_NOTES_ROOT="$same_root" "$helper" migrate-layout --execute >/dev/null 2>&1; then fail 'same-basename identities unexpectedly merged'; fi
[ "$same_snapshot" = "$(snapshot_tree "$same_root")" ] && [ ! -e "$same_root/shared" ] || fail 'same-basename collision changed the tree or created a task'

publish_root="$temporary_root/checkpoint-publish"
publish_task=$(cd "$agents_repo" && SB_NOTES_ROOT="$publish_root" "$helper" init --task-id publish --title publish)
publish_task_path=$(value "$publish_task" task_path)
prior_checkpoint=$(SB_NOTES_ROOT="$publish_root" "$helper" checkpoint --task-path "$publish_task_path" --kind implementation --actor worker --input-sha before --output-sha after --file "$checkpoint_body")
prior_checkpoint=$(value "$prior_checkpoint" checkpoint_path)
cp "$prior_checkpoint" "$temporary_root/prior-checkpoint.before"
fake_ln_bin="$temporary_root/fake-ln"
mkdir "$fake_ln_bin"
cat > "$fake_ln_bin/ln" <<'EOF'
#!/bin/sh
case "${2:-}" in
  */checkpoints/*)
    printf '%s\n' "$2" > "${SB_NOTES_FAKE_LN_TARGET:?}"
    printf '%s\n' 'checkpoint publication sentinel' > "$2"
    exit 1
    ;;
  *) exec /bin/ln "$@" ;;
esac
EOF
chmod 700 "$fake_ln_bin/ln"
fake_ln_target="$temporary_root/fake-ln-target"
if PATH="$fake_ln_bin:$PATH" SB_NOTES_ROOT="$publish_root" SB_NOTES_FAKE_LN_TARGET="$fake_ln_target" "$helper" checkpoint --task-path "$publish_task_path" --kind verification --actor worker --input-sha after --output-sha verified --file "$checkpoint_body" >/dev/null 2>&1; then fail 'checkpoint link collision unexpectedly succeeded'; fi
failed_checkpoint=$(cat "$fake_ln_target")
[ "$(cat "$failed_checkpoint")" = 'checkpoint publication sentinel' ] || fail 'checkpoint publication collision overwrote its sentinel'
cmp -s "$temporary_root/prior-checkpoint.before" "$prior_checkpoint" || fail 'failed checkpoint publication changed a prior checkpoint'
[ "$(find "$publish_task_path/checkpoints" -type f | wc -l | tr -d ' ')" = 2 ] && [ "$(find "$publish_task_path/checkpoints" -name '.*checkpoint*' -type f | wc -l | tr -d ' ')" = 0 ] || fail 'failed checkpoint publication left data or temporary files'

failure_root="$temporary_root/failure-recovery"
failure_agents_repo="$temporary_root/failure-agents-source"
failure_canvas_repo="$temporary_root/failure-canvas-source"
create_repo "$failure_agents_repo"
create_repo "$failure_canvas_repo"
git -C "$failure_agents_repo" remote add origin 'git@personal:octo/failure-agents.git'
git -C "$failure_canvas_repo" remote add origin 'ssh://personal/miri/failure-canvas.git'
failure_agents_task=$(cd "$failure_agents_repo" && SB_NOTES_ROOT="$failure_root" "$helper" init --task-id failure-agents --title failure-agents)
failure_canvas_task=$(cd "$failure_canvas_repo" && SB_NOTES_ROOT="$failure_root" "$helper" init --task-id failure-canvas --title failure-canvas)
failure_agents_clean="$failure_root/octo-failure-agents"
failure_canvas_clean="$failure_root/miri-failure-canvas"
failure_agents_old_key='octo-failure-agents-777777777777'
failure_canvas_old_key='miri-failure-canvas-888888888888'
failure_agents_old_root="$failure_root/$failure_agents_old_key"
failure_canvas_old_root="$failure_root/$failure_canvas_old_key"
convert_clean_root_to_old_layout "$failure_root" octo-failure-agents "$failure_agents_old_key"
convert_clean_root_to_old_layout "$failure_root" miri-failure-canvas "$failure_canvas_old_key"
failure_agents_old_task=$(replace_prefix "$(value "$failure_agents_task" task_path)" "$failure_agents_clean" "$failure_agents_old_root")
failure_before=$(snapshot_tree "$failure_root")
fake_mv_bin="$temporary_root/fake-mv"
mkdir "$fake_mv_bin"
cat > "$fake_mv_bin/mv" <<'EOF'
#!/bin/sh
case "${2:-}" in
  "${SB_NOTES_BACKUP_ROOT:-}"/.sb-notes-layout-transaction.*/backup/*) printf '%s\n' "$1" >> "${SB_NOTES_MV_LOG:?}" ;;
esac
if [ "${1:-}" = "${SB_NOTES_FAIL_MV_SOURCE:-}" ]; then
  exit 1
fi
case "${1:-}" in
  "${SB_NOTES_FAIL_FINAL_BACKUP_ROOT:-}"/.sb-notes-layout-transaction.*/backup) exit 1 ;;
esac
exec /bin/mv "$@"
EOF
chmod 700 "$fake_mv_bin/mv"
failure_mv_log="$temporary_root/failure-backup-moves"
if PATH="$fake_mv_bin:$PATH" SB_NOTES_ROOT="$failure_root" SB_NOTES_BACKUP_ROOT="$failure_root" SB_NOTES_MV_LOG="$failure_mv_log" SB_NOTES_FAIL_MV_SOURCE="$failure_agents_old_root" "$helper" migrate-layout --execute >/dev/null 2>&1; then fail 'partial backup I/O failure unexpectedly succeeded'; fi
[ "$(cat "$failure_mv_log")" = "$(printf '%s\n%s' "$failure_canvas_old_root" "$failure_agents_old_root")" ] || fail 'partial backup failure did not occur on the intended second legacy-root move'
[ "$failure_before" = "$(snapshot_tree "$failure_root")" ] || fail 'partial backup failure did not restore the complete old layout'
if PATH="$fake_mv_bin:$PATH" SB_NOTES_ROOT="$failure_root" SB_NOTES_FAIL_FINAL_BACKUP_ROOT="$failure_root" "$helper" migrate-layout --execute >/dev/null 2>&1; then fail 'final backup I/O failure unexpectedly succeeded'; fi
[ ! -e "$failure_agents_old_root" ] && [ ! -e "$failure_canvas_old_root" ] || fail 'final backup failure did not retain the clean authority'
SB_NOTES_ROOT="$failure_root" "$helper" resolve --task-path "$(replace_prefix "$failure_agents_old_task" "$failure_agents_old_root" "$failure_agents_clean")" >/dev/null
[ "$(SB_NOTES_ROOT="$failure_root" "$helper" migrate-layout --execute)" = 'migration=not-needed' ] || fail 'recovery after final backup failure was not a no-op'

recovery_root="$temporary_root/startup-recovery"
recovery_repo="$temporary_root/startup-recovery-source"
create_repo "$recovery_repo"
git -C "$recovery_repo" remote add origin 'git@personal:octo/startup-recovery.git'
recovery_init=$(cd "$recovery_repo" && SB_NOTES_ROOT="$recovery_root" "$helper" init --task-id startup --title startup)
recovery_clean_root="$recovery_root/octo-startup-recovery"
recovery_old_key='octo-startup-recovery-999999999999'
recovery_old_root="$recovery_root/$recovery_old_key"
recovery_task=$(value "$recovery_init" task_path)
convert_clean_root_to_old_layout "$recovery_root" octo-startup-recovery "$recovery_old_key"
recovery_old_task=$(replace_prefix "$recovery_task" "$recovery_clean_root" "$recovery_old_root")
recovery_identity=$(metadata_value "$recovery_old_task" repo_canonical_identity)
copy_old_root_as_clean_layout "$recovery_old_root" "$recovery_clean_root" "$recovery_old_key" octo-startup-recovery
recovery_transaction="$recovery_root/.sb-notes-layout-transaction.prebuilt-finish"
mkdir "$recovery_transaction" "$recovery_transaction/backup" "$recovery_transaction/mappings"
mv "$recovery_old_root" "$recovery_transaction/backup/$recovery_old_key"
recovery_final_backup="$recovery_root/.sb-notes-layout-backup-prebuilt-finish"
write_transaction_manifest "$recovery_transaction" "$recovery_final_backup" validated
write_transaction_mapping "$recovery_transaction" "$recovery_old_root" "$recovery_clean_root" "$recovery_transaction/backup/$recovery_old_key" "$recovery_identity" "$recovery_old_key" octo-startup-recovery
(
  exit 0
) &
stale_layout_owner=$!
wait "$stale_layout_owner"
fake_process_bin="$temporary_root/fake-process"
mkdir "$fake_process_bin"
cat > "$fake_process_bin/ps" <<'EOF'
#!/bin/sh
exit 1
EOF
chmod 700 "$fake_process_bin/ps"
recovery_layout_lock="$recovery_root/.sb-notes-layout.lock"
printf '%s\n' "$stale_layout_owner" > "$recovery_layout_lock"
[ "$(PATH="$fake_process_bin:$PATH" SB_NOTES_ROOT="$recovery_root" "$helper" migrate-layout --execute)" = 'migration=not-needed' ] || fail 'stale lock did not recover a populated validated transaction'
[ ! -e "$recovery_transaction" ] && [ -d "$recovery_final_backup/$recovery_old_key" ] && [ ! -e "$recovery_old_root" ] || fail 'startup recovery lost its durable backup or left a transaction'
 [ ! -e "$recovery_layout_lock" ] || fail 'stale layout lock remained after populated transaction recovery'
SB_NOTES_ROOT="$recovery_root" "$helper" resolve --task-path "$(replace_prefix "$recovery_old_task" "$recovery_old_root" "$recovery_clean_root")" >/dev/null

premanifest_root="$temporary_root/pre-manifest-recovery"
premanifest_init=$(cd "$canvas_repo" && SB_NOTES_ROOT="$premanifest_root" "$helper" init --task-id premanifest --title premanifest)
premanifest_clean="$premanifest_root/miri-canvas"
premanifest_old='miri-canvas-999999999998'
premanifest_old_root="$premanifest_root/$premanifest_old"
convert_clean_root_to_old_layout "$premanifest_root" miri-canvas "$premanifest_old"
premanifest_before=$(snapshot_tree "$premanifest_root")
premanifest_transaction="$premanifest_root/.sb-notes-layout-transaction.pre-manifest"
mkdir "$premanifest_transaction" "$premanifest_transaction/staged" "$premanifest_transaction/backup" "$premanifest_transaction/failed" "$premanifest_transaction/mappings"
mkdir "$premanifest_transaction/staged/partial-copy"
printf '%s\n' partial > "$premanifest_transaction/staged/partial-copy/metadata.env"
printf '%s\n' temporary > "$premanifest_transaction/.manifest.env.interrupted"
printf '%s\n' temporary > "$premanifest_transaction/mappings/.1.interrupted"
SB_NOTES_ROOT="$premanifest_root" "$helper" migrate-layout --dry-run >/dev/null
[ "$premanifest_before" = "$(snapshot_tree "$premanifest_root")" ] && [ ! -e "$premanifest_transaction" ] || fail 'pre-manifest remnants stranded or changed the old authority'

prepared_mapping_root="$temporary_root/prepared-mapping-recovery"
prepared_mapping_init=$(cd "$canvas_repo" && SB_NOTES_ROOT="$prepared_mapping_root" "$helper" init --task-id prepared-mapping --title prepared-mapping)
prepared_mapping_clean="$prepared_mapping_root/miri-canvas"
prepared_mapping_old_key='miri-canvas-999999999997'
prepared_mapping_old_root="$prepared_mapping_root/$prepared_mapping_old_key"
convert_clean_root_to_old_layout "$prepared_mapping_root" miri-canvas "$prepared_mapping_old_key"
prepared_mapping_old_task=$(replace_prefix "$(value "$prepared_mapping_init" task_path)" "$prepared_mapping_clean" "$prepared_mapping_old_root")
prepared_mapping_identity=$(metadata_value "$prepared_mapping_old_task" repo_canonical_identity)
prepared_mapping_before=$(snapshot_tree "$prepared_mapping_root")
prepared_mapping_transaction="$prepared_mapping_root/.sb-notes-layout-transaction.prepared-mapping"
mkdir "$prepared_mapping_transaction" "$prepared_mapping_transaction/staged" "$prepared_mapping_transaction/backup" "$prepared_mapping_transaction/failed" "$prepared_mapping_transaction/mappings"
write_transaction_manifest "$prepared_mapping_transaction" "$prepared_mapping_root/.sb-notes-layout-backup-prepared-mapping" prepared
{
  printf 'old_root=%s\n' "$prepared_mapping_old_root"
  printf 'clean_root=%s\n' "$prepared_mapping_clean"
  printf 'stage_root=%s\n' "$prepared_mapping_transaction/staged/miri-canvas"
  printf 'backup_root=%s\n' "$prepared_mapping_transaction/backup/$prepared_mapping_old_key"
  printf 'canonical_identity=%s\n' "$prepared_mapping_identity"
  printf 'old_repo_key=%s\n' "$prepared_mapping_old_key"
  printf '%s\n' 'clean_repo_key=miri-canvas'
  printf 'reservation_token=%s\n' "$prepared_mapping_root/.sb-notes-layout-reservation-$(basename "$prepared_mapping_transaction")-miri-canvas"
  printf '%s\n' 'published=no'
} > "$prepared_mapping_transaction/mappings/.1.interrupted"
SB_NOTES_ROOT="$prepared_mapping_root" "$helper" migrate-layout --dry-run >/dev/null
[ "$prepared_mapping_before" = "$(snapshot_tree "$prepared_mapping_root")" ] && [ ! -e "$prepared_mapping_transaction" ] || fail 'prepared manifest with only a first hidden mapping temporary did not restore the old authority'

token_root="$temporary_root/reservation-token-recovery"
token_init=$(cd "$canvas_repo" && SB_NOTES_ROOT="$token_root" "$helper" init --task-id token --title token)
token_clean_root="$token_root/miri-canvas"
token_old_key='miri-canvas-999999999997'
token_old_root="$token_root/$token_old_key"
convert_clean_root_to_old_layout "$token_root" miri-canvas "$token_old_key"
token_old_task=$(replace_prefix "$(value "$token_init" task_path)" "$token_clean_root" "$token_old_root")
token_identity=$(metadata_value "$token_old_task" repo_canonical_identity)
token_before=$(snapshot_tree "$token_root")
token_transaction="$token_root/.sb-notes-layout-transaction.after-token"
mkdir "$token_transaction" "$token_transaction/backup" "$token_transaction/failed" "$token_transaction/mappings"
write_transaction_manifest "$token_transaction" "$token_root/.sb-notes-layout-backup-after-token" publishing
write_transaction_mapping "$token_transaction" "$token_old_root" "$token_clean_root" "$token_transaction/backup/$token_old_key" "$token_identity" "$token_old_key" miri-canvas no
write_reservation_token "$token_transaction" "$token_clean_root" miri-canvas
SB_NOTES_ROOT="$token_root" "$helper" migrate-layout --dry-run >/dev/null
[ "$token_before" = "$(snapshot_tree "$token_root")" ] && [ ! -e "$token_transaction" ] && [ ! -e "$token_root"/.sb-notes-layout-reservation-* ] || fail 'token-only destination reservation did not self-recover'

empty_destination_root="$temporary_root/reservation-empty-destination"
empty_destination_init=$(cd "$canvas_repo" && SB_NOTES_ROOT="$empty_destination_root" "$helper" init --task-id empty-destination --title empty-destination)
empty_destination_clean="$empty_destination_root/miri-canvas"
empty_destination_old_key='miri-canvas-999999999996'
empty_destination_old_root="$empty_destination_root/$empty_destination_old_key"
convert_clean_root_to_old_layout "$empty_destination_root" miri-canvas "$empty_destination_old_key"
empty_destination_old_task=$(replace_prefix "$(value "$empty_destination_init" task_path)" "$empty_destination_clean" "$empty_destination_old_root")
empty_destination_identity=$(metadata_value "$empty_destination_old_task" repo_canonical_identity)
empty_destination_before=$(snapshot_tree "$empty_destination_root")
empty_destination_transaction="$empty_destination_root/.sb-notes-layout-transaction.after-empty-mkdir"
mkdir "$empty_destination_transaction" "$empty_destination_transaction/backup" "$empty_destination_transaction/failed" "$empty_destination_transaction/mappings"
write_transaction_manifest "$empty_destination_transaction" "$empty_destination_root/.sb-notes-layout-backup-after-empty-mkdir" publishing
write_transaction_mapping "$empty_destination_transaction" "$empty_destination_old_root" "$empty_destination_clean" "$empty_destination_transaction/backup/$empty_destination_old_key" "$empty_destination_identity" "$empty_destination_old_key" miri-canvas no
write_reservation_token "$empty_destination_transaction" "$empty_destination_clean" miri-canvas
mkdir "$empty_destination_clean"
SB_NOTES_ROOT="$empty_destination_root" "$helper" migrate-layout --dry-run >/dev/null
[ "$empty_destination_before" = "$(snapshot_tree "$empty_destination_root")" ] && [ ! -e "$empty_destination_transaction" ] && [ ! -e "$empty_destination_clean" ] || fail 'owned empty destination was not safely removed after interrupted mkdir'

fake_sleep_bin="$temporary_root/fake-sleep"
mkdir "$fake_sleep_bin"
cat > "$fake_sleep_bin/sleep" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod 700 "$fake_sleep_bin/sleep"
fake_ps_error_bin="$temporary_root/fake-ps-error"
mkdir "$fake_ps_error_bin"
cat > "$fake_ps_error_bin/ps" <<'EOF'
#!/bin/sh
printf '%s\n' 'ps transport error' >&2
exit 2
EOF
chmod 700 "$fake_ps_error_bin/ps"
ps_error_lock_root="$temporary_root/ps-error-layout-lock"
mkdir "$ps_error_lock_root"
printf '%s\n' "$stale_layout_owner" > "$ps_error_lock_root/.sb-notes-layout.lock"
if PATH="$fake_ps_error_bin:$fake_sleep_bin:$PATH" SB_NOTES_ROOT="$ps_error_lock_root" "$helper" migrate-layout --dry-run >/dev/null 2>&1; then fail 'layout lock with ps error unexpectedly reclaimed'; fi
[ -f "$ps_error_lock_root/.sb-notes-layout.lock" ] || fail 'layout lock with ps error was stolen'
malformed_lock_root="$temporary_root/malformed-layout-lock"
mkdir "$malformed_lock_root"
printf '%s\n' malformed > "$malformed_lock_root/.sb-notes-layout.lock"
if PATH="$fake_sleep_bin:$PATH" SB_NOTES_ROOT="$malformed_lock_root" "$helper" migrate-layout --dry-run >/dev/null 2>&1; then fail 'malformed layout lock unexpectedly reclaimed'; fi
[ -f "$malformed_lock_root/.sb-notes-layout.lock" ] || fail 'malformed layout lock was stolen'
missing_lock_root="$temporary_root/missing-layout-lock"
mkdir "$missing_lock_root"
: > "$missing_lock_root/.sb-notes-layout.lock"
if PATH="$fake_sleep_bin:$PATH" SB_NOTES_ROOT="$missing_lock_root" "$helper" migrate-layout --dry-run >/dev/null 2>&1; then fail 'missing-owner layout lock unexpectedly reclaimed'; fi
[ -f "$missing_lock_root/.sb-notes-layout.lock" ] || fail 'missing-owner layout lock was stolen'
live_lock_root="$temporary_root/live-layout-lock"
mkdir "$live_lock_root"
printf '%s\n' "$$" > "$live_lock_root/.sb-notes-layout.lock"
if PATH="$fake_sleep_bin:$PATH" SB_NOTES_ROOT="$live_lock_root" "$helper" migrate-layout --dry-run >/dev/null 2>&1; then fail 'live layout lock unexpectedly reclaimed'; fi
[ -f "$live_lock_root/.sb-notes-layout.lock" ] || fail 'live layout lock was stolen'

aba_root="$temporary_root/layout-lock-aba"
mkdir "$aba_root"
(
  exit 0
) &
aba_stale_owner=$!
wait "$aba_stale_owner"
aba_lock="$aba_root/.sb-notes-layout.lock"
aba_reclaimer="$aba_lock.reclaim"
printf '%s\n' "$aba_stale_owner" > "$aba_lock"
fake_aba_bin="$temporary_root/fake-layout-aba"
mkdir "$fake_aba_bin"
cat > "$fake_aba_bin/ps" <<'EOF'
#!/bin/sh
exit 1
EOF
cat > "$fake_aba_bin/rm" <<'EOF'
#!/bin/sh
for argument do
  if [ -n "${SB_NOTES_ABA_RM_PAUSED:-}" ] && [ "$argument" = "${SB_NOTES_ABA_LOCK_PATH:-}" ] && [ ! -e "$SB_NOTES_ABA_RM_PAUSED" ]; then
    : > "${SB_NOTES_ABA_RM_PAUSED:?}"
    while [ ! -f "${SB_NOTES_ABA_RM_RELEASE:?}" ]; do /bin/sleep 1; done
    break
  fi
done
exec /bin/rm "$@"
EOF
cat > "$fake_aba_bin/ln" <<'EOF'
#!/bin/sh
if [ "${2:-}" = "${SB_NOTES_ABA_LOCK_PATH:-}" ]; then
  /bin/ln "$@"
  status=$?
  if [ "$status" = 0 ]; then
    case "${SB_NOTES_ABA_ROLE:-}" in
      reclaimer-a)
        : > "${SB_NOTES_ABA_A_HELD:?}"
        while [ ! -f "${SB_NOTES_ABA_A_RELEASE:?}" ]; do /bin/sleep 1; done
        ;;
      contender-b)
        : > "${SB_NOTES_ABA_B_ACQUIRED:?}"
        while [ ! -f "${SB_NOTES_ABA_B_RELEASE:?}" ]; do /bin/sleep 1; done
        ;;
    esac
  fi
  exit "$status"
fi
exec /bin/ln "$@"
EOF
cat > "$fake_aba_bin/sleep" <<'EOF'
#!/bin/sh
if [ -e "${SB_NOTES_ABA_RECLAIMER_PATH:-}" ] && [ -n "${SB_NOTES_ABA_B_WAITING:-}" ]; then
  : > "$SB_NOTES_ABA_B_WAITING"
fi
exec /bin/sleep "$@"
EOF
chmod 700 "$fake_aba_bin/ps" "$fake_aba_bin/rm" "$fake_aba_bin/ln" "$fake_aba_bin/sleep"
aba_rm_paused="$temporary_root/aba-rm-paused"
aba_rm_release="$temporary_root/aba-rm-release"
aba_a_held="$temporary_root/aba-a-held"
aba_a_release="$temporary_root/aba-a-release"
aba_b_waiting="$temporary_root/aba-b-waiting"
aba_b_acquired="$temporary_root/aba-b-acquired"
aba_b_release="$temporary_root/aba-b-release"
PATH="$fake_aba_bin:$PATH" SB_NOTES_ROOT="$aba_root" SB_NOTES_ABA_LOCK_PATH="$aba_lock" SB_NOTES_ABA_RM_PAUSED="$aba_rm_paused" SB_NOTES_ABA_RM_RELEASE="$aba_rm_release" SB_NOTES_ABA_A_HELD="$aba_a_held" SB_NOTES_ABA_A_RELEASE="$aba_a_release" SB_NOTES_ABA_ROLE=reclaimer-a "$helper" migrate-layout --dry-run > "$temporary_root/aba-a.out" 2>&1 &
aba_a_pid=$!
aba_attempt=0
while [ ! -f "$aba_rm_paused" ] && [ "$aba_attempt" -lt 10 ]; do sleep 1; aba_attempt=$((aba_attempt + 1)); done
[ -f "$aba_rm_paused" ] && [ -e "$aba_reclaimer" ] || fail 'first stale reclaimer did not hold an exclusive election'
PATH="$fake_aba_bin:$PATH" SB_NOTES_ROOT="$aba_root" SB_NOTES_ABA_LOCK_PATH="$aba_lock" SB_NOTES_ABA_RECLAIMER_PATH="$aba_reclaimer" SB_NOTES_ABA_B_WAITING="$aba_b_waiting" SB_NOTES_ABA_B_ACQUIRED="$aba_b_acquired" SB_NOTES_ABA_B_RELEASE="$aba_b_release" SB_NOTES_ABA_ROLE=contender-b "$helper" migrate-layout --dry-run > "$temporary_root/aba-b.out" 2>&1 &
aba_b_pid=$!
aba_attempt=0
while [ ! -f "$aba_b_waiting" ] && [ "$aba_attempt" -lt 10 ]; do sleep 1; aba_attempt=$((aba_attempt + 1)); done
[ -f "$aba_b_waiting" ] && [ ! -s "$temporary_root/aba-a.out" ] && [ ! -s "$temporary_root/aba-b.out" ] && [ ! -e "$aba_b_acquired" ] || fail 'a second stale reclaimer bypassed the active election'
touch "$aba_rm_release"
aba_attempt=0
while [ ! -f "$aba_a_held" ] && [ "$aba_attempt" -lt 10 ]; do sleep 1; aba_attempt=$((aba_attempt + 1)); done
[ -f "$aba_a_held" ] && [ -f "$aba_lock" ] && [ ! -e "$aba_b_acquired" ] || fail 'the contender acquired the layout lock while the elected reclaimer held it'
touch "$aba_a_release"
wait "$aba_a_pid" || fail 'elected stale reclaimer did not complete'
aba_attempt=0
while [ ! -f "$aba_b_acquired" ] && [ "$aba_attempt" -lt 10 ]; do sleep 1; aba_attempt=$((aba_attempt + 1)); done
[ -f "$aba_b_acquired" ] && [ -f "$aba_lock" ] || fail 'owner-aware release removed the contender successor lock'
touch "$aba_b_release"
if ! wait "$aba_b_pid"; then
  printf '%s\n' 'ABA contender output:' >&2
  cat "$temporary_root/aba-b.out" >&2 || true
  if [ -f "$aba_lock" ]; then
    printf '%s\n' 'ABA remaining lock:' >&2
    cat "$aba_lock" >&2 || true
  fi
  [ ! -e "$aba_reclaimer" ] || printf '%s\n' "ABA remaining reclaimer=$aba_reclaimer" >&2
  fail 'contender did not complete after elected reclaimer release'
fi
[ "$(cat "$temporary_root/aba-a.out")" = 'migration=dry-run' ] && [ "$(cat "$temporary_root/aba-b.out")" = 'migration=dry-run' ] && [ -e "$aba_b_acquired" ] && [ ! -e "$aba_lock" ] && [ ! -e "$aba_reclaimer" ] || fail 'layout lock ABA recovery removed a successor lock or overlapped critical sections'

ownership_release_root="$temporary_root/layout-lock-owner-release"
mkdir "$ownership_release_root"
ownership_release_lock="$ownership_release_root/.sb-notes-layout.lock"
fake_ownership_release_bin="$temporary_root/fake-layout-owner-release"
mkdir "$fake_ownership_release_bin"
cat > "$fake_ownership_release_bin/ln" <<'EOF'
#!/bin/sh
if [ "${2:-}" = "${SB_NOTES_OWNER_RELEASE_LOCK_PATH:-}" ]; then
  /bin/ln "$@"
  status=$?
  if [ "$status" = 0 ]; then
    case "${SB_NOTES_OWNER_RELEASE_ROLE:-}" in
      owner-a)
        : > "${SB_NOTES_OWNER_RELEASE_A_READY:?}"
        while [ ! -f "${SB_NOTES_OWNER_RELEASE_A_CONTINUE:?}" ]; do /bin/sleep 1; done
        ;;
      successor-b)
        : > "${SB_NOTES_OWNER_RELEASE_B_READY:?}"
        while [ ! -f "${SB_NOTES_OWNER_RELEASE_B_CONTINUE:?}" ]; do /bin/sleep 1; done
        ;;
    esac
  fi
  exit "$status"
fi
exec /bin/ln "$@"
EOF
chmod 700 "$fake_ownership_release_bin/ln"
ownership_release_a_ready="$temporary_root/owner-release-a-ready"
ownership_release_a_continue="$temporary_root/owner-release-a-continue"
ownership_release_b_ready="$temporary_root/owner-release-b-ready"
ownership_release_b_continue="$temporary_root/owner-release-b-continue"
ownership_release_a_record="$temporary_root/owner-release-a-lock"
PATH="$fake_ownership_release_bin:$PATH" SB_NOTES_ROOT="$ownership_release_root" SB_NOTES_OWNER_RELEASE_LOCK_PATH="$ownership_release_lock" SB_NOTES_OWNER_RELEASE_ROLE=owner-a SB_NOTES_OWNER_RELEASE_A_READY="$ownership_release_a_ready" SB_NOTES_OWNER_RELEASE_A_CONTINUE="$ownership_release_a_continue" "$helper" migrate-layout --dry-run > "$temporary_root/owner-release-a.out" 2>&1 &
ownership_release_a_pid=$!
ownership_release_attempt=0
while [ ! -f "$ownership_release_a_ready" ] && [ "$ownership_release_attempt" -lt 10 ]; do sleep 1; ownership_release_attempt=$((ownership_release_attempt + 1)); done
[ -f "$ownership_release_a_ready" ] && [ -f "$ownership_release_lock" ] || fail 'owner lock was not published before owner-release fault injection'
cp "$ownership_release_lock" "$ownership_release_a_record"
/bin/rm -f "$ownership_release_lock"
PATH="$fake_ownership_release_bin:$PATH" SB_NOTES_ROOT="$ownership_release_root" SB_NOTES_OWNER_RELEASE_LOCK_PATH="$ownership_release_lock" SB_NOTES_OWNER_RELEASE_ROLE=successor-b SB_NOTES_OWNER_RELEASE_B_READY="$ownership_release_b_ready" SB_NOTES_OWNER_RELEASE_B_CONTINUE="$ownership_release_b_continue" "$helper" migrate-layout --dry-run > "$temporary_root/owner-release-b.out" 2>&1 &
ownership_release_b_pid=$!
ownership_release_attempt=0
while [ ! -f "$ownership_release_b_ready" ] && [ "$ownership_release_attempt" -lt 10 ]; do sleep 1; ownership_release_attempt=$((ownership_release_attempt + 1)); done
[ -f "$ownership_release_b_ready" ] && [ -f "$ownership_release_lock" ] && ! cmp -s "$ownership_release_a_record" "$ownership_release_lock" || fail 'external replacement did not publish a distinct successor lock token'
touch "$ownership_release_a_continue"
wait "$ownership_release_a_pid" || fail 'owner did not complete cleanup after its lock path was externally replaced'
[ -f "$ownership_release_lock" ] && ! cmp -s "$ownership_release_a_record" "$ownership_release_lock" || fail 'ownership-aware release removed the successor lock'
touch "$ownership_release_b_continue"
wait "$ownership_release_b_pid" || fail 'successor did not complete after its lock was preserved'
[ "$(cat "$temporary_root/owner-release-a.out")" = 'migration=dry-run' ] && [ "$(cat "$temporary_root/owner-release-b.out")" = 'migration=dry-run' ] && [ ! -e "$ownership_release_lock" ] || fail 'successor lock was not released by its matching owner'

rollback_root="$temporary_root/startup-rollback"
rollback_repo="$temporary_root/startup-rollback-source"
create_repo "$rollback_repo"
git -C "$rollback_repo" remote add origin 'git@personal:octo/startup-rollback.git'
rollback_init=$(cd "$rollback_repo" && SB_NOTES_ROOT="$rollback_root" "$helper" init --task-id rollback --title rollback)
rollback_clean_root="$rollback_root/octo-startup-rollback"
rollback_old_key='octo-startup-rollback-aaaaaaaaaaaa'
rollback_old_root="$rollback_root/$rollback_old_key"
convert_clean_root_to_old_layout "$rollback_root" octo-startup-rollback "$rollback_old_key"
rollback_old_task=$(replace_prefix "$(value "$rollback_init" task_path)" "$rollback_clean_root" "$rollback_old_root")
rollback_identity=$(metadata_value "$rollback_old_task" repo_canonical_identity)
rollback_before=$(snapshot_tree "$rollback_root")
copy_old_root_as_clean_layout "$rollback_old_root" "$rollback_clean_root" "$rollback_old_key" octo-startup-rollback
rollback_transaction="$rollback_root/.sb-notes-layout-transaction.prebuilt-rollback"
mkdir "$rollback_transaction" "$rollback_transaction/failed" "$rollback_transaction/mappings"
rollback_final_backup="$rollback_root/.sb-notes-layout-backup-prebuilt-rollback"
write_transaction_manifest "$rollback_transaction" "$rollback_final_backup" publishing
write_transaction_mapping "$rollback_transaction" "$rollback_old_root" "$rollback_clean_root" "$rollback_transaction/backup/$rollback_old_key" "$rollback_identity" "$rollback_old_key" octo-startup-rollback
SB_NOTES_ROOT="$rollback_root" "$helper" migrate-layout --dry-run >/dev/null
[ "$rollback_before" = "$(snapshot_tree "$rollback_root")" ] && [ ! -e "$rollback_clean_root" ] && [ ! -e "$rollback_transaction" ] || fail 'startup recovery did not restore the complete old layout before a new migration'

race_root="$temporary_root/publish-race"
race_repo="$temporary_root/publish-race-source"
create_repo "$race_repo"
git -C "$race_repo" remote add origin 'git@personal:octo/publish-race.git'
race_init=$(cd "$race_repo" && SB_NOTES_ROOT="$race_root" "$helper" init --task-id race --title race)
race_clean_root="$race_root/octo-publish-race"
race_old_key='octo-publish-race-bbbbbbbbbbbb'
race_old_root="$race_root/$race_old_key"
convert_clean_root_to_old_layout "$race_root" octo-publish-race "$race_old_key"
race_old_before=$(snapshot_tree "$race_old_root")
fake_mkdir_bin="$temporary_root/fake-mkdir"
mkdir "$fake_mkdir_bin"
cat > "$fake_mkdir_bin/mkdir" <<'EOF'
#!/bin/sh
if [ "$#" = 1 ] && [ "$1" = "${SB_NOTES_RACE_DESTINATION:-}" ]; then
  /bin/mkdir "$1"
  printf '%s\n' 'external destination sentinel' > "$1/external-sentinel"
  exit 1
fi
exec /bin/mkdir "$@"
EOF
chmod 700 "$fake_mkdir_bin/mkdir"
if PATH="$fake_mkdir_bin:$PATH" SB_NOTES_ROOT="$race_root" SB_NOTES_RACE_DESTINATION="$race_clean_root" "$helper" migrate-layout --execute >/dev/null 2>&1; then fail 'destination reservation race unexpectedly succeeded'; fi
[ "$race_old_before" = "$(snapshot_tree "$race_old_root")" ] || fail 'destination race changed the old authority'
[ "$(cat "$race_clean_root/external-sentinel")" = 'external destination sentinel' ] || fail 'destination race overwrote the externally reserved directory'
[ -d "$race_root/.sb-notes-layout-transaction."* ] || fail 'destination race discarded an unowned collision transaction'

fake_cp_bin="$temporary_root/fake-cp"
mkdir "$fake_cp_bin"
cat > "$fake_cp_bin/cp" <<'EOF'
#!/bin/sh
for argument do
  if [ "$argument" = "${SB_NOTES_PAUSE_CP_SOURCE:-}/." ]; then
    : > "${SB_NOTES_PAUSE_CP_READY:?}"
    while [ ! -f "${SB_NOTES_PAUSE_CP_RELEASE:?}" ]; do sleep 1; done
    break
  fi
done
exec /bin/cp "$@"
EOF
chmod 700 "$fake_cp_bin/cp"

fake_layout_ln_bin="$temporary_root/fake-layout-ln"
mkdir "$fake_layout_ln_bin"
cat > "$fake_layout_ln_bin/ln" <<'EOF'
#!/bin/sh
if [ "${2:-}" = "${SB_NOTES_LAYOUT_LOCK_PATH:-}" ] && [ -e "$2" ] && [ -n "${SB_NOTES_LAYOUT_LOCK_READY:-}" ]; then
  : > "$SB_NOTES_LAYOUT_LOCK_READY"
fi
exec /bin/ln "$@"
EOF
chmod 700 "$fake_layout_ln_bin/ln"

quiescence_root="$temporary_root/quiescence"
quiescence_repo="$temporary_root/quiescence-source"
create_repo "$quiescence_repo"
git -C "$quiescence_repo" remote add origin 'git@personal:octo/quiescence.git'
quiescence_init=$(cd "$quiescence_repo" && SB_NOTES_ROOT="$quiescence_root" "$helper" init --task-id held-migration --title held-migration)
quiescence_clean_root="$quiescence_root/octo-quiescence"
quiescence_old_key='octo-quiescence-cccccccccccc'
quiescence_old_root="$quiescence_root/$quiescence_old_key"
quiescence_old_task=$(replace_prefix "$(value "$quiescence_init" task_path)" "$quiescence_clean_root" "$quiescence_old_root")
quiescence_old_state="$quiescence_old_task/state.md"
convert_clean_root_to_old_layout "$quiescence_root" octo-quiescence "$quiescence_old_key"
quiescence_ready="$temporary_root/quiescence-ready"
quiescence_release="$temporary_root/quiescence-release"
PATH="$fake_cp_bin:$PATH" SB_NOTES_ROOT="$quiescence_root" SB_NOTES_PAUSE_CP_SOURCE="$quiescence_old_root" SB_NOTES_PAUSE_CP_READY="$quiescence_ready" SB_NOTES_PAUSE_CP_RELEASE="$quiescence_release" "$helper" migrate-layout --execute > "$temporary_root/quiescence-migration.out" 2>&1 &
quiescence_migration_pid=$!
quiescence_attempt=0
while [ ! -f "$quiescence_ready" ] && [ "$quiescence_attempt" -lt 10 ]; do sleep 1; quiescence_attempt=$((quiescence_attempt + 1)); done
[ -f "$quiescence_ready" ] || fail 'migration did not pause at the staged copy'
artifact_source="$temporary_root/quiescence-artifact.txt"
printf '%s\n' artifact > "$artifact_source"
quiescence_lock_path="$quiescence_root/.sb-notes-layout.lock"
quiescence_checkpoint_ready="$temporary_root/quiescence-checkpoint-ready"
quiescence_state_ready="$temporary_root/quiescence-state-ready"
quiescence_artifact_ready="$temporary_root/quiescence-artifact-ready"
quiescence_init_ready="$temporary_root/quiescence-init-ready"
quiescence_replacement="$temporary_root/quiescence-replacement-state.md"
sed 's/^status: "initialized"/status: "blocked-write"/' "$quiescence_old_state" > "$quiescence_replacement"
PATH="$fake_layout_ln_bin:$PATH" SB_NOTES_LAYOUT_LOCK_PATH="$quiescence_lock_path" SB_NOTES_LAYOUT_LOCK_READY="$quiescence_checkpoint_ready" SB_NOTES_ROOT="$quiescence_root" "$helper" checkpoint --task-path "$quiescence_old_task" --kind verification --actor worker --input-sha held --output-sha held --file "$checkpoint_body" > "$temporary_root/quiescence-checkpoint.out" 2>&1 &
quiescence_checkpoint_pid=$!
PATH="$fake_layout_ln_bin:$PATH" SB_NOTES_LAYOUT_LOCK_PATH="$quiescence_lock_path" SB_NOTES_LAYOUT_LOCK_READY="$quiescence_state_ready" SB_NOTES_ROOT="$quiescence_root" "$helper" replace-state --task-path "$quiescence_old_task" --expected-hash "$(hash_file "$quiescence_old_state")" --file "$quiescence_replacement" > "$temporary_root/quiescence-state.out" 2>&1 &
quiescence_state_pid=$!
PATH="$fake_layout_ln_bin:$PATH" SB_NOTES_LAYOUT_LOCK_PATH="$quiescence_lock_path" SB_NOTES_LAYOUT_LOCK_READY="$quiescence_artifact_ready" SB_NOTES_ROOT="$quiescence_root" "$helper" artifact --task-path "$quiescence_old_task" --name held-write --path "$artifact_source" > "$temporary_root/quiescence-artifact.out" 2>&1 &
quiescence_artifact_pid=$!
(
  cd "$quiescence_repo"
  PATH="$fake_layout_ln_bin:$PATH" SB_NOTES_LAYOUT_LOCK_PATH="$quiescence_lock_path" SB_NOTES_LAYOUT_LOCK_READY="$quiescence_init_ready" SB_NOTES_ROOT="$quiescence_root" "$helper" init --task-id created-after-migration --title created-after-migration
) > "$temporary_root/quiescence-init.out" 2>&1 &
quiescence_init_pid=$!
for readiness_file in "$quiescence_checkpoint_ready" "$quiescence_state_ready" "$quiescence_artifact_ready" "$quiescence_init_ready"; do
  readiness_attempt=0
  while [ ! -f "$readiness_file" ] && [ "$readiness_attempt" -lt 10 ]; do sleep 1; readiness_attempt=$((readiness_attempt + 1)); done
  [ -f "$readiness_file" ] || fail "public contender did not reach the held layout lock: $readiness_file"
done
if [ ! -s "$temporary_root/quiescence-checkpoint.out" ] && [ ! -s "$temporary_root/quiescence-state.out" ] && [ ! -s "$temporary_root/quiescence-artifact.out" ] && [ ! -s "$temporary_root/quiescence-init.out" ] && [ ! -e "$quiescence_clean_root" ]; then :; else
  for quiescence_output in "$temporary_root/quiescence-checkpoint.out" "$temporary_root/quiescence-state.out" "$temporary_root/quiescence-artifact.out" "$temporary_root/quiescence-init.out"; do
    [ ! -s "$quiescence_output" ] || cat "$quiescence_output" >&2
  done
  fail 'a public operation bypassed the held layout lock'
fi
touch "$quiescence_release"
wait "$quiescence_migration_pid" || fail 'paused migration did not complete'
if wait "$quiescence_checkpoint_pid"; then fail 'checkpoint writer against retired task path unexpectedly succeeded'; fi
if wait "$quiescence_state_pid"; then fail 'state writer against retired task path unexpectedly succeeded'; fi
if wait "$quiescence_artifact_pid"; then fail 'writer against retired task path unexpectedly succeeded'; fi
wait "$quiescence_init_pid" || fail 'init did not resume after migration completed'
quiescence_new_task=$(new_value_for_old "$(cat "$temporary_root/quiescence-migration.out")" old_task_path "$quiescence_old_task" new_task_path)
[ -n "$quiescence_new_task" ] && [ ! -d "$quiescence_new_task/artifacts" ] && [ ! -d "$quiescence_new_task/checkpoints" ] && [ ! -e "$quiescence_old_root" ] || fail 'layout-lock quiescence stranded a writer or legacy root'

term_root="$temporary_root/term-recovery"
term_repo="$temporary_root/term-recovery-source"
create_repo "$term_repo"
git -C "$term_repo" remote add origin 'git@personal:octo/term-recovery.git'
term_init=$(cd "$term_repo" && SB_NOTES_ROOT="$term_root" "$helper" init --task-id term --title term)
term_clean_root="$term_root/octo-term-recovery"
term_old_key='octo-term-recovery-dddddddddddd'
term_old_root="$term_root/$term_old_key"
convert_clean_root_to_old_layout "$term_root" octo-term-recovery "$term_old_key"
term_before=$(snapshot_tree "$term_root")
term_ready="$temporary_root/term-ready"
term_release="$temporary_root/term-release"
PATH="$fake_cp_bin:$PATH" SB_NOTES_ROOT="$term_root" SB_NOTES_PAUSE_CP_SOURCE="$term_old_root" SB_NOTES_PAUSE_CP_READY="$term_ready" SB_NOTES_PAUSE_CP_RELEASE="$term_release" "$helper" migrate-layout --execute > "$temporary_root/term-migration.out" 2>&1 &
term_migration_pid=$!
term_attempt=0
while [ ! -f "$term_ready" ] && [ "$term_attempt" -lt 10 ]; do sleep 1; term_attempt=$((term_attempt + 1)); done
[ -f "$term_ready" ] || fail 'TERM migration did not pause at the staged copy'
kill -TERM "$term_migration_pid"
touch "$term_release"
if wait "$term_migration_pid"; then fail 'TERM-interrupted migration unexpectedly succeeded'; fi
[ "$term_before" = "$(snapshot_tree "$term_root")" ] || fail 'TERM recovery did not restore the old authority'

fake_mapping_mv_bin="$temporary_root/fake-mapping-mv"
mkdir "$fake_mapping_mv_bin"
cat > "$fake_mapping_mv_bin/mv" <<'EOF'
#!/bin/sh
case "${2:-}" in
  */.sb-notes-layout-transaction.*/mappings/1.env)
    : > "${SB_NOTES_MAPPING_PAUSE_READY:?}"
    printf '%s\n' "$$" > "${SB_NOTES_MAPPING_PAUSE_CHILD_PID:?}"
    while [ ! -f "${SB_NOTES_MAPPING_PAUSE_RELEASE:?}" ]; do sleep 1; done
    exit 1
    ;;
esac
exec /bin/mv "$@"
EOF
chmod 700 "$fake_mapping_mv_bin/mv"

kill_root="$temporary_root/kill-recovery"
kill_repo="$temporary_root/kill-recovery-source"
create_repo "$kill_repo"
git -C "$kill_repo" remote add origin 'git@personal:octo/kill-recovery.git'
kill_init=$(cd "$kill_repo" && SB_NOTES_ROOT="$kill_root" "$helper" init --task-id kill --title kill)
kill_clean_root="$kill_root/octo-kill-recovery"
kill_old_key='octo-kill-recovery-eeeeeeeeeeee'
kill_old_root="$kill_root/$kill_old_key"
convert_clean_root_to_old_layout "$kill_root" octo-kill-recovery "$kill_old_key"
kill_old_task=$(replace_prefix "$(value "$kill_init" task_path)" "$kill_clean_root" "$kill_old_root")
kill_before=$(snapshot_tree "$kill_root")
kill_ready="$temporary_root/kill-mapping-ready"
kill_release="$temporary_root/kill-mapping-release"
kill_child_pid_file="$temporary_root/kill-mapping-child-pid"
PATH="$fake_mapping_mv_bin:$PATH" SB_NOTES_ROOT="$kill_root" SB_NOTES_MAPPING_PAUSE_READY="$kill_ready" SB_NOTES_MAPPING_PAUSE_CHILD_PID="$kill_child_pid_file" SB_NOTES_MAPPING_PAUSE_RELEASE="$kill_release" "$helper" migrate-layout --execute > "$temporary_root/kill-migration.out" 2>&1 &
kill_migration_pid=$!
kill_attempt=0
while [ ! -f "$kill_ready" ] && [ "$kill_attempt" -lt 10 ]; do sleep 1; kill_attempt=$((kill_attempt + 1)); done
[ -f "$kill_ready" ] && [ -s "$kill_child_pid_file" ] || fail 'SIGKILL migration did not pause at the first mapping temporary'
kill_child_pid=$(cat "$kill_child_pid_file")
kill -KILL "$kill_migration_pid" 2>/dev/null || true
touch "$kill_release"
set +e
wait "$kill_migration_pid" 2>/dev/null
kill_wait_status=$?
set -e
[ "$kill_wait_status" -ne 0 ] || fail 'SIGKILL-interrupted migration unexpectedly succeeded'
kill_child_attempt=0
while kill -0 "$kill_child_pid" 2>/dev/null && [ "$kill_child_attempt" -lt 10 ]; do sleep 1; kill_child_attempt=$((kill_child_attempt + 1)); done
if kill -0 "$kill_child_pid" 2>/dev/null; then fail 'SIGKILL mapping-temporary child did not exit after release'; fi
kill_transaction=$(find "$kill_root" -mindepth 1 -maxdepth 1 -type d -name '.sb-notes-layout-transaction.*' -print | head -n 1)
[ -f "$kill_root/.sb-notes-layout.lock" ] && [ -n "$kill_transaction" ] && [ -n "$(find "$kill_transaction/mappings" -maxdepth 1 -type f -name '.1.*' -print -quit)" ] || fail 'SIGKILL did not leave the real stale lock and prepared mapping temporary'
fake_kill_ps_bin="$temporary_root/fake-kill-ps"
mkdir "$fake_kill_ps_bin"
cat > "$fake_kill_ps_bin/ps" <<'EOF'
#!/bin/sh
exit 1
EOF
chmod 700 "$fake_kill_ps_bin/ps"
PATH="$fake_kill_ps_bin:$PATH" SB_NOTES_ROOT="$kill_root" "$helper" migrate-layout --dry-run >/dev/null
[ "$kill_before" = "$(snapshot_tree "$kill_root")" ] || fail 'SIGKILL recovery did not preserve the exact legacy authority'
[ ! -e "$kill_root/.sb-notes-layout.lock" ] && [ ! -e "$kill_root/.sb-notes-layout.lock.reclaim" ] && [ -z "$(find "$kill_root" -mindepth 1 -maxdepth 1 \( -name '.sb-notes-layout-transaction.*' -o -name '.sb-notes-layout-reservation-*' \) -print -quit)" ] || fail 'SIGKILL recovery left a lock, transaction, or reservation remnant'
SB_NOTES_ROOT="$kill_root" "$helper" resolve --task-path "$kill_old_task" >/dev/null

printf '%s\n' 'migrate-sb-notes-layout tests passed'

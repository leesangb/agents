#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
installer="$repo_root/codex/plugins/sb/scripts/install-agents"
thinker_source="$repo_root/codex/plugins/sb/assets/agents/sb-thinker.toml"
temporary_root=$(mktemp -d)
temporary_root=$(CDPATH= cd -- "$temporary_root" && pwd -P)
trap 'rm -rf "$temporary_root"' 0 1 2 15

fail() {
  printf '%s\n' "FAIL: $*" >&2
  exit 1
}

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

assert_thinker_only_manifest() {
  codex_home=$1
  manifest="$codex_home/sb/state/installed-agents.sha256"

  [ -f "$codex_home/agents/sb-thinker.toml" ] || fail 'thinker was not installed'
  cmp -s "$codex_home/agents/sb-thinker.toml" "$thinker_source" || fail 'installed thinker is stale'
  [ "$(wc -l < "$manifest" | tr -d ' ')" = 1 ] || fail 'manifest does not contain exactly one profile'
  grep -Fq '  sb-thinker.toml' "$manifest" || fail 'manifest does not claim thinker'
  if rg -q 'sb-worker|sb-explorer' "$manifest"; then fail 'manifest still claims deprecated profiles'; fi
}

fresh_home="$temporary_root/fresh"
CODEX_HOME="$fresh_home" "$installer" --install >/dev/null
assert_thinker_only_manifest "$fresh_home"
[ ! -e "$fresh_home/agents/sb-worker.toml" ] && [ ! -e "$fresh_home/agents/sb-explorer.toml" ] || fail 'fresh install created deprecated profiles'
CODEX_HOME="$fresh_home" "$installer" --check >/dev/null

stale_check_home="$temporary_root/stale-check"
CODEX_HOME="$stale_check_home" "$installer" --install >/dev/null
printf '%s\n' 'stale thinker' > "$stale_check_home/agents/sb-thinker.toml"
if CODEX_HOME="$stale_check_home" "$installer" --check >"$temporary_root/stale-check.out" 2>&1; then
  fail 'check accepted a stale thinker'
fi
grep -Fq 'Agent is missing or stale' "$temporary_root/stale-check.out" || fail 'stale thinker check did not explain the failure'

manifest_check_home="$temporary_root/manifest-check"
CODEX_HOME="$manifest_check_home" "$installer" --install >/dev/null
printf '%s\n' 'bad  sb-thinker.toml' > "$manifest_check_home/sb/state/installed-agents.sha256"
if CODEX_HOME="$manifest_check_home" "$installer" --check >"$temporary_root/manifest-check.out" 2>&1; then
  fail 'check accepted stale thinker install state'
fi
grep -Fq 'Agent install state is missing or stale' "$temporary_root/manifest-check.out" || fail 'stale manifest check did not explain the failure'

upgrade_home="$temporary_root/upgrade"
mkdir -p "$upgrade_home/agents" "$upgrade_home/sb/state"
printf '%s\n' 'previous managed worker' > "$upgrade_home/agents/sb-worker.toml"
printf '%s\n' 'previous managed explorer' > "$upgrade_home/agents/sb-explorer.toml"
{
  printf '%s  sb-worker.toml\n' "$(hash_file "$upgrade_home/agents/sb-worker.toml")"
  printf '%s  sb-explorer.toml\n' "$(hash_file "$upgrade_home/agents/sb-explorer.toml")"
} > "$upgrade_home/sb/state/installed-agents.sha256"
CODEX_HOME="$upgrade_home" "$installer" --install >/dev/null
assert_thinker_only_manifest "$upgrade_home"
[ ! -e "$upgrade_home/agents/sb-worker.toml" ] && [ ! -e "$upgrade_home/agents/sb-explorer.toml" ] || fail 'proven managed deprecated profiles survived upgrade'

preserve_home="$temporary_root/preserve"
mkdir -p "$preserve_home/agents" "$preserve_home/sb/state"
printf '%s\n' 'user-modified worker' > "$preserve_home/agents/sb-worker.toml"
printf '%s\n' 'proven old worker bytes' > "$temporary_root/old-worker"
printf '%s  sb-worker.toml\n' "$(hash_file "$temporary_root/old-worker")" > "$preserve_home/sb/state/installed-agents.sha256"
printf '%s\n' 'unknown explorer provenance' > "$preserve_home/agents/sb-explorer.toml"
CODEX_HOME="$preserve_home" "$installer" --install >/dev/null
assert_thinker_only_manifest "$preserve_home"
grep -Fq 'user-modified worker' "$preserve_home/agents/sb-worker.toml" || fail 'modified deprecated profile was removed'
grep -Fq 'unknown explorer provenance' "$preserve_home/agents/sb-explorer.toml" || fail 'unproven deprecated profile was removed'
CODEX_HOME="$preserve_home" "$installer" --check >/dev/null

snapshot_home="$temporary_root/snapshot"
mkdir -p "$snapshot_home/agents" "$snapshot_home/sb/installed-agents"
printf '%s\n' 'legacy snapshot worker' > "$snapshot_home/agents/sb-worker.toml"
cp "$snapshot_home/agents/sb-worker.toml" "$snapshot_home/sb/installed-agents/sb-worker.toml"
CODEX_HOME="$snapshot_home" "$installer" --install >/dev/null
[ ! -e "$snapshot_home/agents/sb-worker.toml" ] || fail 'legacy-snapshot-proven worker survived upgrade'
[ ! -e "$snapshot_home/sb/installed-agents/sb-worker.toml" ] || fail 'used legacy snapshot was not cleaned up'
assert_thinker_only_manifest "$snapshot_home"

conflict_home="$temporary_root/conflict"
mkdir -p "$conflict_home/agents"
printf '%s\n' 'custom thinker' > "$conflict_home/agents/sb-thinker.toml"
if CODEX_HOME="$conflict_home" "$installer" --install >"$temporary_root/conflict.out" 2>&1; then
  fail 'custom thinker conflict unexpectedly installed'
fi
grep -Fq 'custom thinker' "$conflict_home/agents/sb-thinker.toml" || fail 'thinker conflict was overwritten'
[ ! -e "$conflict_home/sb/state/installed-agents.sha256" ] || fail 'conflicting install published state'

symlink_home="$temporary_root/symlink"
mkdir -p "$symlink_home/agents"
printf '%s\n' 'outside thinker' > "$temporary_root/outside-thinker"
ln -s "$temporary_root/outside-thinker" "$symlink_home/agents/sb-thinker.toml"
if CODEX_HOME="$symlink_home" "$installer" --install >"$temporary_root/symlink.out" 2>&1; then
  fail 'symlinked thinker target unexpectedly installed'
fi
grep -Fq 'unsafe agent target' "$temporary_root/symlink.out" || fail 'symlink conflict did not explain the failure'
grep -Fq 'outside thinker' "$temporary_root/outside-thinker" || fail 'symlink conflict changed the outside target'

retire_race_home="$temporary_root/retire-race"
mkdir -p "$retire_race_home/agents" "$retire_race_home/sb/state"
printf '%s\n' 'managed worker before race' > "$retire_race_home/agents/sb-worker.toml"
printf '%s  sb-worker.toml\n' "$(hash_file "$retire_race_home/agents/sb-worker.toml")" > "$retire_race_home/sb/state/installed-agents.sha256"
retire_race_bin="$temporary_root/retire-race-bin"
mkdir "$retire_race_bin"
cat > "$retire_race_bin/mv" <<'EOF'
#!/bin/sh
source_path=$1
destination_path=$2
case "$source_path" in
  */agents/sb-worker.toml)
    if [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      printf '%s\n' 'concurrent worker replacement' > "$source_path.concurrent"
      /bin/mv "$source_path.concurrent" "$source_path"
    fi
    ;;
esac
exec /bin/mv "$source_path" "$destination_path"
EOF
cat > "$retire_race_bin/rm" <<'EOF'
#!/bin/sh
last=''
for argument in "$@"; do last=$argument; done
case "$last" in
  */agents/sb-worker.toml)
    if [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      printf '%s\n' 'concurrent worker replacement' > "$last.concurrent"
      /bin/mv "$last.concurrent" "$last"
    fi
    ;;
esac
exec /bin/rm "$@"
EOF
chmod 755 "$retire_race_bin/mv" "$retire_race_bin/rm"
if PATH="$retire_race_bin:$PATH" SB_INSTALL_RACE_MARKER="$temporary_root/retire-race.marker" CODEX_HOME="$retire_race_home" "$installer" --install >"$temporary_root/retire-race.out" 2>&1; then
  fail 'deprecated retirement race unexpectedly succeeded'
fi
grep -Fq 'concurrent worker replacement' "$retire_race_home/agents/sb-worker.toml" || fail 'deprecated retirement deleted the concurrent replacement'
grep -Eq 'Concurrent change|Recovery' "$temporary_root/retire-race.out" || fail 'retirement race did not provide actionable recovery output'

publish_race_home="$temporary_root/publish-race"
mkdir -p "$publish_race_home/agents" "$publish_race_home/sb/state"
printf '%s\n' 'managed thinker before publication' > "$publish_race_home/agents/sb-thinker.toml"
printf '%s  sb-thinker.toml\n' "$(hash_file "$publish_race_home/agents/sb-thinker.toml")" > "$publish_race_home/sb/state/installed-agents.sha256"
cp "$publish_race_home/sb/state/installed-agents.sha256" "$temporary_root/publish-race.manifest.before"
publish_race_bin="$temporary_root/publish-race-bin"
mkdir "$publish_race_bin"
cat > "$publish_race_bin/mv" <<'EOF'
#!/bin/sh
source_path=$1
case "$source_path" in
  */agents/sb-thinker.toml)
    if [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      /bin/mv "$@" || exit $?
      printf '%s\n' 'concurrent thinker target' > "$source_path"
      exit 0
    fi
    ;;
esac
exec /bin/mv "$@"
EOF
chmod 755 "$publish_race_bin/mv"
if PATH="$publish_race_bin:$PATH" SB_INSTALL_RACE_MARKER="$temporary_root/publish-race.marker" CODEX_HOME="$publish_race_home" "$installer" --install >"$temporary_root/publish-race.out" 2>&1; then
  fail 'concurrent thinker publication unexpectedly succeeded'
fi
grep -Fq 'concurrent thinker target' "$publish_race_home/agents/sb-thinker.toml" || fail 'concurrent thinker target was overwritten'
find "$publish_race_home/agents" -type f -name original -exec grep -Fq 'managed thinker before publication' {} \; -print | grep -q . || fail 'old thinker bytes are not recoverable after publication race'
find "$publish_race_home/agents" -type f -name '.sb-thinker.stage.*' -exec cmp -s {} "$thinker_source" \; -print | grep -q . || fail 'staged new thinker bytes are not recoverable after publication race'
cmp -s "$temporary_root/publish-race.manifest.before" "$publish_race_home/sb/state/installed-agents.sha256" || fail 'publication race changed the old manifest'
grep -Fq 'Recovery' "$temporary_root/publish-race.out" || fail 'publication race did not report recovery paths'

copy_failure_home="$temporary_root/copy-failure"
mkdir -p "$copy_failure_home/agents" "$copy_failure_home/sb/state"
printf '%s\n' 'retryable old thinker' > "$copy_failure_home/agents/sb-thinker.toml"
printf '%s  sb-thinker.toml\n' "$(hash_file "$copy_failure_home/agents/sb-thinker.toml")" > "$copy_failure_home/sb/state/installed-agents.sha256"
cp "$copy_failure_home/sb/state/installed-agents.sha256" "$temporary_root/copy-failure.manifest.before"
copy_failure_bin="$temporary_root/copy-failure-bin"
mkdir "$copy_failure_bin"
cat > "$copy_failure_bin/cp" <<'EOF'
#!/bin/sh
destination_path=$2
case "$destination_path" in
  */.sb-thinker.stage.*)
    printf '%s\n' 'partial staged thinker' > "$destination_path"
    exit 1
    ;;
esac
exec /bin/cp "$@"
EOF
chmod 755 "$copy_failure_bin/cp"
if PATH="$copy_failure_bin:$PATH" CODEX_HOME="$copy_failure_home" "$installer" --install >"$temporary_root/copy-failure.out" 2>&1; then
  fail 'staged thinker copy failure unexpectedly succeeded'
fi
grep -Fq 'retryable old thinker' "$copy_failure_home/agents/sb-thinker.toml" || fail 'staged copy failure changed the live thinker'
cmp -s "$temporary_root/copy-failure.manifest.before" "$copy_failure_home/sb/state/installed-agents.sha256" || fail 'staged copy failure changed the manifest'
CODEX_HOME="$copy_failure_home" "$installer" --install >/dev/null
assert_thinker_only_manifest "$copy_failure_home"

check_symlink_home="$temporary_root/check-symlink"
mkdir -p "$check_symlink_home/agents" "$check_symlink_home/sb/state"
cp "$thinker_source" "$temporary_root/check-symlink-thinker"
ln -s "$temporary_root/check-symlink-thinker" "$check_symlink_home/agents/sb-thinker.toml"
printf '%s  sb-thinker.toml\n' "$(hash_file "$thinker_source")" > "$check_symlink_home/sb/state/installed-agents.sha256"
if CODEX_HOME="$check_symlink_home" "$installer" --check >"$temporary_root/check-symlink.out" 2>&1; then
  fail '--check accepted a symlinked thinker'
fi

ancestor_home="$temporary_root/ancestor"
ancestor_external="$temporary_root/ancestor-external-agents"
mkdir -p "$ancestor_home/sb/state" "$ancestor_external"
cp "$thinker_source" "$ancestor_external/sb-thinker.toml"
ln -s "$ancestor_external" "$ancestor_home/agents"
printf '%s  sb-thinker.toml\n' "$(hash_file "$thinker_source")" > "$ancestor_home/sb/state/installed-agents.sha256"
if CODEX_HOME="$ancestor_home" "$installer" --check >"$temporary_root/ancestor.out" 2>&1; then
  fail '--check followed a symlinked managed ancestor'
fi
grep -Eq 'unsafe managed|symlink' "$temporary_root/ancestor.out" || fail 'managed ancestor failure was not actionable'

snapshot_race_home="$temporary_root/snapshot-race"
mkdir -p "$snapshot_race_home/sb/installed-agents"
cp "$thinker_source" "$snapshot_race_home/sb/installed-agents/sb-thinker.toml"
snapshot_race_bin="$temporary_root/snapshot-race-bin"
mkdir "$snapshot_race_bin"
cat > "$snapshot_race_bin/cmp" <<'EOF'
#!/bin/sh
if /usr/bin/cmp "$@"; then result=0; else result=$?; fi
case "$1" in
  */sb/installed-agents/sb-thinker.toml)
    if [ "$result" -eq 0 ] && [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      printf '%s\n' 'concurrent user snapshot' > "$1.concurrent"
      /bin/mv "$1.concurrent" "$1"
    fi
    ;;
esac
exit "$result"
EOF
cat > "$snapshot_race_bin/mv" <<'EOF'
#!/bin/sh
case "$1" in
  */sb/installed-agents/sb-thinker.toml)
    if [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      printf '%s\n' 'concurrent user snapshot' > "$1.concurrent"
      /bin/mv "$1.concurrent" "$1"
    fi
    ;;
esac
exec /bin/mv "$@"
EOF
chmod 755 "$snapshot_race_bin/cmp" "$snapshot_race_bin/mv"
if PATH="$snapshot_race_bin:$PATH" SB_INSTALL_RACE_MARKER="$temporary_root/snapshot-race.marker" CODEX_HOME="$snapshot_race_home" "$installer" --install >"$temporary_root/snapshot-race.out" 2>&1; then
  fail 'snapshot ownership race unexpectedly succeeded'
fi
grep -Fq 'concurrent user snapshot' "$snapshot_race_home/sb/installed-agents/sb-thinker.toml" || fail 'snapshot ownership race deleted user bytes'
find "$snapshot_race_home/sb" -type f -path '*/.agent-ownership.*/*sb-thinker*' -exec cmp -s {} "$thinker_source" \; -print | grep -q . || fail 'immutable baseline snapshot was not preserved for recovery'
grep -Fq 'Recovery baseline snapshot' "$temporary_root/snapshot-race.out" || fail 'snapshot race did not report immutable recovery evidence'

directory_publish_home="$temporary_root/directory-publish"
mkdir -p "$directory_publish_home/agents" "$directory_publish_home/sb/state"
printf '%s\n' 'directory-race old thinker' > "$directory_publish_home/agents/sb-thinker.toml"
printf '%s  sb-thinker.toml\n' "$(hash_file "$directory_publish_home/agents/sb-thinker.toml")" > "$directory_publish_home/sb/state/installed-agents.sha256"
directory_publish_bin="$temporary_root/directory-publish-bin"
mkdir "$directory_publish_bin"
cat > "$directory_publish_bin/mv" <<'EOF'
#!/bin/sh
source_path=$1
case "$source_path" in
  */agents/sb-thinker.toml)
    if [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      /bin/mv "$@" || exit $?
      mkdir "$source_path"
      exit 0
    fi
    ;;
esac
exec /bin/mv "$@"
EOF
chmod 755 "$directory_publish_bin/mv"
if PATH="$directory_publish_bin:$PATH" SB_INSTALL_RACE_MARKER="$temporary_root/directory-publish.marker" CODEX_HOME="$directory_publish_home" "$installer" --install >"$temporary_root/directory-publish.out" 2>&1; then
  fail 'directory-target thinker publication reported false success'
fi
[ -d "$directory_publish_home/agents/sb-thinker.toml" ] || fail 'directory publication fixture did not create the raced target'
[ -z "$(find "$directory_publish_home/agents/sb-thinker.toml" -mindepth 1 -print -quit)" ] || fail 'directory publication created a basename inside the raced directory'
find "$directory_publish_home/agents" -type f -name original -exec grep -Fq 'directory-race old thinker' {} \; -print | grep -q . || fail 'directory publication discarded the prior thinker'
find "$directory_publish_home/agents" -type f -name '.sb-thinker.stage.*' -exec cmp -s {} "$thinker_source" \; -print | grep -q . || fail 'directory publication discarded the staged thinker'
grep -Fq 'Exact link failed' "$temporary_root/directory-publish.out" || fail 'directory publication ambiguity was not actionable'

symlink_directory_home="$temporary_root/symlink-directory-publish"
mkdir -p "$symlink_directory_home/agents" "$symlink_directory_home/sb/state" "$temporary_root/symlink-directory-target"
printf '%s\n' 'symlink-directory old thinker' > "$symlink_directory_home/agents/sb-thinker.toml"
printf '%s  sb-thinker.toml\n' "$(hash_file "$symlink_directory_home/agents/sb-thinker.toml")" > "$symlink_directory_home/sb/state/installed-agents.sha256"
symlink_directory_bin="$temporary_root/symlink-directory-bin"
mkdir "$symlink_directory_bin"
cat > "$symlink_directory_bin/mv" <<'EOF'
#!/bin/sh
case "$1" in
  */agents/sb-thinker.toml)
    if [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      source_path=$1
      /bin/mv "$@" || exit $?
      /bin/ln -s "$SB_INSTALL_EXTERNAL_DIRECTORY" "$source_path"
      exit 0
    fi
    ;;
esac
exec /bin/mv "$@"
EOF
chmod 755 "$symlink_directory_bin/mv"
if PATH="$symlink_directory_bin:$PATH" SB_INSTALL_RACE_MARKER="$temporary_root/symlink-directory.marker" SB_INSTALL_EXTERNAL_DIRECTORY="$temporary_root/symlink-directory-target" CODEX_HOME="$symlink_directory_home" "$installer" --install >"$temporary_root/symlink-directory.out" 2>&1; then
  fail 'symlink-to-directory thinker publication reported false success'
fi
[ -L "$symlink_directory_home/agents/sb-thinker.toml" ] || fail 'symlink-to-directory publication fixture was not preserved'
[ -z "$(find "$temporary_root/symlink-directory-target" -mindepth 1 -print -quit)" ] || fail 'publication created a basename through the raced directory symlink'
find "$symlink_directory_home/agents" -type f -name original -exec grep -Fq 'symlink-directory old thinker' {} \; -print | grep -q . || fail 'symlink-to-directory publication discarded the prior thinker'
find "$symlink_directory_home/agents" -type f -name '.sb-thinker.stage.*' -exec cmp -s {} "$thinker_source" \; -print | grep -q . || fail 'symlink-to-directory publication discarded the staged thinker'
grep -Fq 'Exact link failed' "$temporary_root/symlink-directory.out" || fail 'symlink-to-directory publication ambiguity was not actionable'

directory_restore_home="$temporary_root/directory-restore"
mkdir -p "$directory_restore_home/agents" "$directory_restore_home/sb/state"
printf '%s\n' 'restore managed worker' > "$directory_restore_home/agents/sb-worker.toml"
printf '%s  sb-worker.toml\n' "$(hash_file "$directory_restore_home/agents/sb-worker.toml")" > "$directory_restore_home/sb/state/installed-agents.sha256"
directory_restore_bin="$temporary_root/directory-restore-bin"
mkdir "$directory_restore_bin"
cat > "$directory_restore_bin/mv" <<'EOF'
#!/bin/sh
case "$1" in
  */agents/sb-worker.toml)
    if [ ! -e "$SB_INSTALL_MOVE_MARKER" ]; then
      : > "$SB_INSTALL_MOVE_MARKER"
      printf '%s\n' 'restore concurrent worker' > "$1.concurrent"
      /bin/mv "$1.concurrent" "$1"
      /bin/mv "$@" || exit $?
      mkdir "$1"
      exit 0
    fi
    ;;
esac
exec /bin/mv "$@"
EOF
chmod 755 "$directory_restore_bin/mv"
if PATH="$directory_restore_bin:$PATH" SB_INSTALL_MOVE_MARKER="$temporary_root/directory-restore-move.marker" CODEX_HOME="$directory_restore_home" "$installer" --install >"$temporary_root/directory-restore.out" 2>&1; then
  fail 'directory-target quarantine restoration unexpectedly succeeded'
fi
[ -d "$directory_restore_home/agents/sb-worker.toml" ] || fail 'directory restoration fixture did not create the raced target'
find "$directory_restore_home/agents" -type f -name original -exec grep -Fq 'restore concurrent worker' {} \; -print | grep -q . || fail 'directory restoration discarded quarantined replacement bytes'
[ -z "$(find "$directory_restore_home/agents/sb-worker.toml" -mindepth 1 -print -quit)" ] || fail 'directory restoration modified the raced directory'
grep -Fq 'Recovery required' "$temporary_root/directory-restore.out" || fail 'directory restoration ambiguity was not actionable'

manifest_race_home="$temporary_root/manifest-race"
mkdir -p "$manifest_race_home/agents" "$manifest_race_home/sb/state"
printf '%s\n' 'custom worker guarded by old manifest' > "$manifest_race_home/agents/sb-worker.toml"
printf '%s\n' 'unrelated baseline manifest' > "$manifest_race_home/sb/state/installed-agents.sha256"
cp "$manifest_race_home/sb/state/installed-agents.sha256" "$temporary_root/manifest-race.baseline"
manifest_race_bin="$temporary_root/manifest-race-bin"
mkdir "$manifest_race_bin"
cat > "$manifest_race_bin/cp" <<'EOF'
#!/bin/sh
/bin/cp "$@" || exit $?
case "$2" in
  */agents/.sb-thinker.stage.*)
    if [ ! -e "$SB_INSTALL_RACE_MARKER" ]; then
      : > "$SB_INSTALL_RACE_MARKER"
      if command -v sha256sum >/dev/null 2>&1; then
        owned_hash=$(sha256sum "$SB_INSTALL_CUSTOM_WORKER" | awk '{print $1}')
      else
        owned_hash=$(shasum -a 256 "$SB_INSTALL_CUSTOM_WORKER" | awk '{print $1}')
      fi
      printf '%s  sb-worker.toml\n' "$owned_hash" > "$SB_INSTALL_MANIFEST.concurrent"
      /bin/mv "$SB_INSTALL_MANIFEST.concurrent" "$SB_INSTALL_MANIFEST"
    fi
    ;;
esac
EOF
chmod 755 "$manifest_race_bin/cp"
if PATH="$manifest_race_bin:$PATH" SB_INSTALL_RACE_MARKER="$temporary_root/manifest-race.marker" SB_INSTALL_CUSTOM_WORKER="$manifest_race_home/agents/sb-worker.toml" SB_INSTALL_MANIFEST="$manifest_race_home/sb/state/installed-agents.sha256" CODEX_HOME="$manifest_race_home" "$installer" --install >"$temporary_root/manifest-race.out" 2>&1; then
  fail 'mutable manifest ownership race unexpectedly succeeded'
fi
grep -Fq 'custom worker guarded by old manifest' "$manifest_race_home/agents/sb-worker.toml" || fail 'mutable live manifest authorized deletion of custom worker bytes'
grep -Fq 'sb-worker.toml' "$manifest_race_home/sb/state/installed-agents.sha256" || fail 'concurrent manifest bytes were not preserved'
find "$manifest_race_home/sb" -type f -path '*/.agent-ownership.*/manifest' -exec cmp -s {} "$temporary_root/manifest-race.baseline" \; -print | grep -q . || fail 'immutable baseline manifest was not preserved for recovery'
find "$manifest_race_home/sb/state" -type f -name '.installed-agents.sha256.stage.*' -print | grep -q . || fail 'desired staged manifest was not preserved for recovery'
grep -Fq 'Recovery baseline manifest' "$temporary_root/manifest-race.out" || fail 'manifest race did not report immutable baseline recovery path'

manifest_symlink_home="$temporary_root/manifest-symlink-race"
mkdir -p "$manifest_symlink_home/agents" "$manifest_symlink_home/sb/state"
printf '%s\n' 'custom worker protected from symlink race' > "$manifest_symlink_home/agents/sb-worker.toml"
printf '%s\n' 'benign manifest before race' > "$manifest_symlink_home/sb/state/installed-agents.sha256"
printf '%s  sb-worker.toml\n' "$(hash_file "$manifest_symlink_home/agents/sb-worker.toml")" > "$temporary_root/attacker-manifest"
manifest_symlink_bin="$temporary_root/manifest-symlink-bin"
mkdir "$manifest_symlink_bin"
cat > "$manifest_symlink_bin/mktemp" <<'EOF'
#!/bin/sh
created=$(/usr/bin/mktemp "$@") || exit $?
case "$created" in
  */sb/.agent-ownership.*)
    /bin/rm -f "$SB_INSTALL_MANIFEST"
    /bin/ln -s "$SB_INSTALL_ATTACKER_MANIFEST" "$SB_INSTALL_MANIFEST"
    ;;
esac
printf '%s\n' "$created"
EOF
cat > "$manifest_symlink_bin/ln" <<'EOF'
#!/bin/sh
case "$1" in
  -h)
    shift
    exec /bin/ln -L "$@"
    ;;
esac
exec /bin/ln "$@"
EOF
chmod 755 "$manifest_symlink_bin/mktemp" "$manifest_symlink_bin/ln"
if PATH="$manifest_symlink_bin:$PATH" SB_INSTALL_MANIFEST="$manifest_symlink_home/sb/state/installed-agents.sha256" SB_INSTALL_ATTACKER_MANIFEST="$temporary_root/attacker-manifest" CODEX_HOME="$manifest_symlink_home" "$installer" --install >"$temporary_root/manifest-symlink-race.out" 2>&1; then
  fail 'symlink-swapped manifest baseline unexpectedly authorized installation'
fi
grep -Fq 'custom worker protected from symlink race' "$manifest_symlink_home/agents/sb-worker.toml" || fail 'symlink-swapped manifest authorized custom worker deletion'
[ -L "$manifest_symlink_home/sb/state/installed-agents.sha256" ] || fail 'manifest symlink race fixture was not preserved'
grep -Fq 'sb-worker.toml' "$temporary_root/attacker-manifest" || fail 'manifest symlink race modified attacker bytes'

snapshot_symlink_home="$temporary_root/snapshot-symlink-race"
mkdir -p "$snapshot_symlink_home/agents" "$snapshot_symlink_home/sb/installed-agents"
printf '%s\n' 'custom worker protected from snapshot symlink race' > "$snapshot_symlink_home/agents/sb-worker.toml"
printf '%s\n' 'benign legacy snapshot before race' > "$snapshot_symlink_home/sb/installed-agents/sb-worker.toml"
cp "$snapshot_symlink_home/agents/sb-worker.toml" "$temporary_root/attacker-worker-snapshot"
snapshot_symlink_bin="$temporary_root/snapshot-symlink-bin"
mkdir "$snapshot_symlink_bin"
cat > "$snapshot_symlink_bin/mktemp" <<'EOF'
#!/bin/sh
created=$(/usr/bin/mktemp "$@") || exit $?
case "$created" in
  */sb/.agent-ownership.*)
    /bin/rm -f "$SB_INSTALL_SNAPSHOT"
    /bin/ln -s "$SB_INSTALL_ATTACKER_SNAPSHOT" "$SB_INSTALL_SNAPSHOT"
    ;;
esac
printf '%s\n' "$created"
EOF
cat > "$snapshot_symlink_bin/ln" <<'EOF'
#!/bin/sh
case "$1" in
  -h)
    shift
    exec /bin/ln -L "$@"
    ;;
esac
exec /bin/ln "$@"
EOF
chmod 755 "$snapshot_symlink_bin/mktemp" "$snapshot_symlink_bin/ln"
if PATH="$snapshot_symlink_bin:$PATH" SB_INSTALL_SNAPSHOT="$snapshot_symlink_home/sb/installed-agents/sb-worker.toml" SB_INSTALL_ATTACKER_SNAPSHOT="$temporary_root/attacker-worker-snapshot" CODEX_HOME="$snapshot_symlink_home" "$installer" --install >"$temporary_root/snapshot-symlink-race.out" 2>&1; then
  fail 'symlink-swapped legacy snapshot unexpectedly authorized installation'
fi
grep -Fq 'custom worker protected from snapshot symlink race' "$snapshot_symlink_home/agents/sb-worker.toml" || fail 'symlink-swapped snapshot authorized custom worker deletion'
[ -L "$snapshot_symlink_home/sb/installed-agents/sb-worker.toml" ] || fail 'snapshot symlink race fixture was not preserved'
grep -Fq 'custom worker protected from snapshot symlink race' "$temporary_root/attacker-worker-snapshot" || fail 'snapshot symlink race modified attacker bytes'

printf '%s\n' 'install-agents tests passed'

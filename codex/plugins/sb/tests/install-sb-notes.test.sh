#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
installer="$repo_root/codex/plugins/sb/scripts/install-sb-notes"
source_file="$repo_root/codex/plugins/sb/assets/bin/sb-notes"
top_level_installer="$repo_root/codex/install"
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

codex_home="$temporary_root/codex-home"
CODEX_HOME="$codex_home" "$installer" --install >/dev/null
installed_helper="$codex_home/bin/sb-notes"
manifest_file="$codex_home/sb/state/installed-sb-notes.sha256"
[ -x "$installed_helper" ] || fail 'installer did not create executable helper'
cmp -s "$source_file" "$installed_helper" || fail 'installed helper differs from source'
[ "$(sed -n 's/^sha256=//p' "$manifest_file")" = "$(hash_file "$source_file")" ] || fail 'installer did not record source hash'
CODEX_HOME="$codex_home" "$installer" --check >/dev/null

unsafe_manifest_home="$temporary_root/unsafe-manifest-home"
CODEX_HOME="$unsafe_manifest_home" "$installer" --install >/dev/null
unsafe_manifest_helper="$unsafe_manifest_home/bin/sb-notes"
unsafe_manifest_file="$unsafe_manifest_home/sb/state/installed-sb-notes.sha256"
cp "$unsafe_manifest_helper" "$temporary_root/unsafe-manifest-helper-before"
cp "$unsafe_manifest_file" "$temporary_root/unsafe-manifest-before"
unsafe_manifest_referent="$temporary_root/unsafe-manifest-referent"
cp "$unsafe_manifest_file" "$unsafe_manifest_referent"
rm -f "$unsafe_manifest_file"
ln -s "$unsafe_manifest_referent" "$unsafe_manifest_file"
if CODEX_HOME="$unsafe_manifest_home" "$installer" --preflight >/dev/null 2>&1; then
  fail 'preflight accepted a symlinked helper manifest'
fi
if CODEX_HOME="$unsafe_manifest_home" "$installer" --install >/dev/null 2>&1; then
  fail 'install accepted a symlinked helper manifest'
fi
cmp -s "$temporary_root/unsafe-manifest-helper-before" "$unsafe_manifest_helper" || fail 'unsafe manifest rejection changed helper bytes'
cmp -s "$temporary_root/unsafe-manifest-before" "$unsafe_manifest_referent" || fail 'unsafe manifest rejection changed manifest bytes'

printf '%s\n' '# user edit' >> "$installed_helper"
cp "$installed_helper" "$temporary_root/modified-helper-before"
cp "$manifest_file" "$temporary_root/modified-manifest-before"
if CODEX_HOME="$codex_home" "$installer" --preflight >/dev/null 2>&1; then
  fail 'preflight accepted a modified helper'
fi
if CODEX_HOME="$codex_home" "$installer" --install >/dev/null 2>&1; then
  fail 'install overwrote a modified helper'
fi
cmp -s "$temporary_root/modified-helper-before" "$installed_helper" || fail 'conflict changed helper bytes'
cmp -s "$temporary_root/modified-manifest-before" "$manifest_file" || fail 'conflict changed manifest bytes'

leaf_home="$temporary_root/leaf-home"
mkdir -p "$leaf_home/bin"
leaf_referent="$temporary_root/leaf-referent"
printf '%s\n' 'keep leaf referent' > "$leaf_referent"
ln -s "$leaf_referent" "$leaf_home/bin/sb-notes"
if CODEX_HOME="$leaf_home" "$installer" --preflight >/dev/null 2>&1; then
  fail 'preflight accepted a symlinked helper leaf'
fi
if CODEX_HOME="$leaf_home" "$installer" --install >/dev/null 2>&1; then
  fail 'install followed a symlinked helper leaf'
fi
grep -Fqx 'keep leaf referent' "$leaf_referent" || fail 'leaf symlink rejection changed its referent'

dangling_home="$temporary_root/dangling-home"
mkdir -p "$dangling_home/bin"
dangling_referent="$temporary_root/dangling-referent"
ln -s "$dangling_referent" "$dangling_home/bin/sb-notes"
if CODEX_HOME="$dangling_home" "$installer" --install >/dev/null 2>&1; then
  fail 'install followed a dangling helper symlink'
fi
[ ! -e "$dangling_referent" ] || fail 'dangling helper symlink created an external referent'

directory_link_home="$temporary_root/directory-link-home"
directory_referent="$temporary_root/directory-referent"
mkdir -p "$directory_link_home" "$directory_referent"
ln -s "$directory_referent" "$directory_link_home/bin"
if CODEX_HOME="$directory_link_home" "$installer" --install >/dev/null 2>&1; then
  fail 'install followed a symlinked helper directory'
fi
[ ! -e "$directory_referent/sb-notes" ] || fail 'symlinked helper directory changed its referent'

partial_home="$temporary_root/partial-home"
mkdir -p "$partial_home"
if (ulimit -f 1; CODEX_HOME="$partial_home" "$installer" --install) >/dev/null 2>&1; then
  fail 'file-limited helper staging unexpectedly succeeded'
fi
[ ! -e "$partial_home/bin/sb-notes" ] || fail 'partial staging published a helper target'
[ ! -e "$partial_home/sb/state/installed-sb-notes.sha256" ] || fail 'partial staging published a helper manifest'
[ "$(find "$partial_home" \( -name '.sb-notes.*' -o -name '.installed-sb-notes.sha256.*' \) -type f | wc -l | tr -d ' ')" = 0 ] || fail 'failed staging left temporary files'
CODEX_HOME="$partial_home" "$installer" --install >/dev/null
cp "$partial_home/bin/sb-notes" "$temporary_root/partial-helper-before"
cp "$partial_home/sb/state/installed-sb-notes.sha256" "$temporary_root/partial-manifest-before"
if (ulimit -f 1; CODEX_HOME="$partial_home" "$installer" --install) >/dev/null 2>&1; then
  fail 'file-limited replacement staging unexpectedly succeeded'
fi
cmp -s "$temporary_root/partial-helper-before" "$partial_home/bin/sb-notes" || fail 'partial staging changed an existing helper'
cmp -s "$temporary_root/partial-manifest-before" "$partial_home/sb/state/installed-sb-notes.sha256" || fail 'partial staging changed an existing manifest'
[ "$(find "$partial_home" \( -name '.sb-notes.*' -o -name '.installed-sb-notes.sha256.*' \) -type f | wc -l | tr -d ' ')" = 0 ] || fail 'failed replacement staging left temporary files'

manifest_stage_home="$temporary_root/manifest-stage-home"
CODEX_HOME="$manifest_stage_home" "$installer" --install >/dev/null
manifest_stage_helper="$manifest_stage_home/bin/sb-notes"
manifest_stage_file="$manifest_stage_home/sb/state/installed-sb-notes.sha256"
cp "$manifest_stage_helper" "$temporary_root/manifest-stage-helper-before"
cp "$manifest_stage_file" "$temporary_root/manifest-stage-before"
chmod 500 "$manifest_stage_home/sb/state"
if CODEX_HOME="$manifest_stage_home" "$installer" --install >/dev/null 2>&1; then
  fail 'unwritable manifest staging unexpectedly succeeded'
fi
chmod 700 "$manifest_stage_home/sb/state"
cmp -s "$temporary_root/manifest-stage-helper-before" "$manifest_stage_helper" || fail 'manifest staging failure changed helper bytes'
cmp -s "$temporary_root/manifest-stage-before" "$manifest_stage_file" || fail 'manifest staging failure changed manifest bytes'
[ "$(find "$manifest_stage_home" \( -name '.sb-notes.*' -o -name '.installed-sb-notes.sha256.*' \) -type f | wc -l | tr -d ' ')" = 0 ] || fail 'manifest staging failure left temporary files'

updated_plugin="$temporary_root/updated-plugin"
mkdir -p "$updated_plugin/scripts" "$updated_plugin/assets/bin"
cp "$installer" "$updated_plugin/scripts/install-sb-notes"
cp "$source_file" "$updated_plugin/assets/bin/sb-notes"
printf '%s\n' '# updated helper used to exercise manifest rollback' >> "$updated_plugin/assets/bin/sb-notes"
chmod 700 "$updated_plugin/scripts/install-sb-notes" "$updated_plugin/assets/bin/sb-notes"

rollback_home="$temporary_root/rollback-home"
CODEX_HOME="$rollback_home" "$installer" --install >/dev/null
rollback_helper="$rollback_home/bin/sb-notes"
rollback_manifest="$rollback_home/sb/state/installed-sb-notes.sha256"
cp "$rollback_helper" "$temporary_root/rollback-helper-before"
cp "$rollback_manifest" "$temporary_root/rollback-manifest-before"
fake_mv_bin="$temporary_root/fake-mv-bin"
mkdir "$fake_mv_bin"
cat > "$fake_mv_bin/mv" <<'EOF'
#!/bin/sh
case "$2" in
  */installed-sb-notes.sha256) exit 1 ;;
  *) exec /bin/mv "$@" ;;
esac
EOF
chmod 700 "$fake_mv_bin/mv"
if PATH="$fake_mv_bin:$PATH" CODEX_HOME="$rollback_home" "$updated_plugin/scripts/install-sb-notes" --install >/dev/null 2>&1; then
  fail 'manifest publication failure unexpectedly succeeded'
fi
cmp -s "$temporary_root/rollback-helper-before" "$rollback_helper" || fail 'manifest publication failure did not roll back helper bytes'
[ -x "$rollback_helper" ] || fail 'manifest publication failure did not restore an executable helper'
cmp -s "$temporary_root/rollback-manifest-before" "$rollback_manifest" || fail 'manifest publication failure changed manifest bytes'
[ "$(find "$rollback_home" \( -name '.sb-notes.*' -o -name '.installed-sb-notes.sha256.*' \) -type f | wc -l | tr -d ' ')" = 0 ] || fail 'manifest publication failure left temporary files'

concurrent_home="$temporary_root/concurrent-home"
mkfifo "$temporary_root/concurrent-one.fifo" "$temporary_root/concurrent-two.fifo"
(
  read ignored < "$temporary_root/concurrent-one.fifo"
  CODEX_HOME="$concurrent_home" "$installer" --install > "$temporary_root/concurrent-one.out"
) &
concurrent_one_pid=$!
(
  read ignored < "$temporary_root/concurrent-two.fifo"
  CODEX_HOME="$concurrent_home" "$updated_plugin/scripts/install-sb-notes" --install > "$temporary_root/concurrent-two.out"
) &
concurrent_two_pid=$!
printf '%s\n' go > "$temporary_root/concurrent-one.fifo"
printf '%s\n' go > "$temporary_root/concurrent-two.fifo"
wait "$concurrent_one_pid"
wait "$concurrent_two_pid"
concurrent_helper_hash=$(hash_file "$concurrent_home/bin/sb-notes")
case "$concurrent_helper_hash" in
  "$(hash_file "$source_file")"|"$(hash_file "$updated_plugin/assets/bin/sb-notes")") ;;
  *) fail 'concurrent installs published an unknown helper version' ;;
esac
[ "$(sed -n 's/^sha256=//p' "$concurrent_home/sb/state/installed-sb-notes.sha256")" = "$concurrent_helper_hash" ] || fail 'concurrent installs interleaved helper and manifest versions'
[ "$(find "$concurrent_home" \( -name '.sb-notes.*' -o -name '.installed-sb-notes.sha256.*' \) -type f | wc -l | tr -d ' ')" = 0 ] || fail 'concurrent installs left temporary files'

fake_bin="$temporary_root/fake-bin"
mkdir "$fake_bin"
cat > "$fake_bin/codex" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$FAKE_CODEX_LOG"
case "$*" in
  'plugin marketplace list --json') printf '%s\n' '[]' ;;
esac
EOF
chmod 700 "$fake_bin/codex"

conflict_home="$temporary_root/top-level-conflict"
mkdir -p "$conflict_home/bin"
printf '%s\n' 'user helper' > "$conflict_home/bin/sb-notes"
fake_log="$temporary_root/fake-codex-conflict.log"
if PATH="$fake_bin:$PATH" FAKE_CODEX_LOG="$fake_log" CODEX_HOME="$conflict_home" "$top_level_installer" >/dev/null 2>&1; then
  fail 'top-level install accepted a notes preflight conflict'
fi
[ ! -e "$fake_log" ] || fail 'notes preflight conflict called codex plugin or marketplace commands'

top_level_manifest_failure="$temporary_root/top-level-manifest-failure"
CODEX_HOME="$top_level_manifest_failure" "$installer" --install >/dev/null
top_level_manifest_file="$top_level_manifest_failure/sb/state/installed-sb-notes.sha256"
top_level_manifest_referent="$temporary_root/top-level-manifest-referent"
cp "$top_level_manifest_file" "$top_level_manifest_referent"
rm -f "$top_level_manifest_file"
ln -s "$top_level_manifest_referent" "$top_level_manifest_file"
top_level_manifest_log="$temporary_root/fake-codex-manifest.log"
if PATH="$fake_bin:$PATH" FAKE_CODEX_LOG="$top_level_manifest_log" CODEX_HOME="$top_level_manifest_failure" "$top_level_installer" >/dev/null 2>&1; then
  fail 'top-level install accepted a notes manifest preflight failure'
fi
[ ! -e "$top_level_manifest_log" ] || fail 'notes manifest preflight failure called codex plugin or marketplace commands'

clean_home="$temporary_root/top-level-clean"
clean_log="$temporary_root/fake-codex-clean.log"
PATH="$fake_bin:$PATH" FAKE_CODEX_LOG="$clean_log" CODEX_HOME="$clean_home" "$top_level_installer" >/dev/null
[ -x "$clean_home/bin/sb-notes" ] || fail 'top-level install did not install sb-notes'
grep -Fq 'plugin marketplace list --json' "$clean_log" || fail 'top-level install did not use the fake codex marketplace command'

printf '%s\n' 'install-sb-notes tests passed'

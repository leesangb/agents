#!/bin/sh
set -eu

# The thinker instructions exist once per runtime format; fail when they diverge.
plugin_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
codex_profile="$plugin_root/assets/agents/sb-thinker.toml"
claude_agent="$plugin_root/agents/thinker.md"

codex_body=$(awk '/^developer_instructions = """$/{inside=1; next} /^"""$/{inside=0} inside' "$codex_profile")
claude_body=$(awk 'separators>=2{print} /^---$/{separators++}' "$claude_agent" | sed '1{/^$/d;}')

if [ "$codex_body" != "$claude_body" ]; then
  printf '%s\n' 'thinker-parity: sb-thinker.toml and agents/thinker.md instructions differ' >&2
  exit 1
fi
printf '%s\n' 'thinker-parity: ok'

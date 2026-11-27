# agents

The `sb` plugin provides implementation, review, and investigation skills for Codex and Claude Code.

## Install or update

Run the command for your runtime from this repository:

```sh
./install codex
./install claude
```

For Codex, rerun the installer after plugin changes and start a new session. For Claude Code, start a new session or run `/reload-plugins` to load changes.

Check your installation with `./install codex --check` or `./install claude --check`.

## Usage

Invoke skills as `$sb:<name>` in Codex or `/sb:<name>` in Claude Code.

Start with `code` or `review` and describe the outcome. Code compares candidate repairs when changing a shared API and fixing one caller have different effects. Review probes a plausible wrong behavior that the current checks would accept.

| Skill | Purpose |
| --- | --- |
| `code` | Plan and implement changes. |
| `review` | Review code, PRs, plans, and designs. |
| `interrogate` | Probe a change for functional failures and rerun each reported case. |
| `arena` | Compare independent solutions to the same task and verify the selected design. |
| `eval` | Invoke `$sb:eval` (Codex) or `/sb:eval` (Claude Code) directly to compare skill versions on matched tasks with blinded grading. |
| `how` | Explain how code works. |
| `why` | Investigate why code took its current shape. |

Browse [all skills](plugins/sb/skills) and [shared principles](plugins/sb/principles/index.md).

## Acknowledgements

This project draws heavily on [pstack by Lauren Tan](https://github.com/cursor/plugins/tree/main/pstack).
See [Third-Party Notices](plugins/sb/THIRD_PARTY_NOTICES.md) for attribution and license terms covering the adapted portions.

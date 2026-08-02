# agents

Portable agent workflows and capability bundles for multiple coding-agent runtimes.

The repository currently contains the Codex distribution of the `sb` plugin. Other runtimes can live beside `codex/` without sharing runtime-specific packaging.

## Codex

`codex/plugins/sb` packages composable code-change workflows around three execution profiles:

- `sb-worker`: Luna max with workspace-write access
- `sb-explorer`: Luna max with read-only access
- `sb-thinker`: Sol high with read-only access

`$sb:code` is the main entry point for routing executable changes through Fast, Deep, or Ultra workflows. `$sb:review-with-subagents` selects only evidence-backed review capabilities. The remaining skills are internal capabilities injected into the appropriate execution profile.

### Install or update

```sh
cd codex
./install
```

The command registers this repository as a local Codex marketplace when needed, installs or refreshes `sb@agents`, and updates the three namespaced agent profiles. Start a new Codex session after installation so the refreshed plugin and profiles are loaded.

Verify the installed plugin and profiles with:

```sh
cd codex
./install --check
```

The installer preserves user-edited agent profiles by comparing them with the SHA-256 hashes recorded under `$CODEX_HOME/sb/state/`. It refuses to overwrite a profile that differs from the last SB-installed version.

## Layout

```text
codex/
├── .agents/plugins/marketplace.json  # local marketplace
├── install                            # install, update, and verification entry point
└── plugins/sb/
    ├── .codex-plugin/plugin.json      # plugin manifest
    ├── assets/agents/                 # namespaced Codex agent profiles
    ├── scripts/install-agents         # profile installer and conflict protection
    └── skills/                         # workflow and capability skills
```

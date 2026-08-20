# agents

Portable agent workflows and capability bundles for multiple coding-agent runtimes.

The repository currently contains the Codex distribution of the `sb` plugin. Other runtimes can live beside `codex/` without sharing runtime-specific packaging.

## Codex

`codex/plugins/sb` packages composable code-change workflows around Codex's built-in execution roles plus one materially distinct custom profile:

- built-in `worker`: default delegated implementation role
- built-in `explorer`: default delegated investigation role
- `sb-thinker`: Sol high with read-only access

`$sb:code` is the main entry point for routing executable changes through Fast, Deep, Ultra, or PoC workflows. Main dynamically owns orchestration: it decides when to work directly, delegate bounded investigation or implementation, use the read-only thinker for planning or review, wait, follow up, and converge. Deep and Ultra retain explicit plan approval and evidence-gated review; Fast and PoC semantics are unchanged. `$sb:review-with-subagents` is the single source of reviewer selection, spawning, waiting, and aggregation rules. The remaining skills are reusable capabilities injected only when useful.

### Install or update

```sh
cd codex
./install
```

The command registers this repository as a local Codex marketplace when needed, installs or refreshes `sb@agents`, updates `sb-thinker`, safely retires only proven SB-managed copies of the deprecated `sb-worker` and `sb-explorer` profiles, and keeps `sb-notes` available. Start a new Codex session after installation so the refreshed plugin and profile are loaded.

Verify the installed plugin and profiles with:

```sh
cd codex
./install --check
```

The installer preserves user-edited agent profiles and `sb-notes` helper by comparing them with SHA-256 hashes recorded under `$CODEX_HOME/sb/state/`. It refuses to overwrite `sb-thinker` when it differs from the last SB-installed version, and preserves deprecated profiles unless their ownership is proven by prior install state or a matching legacy snapshot. Durable task state is optional: activate it only for work expected to cross sessions or when durable resume is explicitly needed, and store it privately under `${SB_NOTES_ROOT:-$HOME/.notes}` rather than in a repository singleton.

## Layout

```text
codex/
├── .agents/plugins/marketplace.json  # local marketplace
├── install                            # install, update, and verification entry point
└── plugins/sb/
    ├── .codex-plugin/plugin.json      # plugin manifest
    ├── assets/agents/                 # read-only sb-thinker profile
    ├── assets/bin/sb-notes            # durable task-state helper
    ├── scripts/install-agents         # profile installer and conflict protection
    ├── scripts/install-sb-notes       # helper installer and conflict protection
    └── skills/                         # workflow and capability skills
```

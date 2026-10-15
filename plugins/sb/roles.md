# Runtime Roles

Skills name delegated roles and fresh-context handoffs without runtime syntax. Use the column for the runtime you are running in; a role is a capability boundary, not a required delegation.

| Role or term | Codex | Claude Code |
| --- | --- | --- |
| `explorer`: bounded read-only investigation | built-in `explorer` | built-in `Explore` agent |
| `thinker`: read-only planning or review reasoning | `sb-thinker` profile | `sb:thinker` plugin agent |
| `worker`: the single implementation writer | built-in `worker` | built-in `general-purpose` agent |
| `general`: a tool-free check of supplied text | built-in `default` agent | built-in `general-purpose` agent |
| Fresh thread that inherits no conversation | spawn with `fork_turns: "none"` | a new Agent call, never a `fork` |
| Reusing a delegated thread | send input to the existing agent | `SendMessage` to the existing agent |
| A linked skill such as [Review](skills/review/SKILL.md) | `$sb:review` | the `sb:review` skill, typed as `/sb:review` |

A fresh thread receives only what the assignment supplies, so include the instructions and evidence the linked skill requires rather than a path alone when the role has no repository access.

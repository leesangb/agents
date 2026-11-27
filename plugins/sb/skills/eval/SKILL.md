---
name: eval
description: Compare versions of an agent skill or workflow on matched tasks with blinded grading. Use when deciding whether an instruction change improves agent behavior.
disable-model-invocation: true
---

# Eval

Choose a decision the experiment can inform. Identify the baseline and proposed versions, the observable behavior that should improve, and a plausible regression. Select realistic cases that distinguish them. For a review skill, pair a case containing a defect with a similar case where the owner already handles it. Check the expected behavior through the public entry point when feasible. Write down the scoring criteria and expected observations before seeing outputs. Keep them with the coordinator.

## Run matched tasks

- Give each version the same user request and starting artifact for each case. Hold the model, effort, tools, permissions and budget constant unless one is the variable under study. Record versions and material differences.
- Start each run in a fresh context with its own workspace and just its assigned instructions and inputs. Keep other runs, the rubric and version labels out of its brief and working files. For a discovery evaluation, expose the skill through normal installation and use a natural request. For a content evaluation, pointing the agent at the assigned skill is sufficient.
- Preserve each answer or artifact, including failed or incomplete attempts. When a criterion concerns an action such as opening a reference or executing a check, use the scoped run's tool record or observable effect. Mark it unverified if that evidence is unavailable.

## Grade and decide

Run deterministic checks where possible. For judgments, give a fresh grader the same rubric, case inputs and anonymized outputs together in shuffled order. Keep the version key private until scores are recorded. If independent grading is unavailable, identify who knew the assignments and qualify the result.

Inspect evidence for each decisive score and unblind. Check unexpected findings against the case before counting false positives. Report paired outcomes by case, failures, false positives, and the number of runs. A tie on a small sample can still show which cases both versions handle. Apply [Performance Evidence](../principle-performance-evidence/SKILL.md) before attributing an improvement. State whether the evidence supports adopting the change, keeping the baseline, or testing a remaining uncertainty.

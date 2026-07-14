---
description: Multi-agent review-and-revise loop with 4 specialist critics until quality converges
argument-hint: "<content, task, or path to review>"
---

# /orchestrate

You are the **orchestrator** of a multi-agent critique loop.

## Target

`$ARGUMENTS` / user message: what to review (paths, module, doc, draft).

## Critics (personas)

Load personas from `~/.grok/skills/grok-loops-kit/03-multi-agent-review/personas/`
(or project `.grok/skills/grok-loops-kit/...` / kit checkout):

| Persona file | Dimension | Clean verdict |
|--------------|-----------|---------------|
| `correctness-critic.md` | Factual / code correctness | ACCURATE |
| `domain-critic.md` | Scope / project conventions | ON_TARGET |
| `safety-critic.md` | Security / safety | SAFE |
| `style-critic.md` | Clarity / structure | CLEAR |

## Loop (max 4 rounds)

### Round 1

1. Orient: read target files, goal, repo conventions (`AGENTS.md`, README)
2. Spawn **4** `spawn_subagent` calls (`general-purpose`), description `[critic] <name> round 1`
   - Prepend each persona
   - Prompt: target, declared goal, round number
3. Collect reports; dedupe findings
4. Apply fixes yourself: CRITICAL + MAJOR required; MINOR if cheap

### Later rounds

5. Respawn 4 critics with: “what changed” summary + **other critics’ prior findings** (cross-check side effects)
6. Stop when:
   - All four clean verdicts → **converged**
   - Round 4 → report remaining issues
   - Same CRITICAL findings unchanged 2 rounds → thrash; escalate to user

## Why orchestrator holds context

Critics are fresh each spawn. You keep the scoreboard of findings across rounds.

## Final report

- Table: dimension × round verdict  
- Fixes applied (one line each)  
- Remaining findings + recommendation  

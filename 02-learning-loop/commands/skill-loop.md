---
description: Autonomously improve a Grok skill until it converges; journals LEARNINGS.md
argument-hint: "[skill name | blank = least-recently-improved | all]"
---

# /skill-loop

You are running an **autonomous skill-improvement loop** for Grok skills.

## Target

Arguments: `$ARGUMENTS` (or the user's message after the command).

- Named skill → improve `~/.grok/skills/<name>/` or `./.grok/skills/<name>/` (prefer project if both exist)
- Empty → pick the skill whose `LEARNINGS.md` is oldest (or missing)
- `all` → run the full loop on each skill, one at a time

## Persona

Read and prepend the skill-improver persona from the first path that exists:

- `~/.grok/skills/grok-loops-kit/02-learning-loop/personas/skill-improver.md`
- `./.grok/skills/grok-loops-kit/02-learning-loop/personas/skill-improver.md`
- kit checkout `02-learning-loop/personas/skill-improver.md`

If persona file is missing, use embedded principles: exercise skill, one gap, one SKILL.md edit, journal LEARNINGS.md, verdict `GAP_FOUND` or `CONVERGED`.

## Loop

Repeat until stop:

1. `spawn_subagent` with description `[skill-improver] round N: <skill>`  
   Prompt = persona + skill path + round number + current LEARNINGS.md  
   `subagent_type`: `general-purpose`
2. Wait for result. Expect `GAP_FOUND: ...` or `CONVERGED`.
3. Stop when:
   - 2 consecutive `CONVERGED`
   - 6 rounds max
   - thrash (same change reverted twice)
4. Else N++ and continue.

## Rules

- Blast radius: **only** the skill folder (`SKILL.md`, references, scripts, LEARNINGS.md)
- Do not touch application code
- Do not run two improvers on the same skill in parallel
- Between rounds, `git status` if in a git skill repo — only skill paths should change

## Final report

- Converged vs hit cap; confidence  
- One line per round  
- Path to updated LEARNINGS.md  

---
description: Verification loop — score → fix → repeat until target score or stop conditions
argument-hint: "[max-iterations default 5] [target-score default 90]"
---

# /review-loop

You are the **orchestrator** of the verification loop. Run autonomously until a stop condition; report once at the end.

## Parameters

Parse `$ARGUMENTS`: `MAX_ITERATIONS` (default 5), `TARGET_SCORE` (default 90).

## Players

| Role | Persona | Behavior |
|------|---------|----------|
| Scorer | `~/.grok/skills/grok-loops-kit/04-verification-loop/personas/scorer.md` | Read-only; writes `docs/scores/iter-N.json` |
| Implementor | `.../personas/implementor.md` | Edits code from PRD + findings |

Use `spawn_subagent` with description `[scorer] iter N` or `[implementor] iter N`.  
Scorer: prefer `capability_mode` / instructions that forbid writes (state explicitly: read-only; no file edits).  
Implementor: full write access.

## Loop

State: `iteration=1`, `history[]`, `noImproveStreak=0`.

1. Orient: find PRD/spec (`docs/`, `PRD.md`, `README.md`). If missing, ask user once.
2. Spawn scorer with iteration N → read `docs/scores/iter-N.json`
3. Stop if:
   - `score >= TARGET_SCORE` → success  
   - `iteration >= MAX_ITERATIONS`  
   - score not improved for 2 iterations (`noImproveStreak >= 2`)
4. Spawn implementor with PRD path + findings JSON path  
5. iteration++; goto 2  

## Rules

- Never run scorer and implementor in parallel  
- If implementor leaves build broken, fix before next score  
- Never overwrite prior `iter-N.json`  

## Final report

- Score trajectory (e.g. 40 → 62 → 81 → 91)  
- Open findings if stopped early  
- Which stop condition fired  

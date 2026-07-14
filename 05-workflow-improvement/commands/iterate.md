---
description: Workflow-improving loop — deliver FR via process, score, then improve the process itself
argument-hint: "[N | all] how many FRs (default 1)"
---

# /iterate

You orchestrate the **workflow-improving loop**. Memory lives on disk under `process/`, not only in chat.

## Parameter

`$ARGUMENTS`: number of FR iterations, or `all` for every FR in the PRD. Default 1.

## Prerequisites

- `process/process.md` — if missing, copy kit template and confirm with user  
- `process/rubric.md`  
- PRD with enumerated FRs (`docs/prd.md` or similar)

## Agents (personas)

| Persona | Writes |
|---------|--------|
| `~/.grok/skills/grok-loops-kit/05-workflow-improvement/personas/builder.md` | app code + `process/telemetry/iter-N.json` |
| `.../personas/scorer.md` | append score to same JSON (read-only app) |
| `.../personas/process-optimizer.md` | `process/process.md`, `versions/`, `changelog.md` |

## One iteration

1. Pick next undelivered FR (check existing telemetry)  
2. Spawn builder → wait  
3. Spawn scorer → wait  
4. Spawn process-optimizer → wait  
5. Scoreboard line: `iter N · FR-X · process vA→vB · score S`

**Sequential only.**

## Stop

- Requested iterations done, or all FRs done  
- Abort if score drops 2 iterations in a row (suggest process revert via changelog)  
- Abort if same FR fails builder twice  

## Final report

- Table: iter · FR · score · process version · retro change  
- Score trajectory  
- Final process version (second deliverable)  

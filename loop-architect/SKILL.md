---
name: loop-architect
description: >
  Design hardened autonomous agent loops as durable <name>-loop.md specs:
  external check, named stop states, guardrails, disk memory, health metric.
  Specifies the loop; does NOT run it. Use when designing adaptive multi-turn
  loops, overnight automation, coverage/error/perf drain loops, "agent loop",
  "forge a loop", "loop until X", or /loop-architect. Not for one-shot /goal
  strings without adaptation (use a simple /goal instead).
metadata:
  short-description: "Spec autonomous agent loops"
  author: "adapted from giovani-junior-dev/loop-architect for Grok"
---

# loop-architect (Grok)

Architect of autonomous agent loops. You **write** a durable `<name>-loop.md`
document. You do **not** execute the loop.

> The central ability of a loop is not the prompt. It is the **check** that
> decides when work ended.

Announce: `Using loop-architect to specify an autonomous loop.`

## Default ready loop (from this kit)

A production loop is already specified and **ready to run when asked** (do not run until the user says so):

| | |
|--|--|
| **Name** | `zero-errors-to-goals` |
| **Objective** | Zerar erros (build/type/test/lint) **até completar todos os goals** |
| **Spec** | `~/.grok/loops/zero-errors-to-goals-loop.md` (or kit `06-zero-errors-to-goals/loops/`) |
| **Slash** | `/loop-zero-errors` |

When the user wants that behavior without redesigning: **point to or copy that file** into the project; only re-interview if they need a different loop.

Kit home after install: `~/.grok/skills/grok-loops-kit/` (personas + runners).

## Non-negotiable principles

1. **External check only** — command, test suite, or measurable number. Self-score 1–10 is forbidden.
2. **Evidence in the transcript** — every turn must **run the check and echo full output** into the conversation (or into `loop-state/` and the runner's log). Evaluators and humans must not need to re-open files to see pass/fail.
3. **Four named terminal states** — `success` | `no-progress` | `blocked` | `exhausted`. **Error or blown budget is NEVER success.**
4. **One change per turn** — worst first; snapshot "before" as baseline.
5. **Real guardrails** — hard turn/cost/time ceiling, no-progress rule, human approval before irreversible actions.
6. **Memory on disk** — state survives turns and fresh-context restarts.
7. **Spec saved before delivery** — write `<name>-loop.md` first; then give the trigger.

## Phase 0 — Triage (always first)

Ask (and answer out loud):

> **Does the result of each turn change the next action?**

| Answer | Action |
|--------|--------|
| **No** | Not a loop. For a single measurable stop condition, deliver a Grok `/goal <condition>` string (and optional short plan). Stop. |
| **Yes** | Adaptive work (find→fix→recheck, coverage climbs, errors drain, perf converges) **or** needs disk memory / multi-session / sub-loops / multiple exit states → continue. |

Also reject pure creative/subjective goals with no external check.

## Phase 1 — Interview (eight questions, one at a time)

Do **not** dump all questions in one message.

1. **Goal** — concrete end state? (Optional: inputs the loop must ask each run)
2. **Verifiable?** — number / test / command, or judgment-only?
3. **Check** — exact command(s) that prove a turn worked?
4. **Trigger** — manual, scheduled, or event-driven?
5. **Stop states** — besides success, which apply?
6. **Skills** — which named skills inside each turn? (Optional: sub-loops?)
7. **Memory** — where does state live on disk?
8. **Guardrails** — turn/cost ceiling; where is human approval required?

If the user already pasted a full brief, extract answers and **confirm** gaps only.

## Phase 2 — Hardening

Apply before writing the file:

- External check, not self-score
- Check output echoed every turn
- If an LLM judges quality: **frozen rubric** + **generator ≠ evaluator** (separate session/model) + **no shared maker history** with the judge
- All four terminal states named; error/budget ≠ success
- One change/turn; worst-first; before-snapshot
- List reusable skills the loop calls (e.g. `tdd`, `systematic-debug`, `verify-done`) — a bare `while true` around a free-form prompt is weak
- Sub-loops: multiplicative ceiling (parent × child); **no cycles**
- Disk memory path + fields
- Health metric: `cost_per_accepted_change = tokens_or_$ / changes_that_passed_check`

## Phase 3 — Execution model (choose trigger)

| Run length | Prefer | Grok mechanism |
|------------|--------|----------------|
| Short / medium (fits one session) | Bounded autonomous goal | `/goal <condition>` in TUI (if goal feature enabled), with max turns/time stated in the condition text |
| Long (context overflow / overnight) | **Ralph skeleton** | Shell loop: **fresh** `grok -p "..."` each turn, reading the loop spec + `./loop-state/` |

### Short/medium — `/goal` condition rules

The condition string must:

- State the **external check** and what "pass" looks like
- Require echoing check output each turn
- Bound with `or stop after N turns` / `or stop after Xm`
- Map failures to **blocked / no-progress / exhausted**, never silent "done"

Example shape (adapt, do not copy blindly):

```
/goal Work the loop in loops/<name>-loop.md: one change per turn (worst first), run the Check commands, paste full output each turn, update loop-state/. Stop only on success|no-progress|blocked|exhausted as defined in the spec. Or stop after 25 turns.
```

### Long — Ralph skeleton (bash)

```bash
# Fresh context each turn. State on disk. Needs: sandbox + MAX_TURNS + no-progress.
# Windows: use Git Bash, WSL, or the PowerShell skeleton in references/ralph-runner.ps1
set -euo pipefail
NAME="<name>"
MAX_TURNS=20
SPEC="loops/${NAME}-loop.md"
STATE="loop-state"
mkdir -p "$STATE"
turn=0
while [ "$turn" -lt "$MAX_TURNS" ]; do
  turn=$((turn + 1))
  echo "=== turn $turn ===" | tee -a "$STATE/runner.log"
  grok -p "Read ${SPEC} and ./${STATE}/. You are turn ${turn}/${MAX_TURNS}. Do exactly ONE change (worst first). Run the Check commands from the spec. Echo FULL check output. Update ./${STATE}/ (progress, last_metric, last_decision, turn_count, status). Write status as exactly one of: success|no-progress|blocked|exhausted|continue. Stop after updating status." \
    --cwd "$(pwd)" \
    --max-turns 40 \
    --output-format plain \
    2>&1 | tee -a "$STATE/runner.log" || true
  status=$(cat "./${STATE}/status" 2>/dev/null || echo continue)
  case "$status" in
    success|blocked|exhausted|no-progress) echo "terminal: $status"; break ;;
  esac
done
```

Prefer **no** `--yolo` by default. If the user wants unattended runs, state the risk and list forbidden actions in the spec.

PowerShell variant: `~/.grok/skills/loop-architect/references/ralph-runner.ps1` (parameterize name).

## Phase 3.5 — Where to save

| Scope | Path |
|-------|------|
| Project (default) | `<repo>/loops/<name>-loop.md` |
| Global / reusable | `~/.grok/loops/<name>-loop.md` |

- Create dirs if missing
- **Never overwrite** — use `-v2`, `-v3`; v2+ must include `## Lessons from previous version`
- If repo already uses `.loops/` or `agents/loops/`, ask which convention to use
- State dir default: `./loop-state/` (gitignored recommendation — tell the user)

Optional slash-style helper for Grok: also write
`~/.grok/commands/loop-<name>.md` or project `.grok/commands/loop-<name>.md`
that points at the spec (only if the user wants a slash entry).

## Deliverable template

Use this structure (full example in `references/template.md`):

```markdown
# <name> loop

## Description
## Use when
## Inputs          <!-- optional -->
## Goal
## Check (the one that decides)
- Command(s):
- Expected (literal / pattern):
- Echo mandatory: yes
## Turn steps
1. Snapshot "before"
2. Exactly ONE change (worst first)
3. Run Check; echo full output
4. Persist state to disk
5. Evaluate terminal states
## Named stop states
- success:
- no-progress: 2 turns with no measurable gain (define metric)
- blocked:
- exhausted: N turns / budget
(Error or blown budget is NEVER success.)
## Guardrails
- Hard ceiling:
- No-progress detection:
- Human approval before:
- Forbidden: --no-verify, force-push, secrets commit, lockfile drive-bys, suppress lint/types without approval, ...
## Memory
- Path: `./loop-state/`
- Fields: progress, last_metric, last_decision, turn_count, status
## Skills called
- e.g. tdd, systematic-debug, verify-done
## Sub-loops   <!-- optional -->
## Why it works
## How to trigger
- Short: `/goal ...`
- Long: Ralph skeleton (command block)
## Health metric
cost per accepted change = tokens_or_$ / changes that survived the Check
```

## Pre-delivery checklist

Before showing the trigger to the user:

- [ ] Phase 0 = adaptive (else handed off)
- [ ] Check is external
- [ ] Echo of check output required every turn
- [ ] Four terminal states named; error ≠ success
- [ ] One-change + worst-first + before-snapshot
- [ ] Hard ceiling + no-progress + human approval for irreversible
- [ ] LLM judge hardened if used
- [ ] Disk memory path defined
- [ ] Skills listed; sub-loop ceiling if any
- [ ] Health metric defined
- [ ] Spec **written to disk** first
- [ ] v2+ has lessons section

Any fail → fix before delivery.

## Anti-patterns

- Running the loop yourself (unless the user explicitly says "roda o loop agora")
- Accepting self-score as Check
- Only defining `success`
- Treating crash/timeout as success
- Multiple production changes per turn
- Memory only in chat
- Nested loops without multiplicative ceiling
- Delivering trigger before saving the file
- Overwriting prior specs

## Integration with other Grok skills

| Skill | Role inside a loop turn |
|-------|-------------------------|
| `tdd` | failing test before production change |
| `systematic-debug` | root cause before fix turns |
| `verify-done` | evidence before writing `success` |
| `superpowers` / `write-plan` | if the loop implements a planned feature, points at the plan |
| `/check-work` | optional adversarial verify on `success` candidate |

## User-facing close

After saving:

1. Absolute path of the spec  
2. Chosen execution model (short `/goal` vs long Ralph)  
3. Copy-paste trigger  
4. Reminder: **you specified; they run**  
5. Suggest adding `loop-state/` to `.gitignore` if not already  

## Subagents

If you are a subagent asked only to draft a section of a loop, do not re-run the full interview; complete the assigned section under the same principles.

# <name> loop

## Description

One paragraph: what this loop does and why it exists.

## Use when

Situation that should fire this loop (and when **not** to use it).

## Inputs

<!-- Optional: only if each run must ask the user for values -->

- `<name>`: ...

## Goal

Concrete measurable end state (not vibes).

## Check (the one that decides)

- **Command(s):**

  ```bash
  # exact commands
  ```

- **Literal expected output / pattern:** ...
- **Echo mandatory:** yes — full stdout/stderr (or relevant tail) every turn

## Turn steps

1. Snapshot the "before" baseline (metric, failing test list, etc.).
2. Do exactly **ONE** change (worst first).
3. Run the Check; echo full output into the transcript / runner log.
4. Persist state to `./loop-state/`.
5. Evaluate terminal states; write `status`.

## Named stop states

- **success:** [condition read from the Check]
- **no-progress:** 2 turns with no measurable gain on [metric]
- **blocked:** [when to stop and ask a human]
- **exhausted:** hit [N turns | budget | wall clock]

(Error or blown budget is **NEVER** success.)

## Guardrails

- **Hard ceiling:** N turns | $X | duration
- **No-progress detection:** ...
- **Human approval before:** push, deploy, schema migrate, secret changes, public API break, ...
- **Forbidden:** `--no-verify`, force-push, committing secrets, drive-by lockfile edits, suppressing lint/types without approval, expanding scope outside Goal

## Memory

- **Path:** `./loop-state/`
- **Fields:**
  - `status` — `continue` | `success` | `no-progress` | `blocked` | `exhausted`
  - `turn_count`
  - `progress` — short narrative of accepted changes
  - `last_metric` — number or summary from Check
  - `last_decision` — what changed this turn and why
  - `baseline` — initial metric snapshot

## Skills called

- `tdd` — when changing production behavior
- `systematic-debug` — when Check fails for unclear reasons
- `verify-done` — before writing `success`

## Sub-loops

<!-- Optional -->

- Calls: `<other>-loop.md`
- Multiplicative ceiling: parent_turns × child_turns ≤ ...
- Cycles: forbidden

## Why it works

External Check + echo + four stop states + one-change-per-turn block reward hacking and thrashing.

## How to trigger

### Short / medium (same session)

```
/goal Read loops/<name>-loop.md and ./loop-state/. One change per turn (worst first). Run Check, paste full output, update loop-state/. Stop only on success|no-progress|blocked|exhausted. Or stop after N turns.
```

### Long (Ralph / fresh context)

```bash
# See skill references/ralph-runner.sh or ralph-runner.ps1
```

## Health metric

```
cost_per_accepted_change = tokens_or_dollars_spent / number_of_changes_that_passed_Check
```

Track roughly per run; if this rises without metric movement, stop and redesign the loop.

## Lessons from previous version

<!-- Required for -v2+ -->

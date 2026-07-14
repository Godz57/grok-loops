---
description: Run or prepare the ready loop that drains errors until all goals are complete
---

# /loop-zero-errors

Use the pre-built loop spec (first path that exists):

1. `./loops/zero-errors-to-goals-loop.md`
2. `~/.grok/loops/zero-errors-to-goals-loop.md`
3. `~/.grok/skills/grok-loops-kit/06-zero-errors-to-goals/loops/zero-errors-to-goals-loop.md`

## What to do

1. Read that file fully.
2. You are **not** redesigning the loop unless the user asks.
3. If the user only said "prepara" / "deixa pronto" without "roda": confirm the spec path and stop (do not execute).
4. If the user said "roda" / "run" / "executa":
   - Work in the **current project** cwd.
   - Create `./loop-state/` if missing.
   - Discover real check commands from the repo; write `./loop-state/config.md`.
   - Materialize open goals into `./loop-state/goals.md` if needed (from conversation, `/goal`, or plan files).
   - Execute the loop turn-by-turn per the spec (one change, worst-first, external checks, named stop states).
   - Prefer `systematic-debug`, `tdd`, and `verify-done` as listed in the spec.
   - Stop on success | no-progress | blocked | exhausted only.

## Goal of this loop (fixed)

**Zerar erros (build/type/test/lint) até completar todos os goals abertos.**

Success = all check commands exit 0 **and** goals_open = 0, with evidence echoed.

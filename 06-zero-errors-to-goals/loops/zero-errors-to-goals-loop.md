# zero-errors-to-goals loop

## Description

Loop reutilizável: a cada turno elimina o **pior erro** verificável (teste, typecheck, lint, build) e avança os **goals abertos** até ambos estarem limpos. Adaptativo — o resultado do check define a próxima correção. Especificado para Grok; não assume um repo específico.

## Use when

- Há falhas de teste/build/lint **e** goals abertos (`/goal`, checklist em `loop-state/goals.md`, ou plano em `docs/`)
- Você quer rodar até **zero erros + goals completos**, sem “acho que está ok”
- Sessão longa ou overnight com runner Ralph

**Não use quando:** objetivo for só estético/UX sem comando de prova; ou for um único fix trivial de um turno (use `/goal` simples ou `tdd`).

## Inputs

No **início de cada run**, se ainda não estiverem em `./loop-state/config.md`, definir:

1. **Check commands** do projeto (na ordem): build → typecheck → test → lint (só os que existirem; ler README / package.json / Makefile / AGENTS.md)
2. **Goals source** — uma de:
   - Grok `/goal` ativo + `update_goal` progress
   - Arquivo `./loop-state/goals.md` com checklist `- [ ]` / `- [x]`
   - Caminho de plano (`docs/superpowers/plans/...` ou `docs/goals/...`) com items abertos
3. **Max turns** (default: 30) e se push/PR é permitido (default: **não**)

## Goal

**Estado final mensurável:**

1. Todos os **Check commands** saem com **exit code 0**
2. Todos os **goals** da fonte escolhida estão **completos** (`- [x]` / goal cleared / itens do plano done)
3. Evidência dos dois pontos foi ecoada no transcript / `runner.log` no turno de sucesso

## Check (the one that decides)

### A — Error drain (métrica primária)

Rodar, em sequência, os comandos gravados em `./loop-state/config.md` (exemplos — **substituir** pelos reais do repo):

```bash
# Exemplos — o run real usa o que está em loop-state/config.md
# npm test
# npm run typecheck
# npm run lint
# cargo test
# pytest -q
```

- **Métrica:** contagem de falhas (testes failed + erros de type/lint/build). Preferir um número parseável; se não der, gravar “pass/fail por comando”.
- **Esperado no success parcial de erros:** todos exit 0.
- **Echo mandatory:** yes — stdout/stderr completo (ou tail de 200 linhas se monstro) **todo turno**.

### B — Goals complete (métrica secundária, obrigatória no success)

- Se `loop-state/goals.md`: zero itens `- [ ]` restantes (só `- [x]` ou lista vazia de abertos)
- Se `/goal` da sessão: goal cleared / `completed` com evidência
- Se plano: todos os checkboxes da seção ativa marcados

**Success final** = A **e** B verdadeiros no mesmo turno.

## Turn steps

1. **Snapshot “before”**  
   - Rodar Check A; gravar `last_metric` (ex.: `errors=12` ou `tests_failed=3,type_errors=5`)  
   - Contar goals abertos → `goals_open=N`  
   - Se for o turno 1 e não existir config, descobrir comandos do repo e escrever `loop-state/config.md`

2. **Uma mudança só (pior primeiro)**  
   Prioridade fixa:  
   (1) falha de **build/compile** → (2) **type error** → (3) **test failure** → (4) **lint** → (5) avanço de **goal** que desbloqueia check  
   - Usar `systematic-debug` se a causa não for óbvia  
   - Usar `tdd` se for mudança de comportamento  
   - Não refatorar “no caminho” nem abrir escopo

3. **Rodar Check A (+ B se A limpo)**; ecoar saída completa  

4. **Persistir** `./loop-state/`:  
   `status`, `turn_count`, `progress`, `last_metric`, `last_decision`, `goals_open`, `baseline` (turno 1)

5. **Avaliar terminal states** (abaixo)

## Named stop states

- **success:** Check A exit 0 em **todos** os comandos **e** `goals_open=0` (goals completos), com eco no log deste turno  
- **no-progress:** 2 turnos seguidos com a mesma `last_metric` e mesmo `goals_open` (nenhuma melhoria mensurável)  
- **blocked:** precisa de decisão humana / secret / acesso / requisito ambíguo / 3 falhas no mesmo arquivo sem hipótese nova  
- **exhausted:** atingiu `max_turns` (default 30) ou budget explícito  

(Error do runner, crash do agente ou budget estourado é **NEVER** success — gravar `exhausted` ou `blocked`.)

## Guardrails

- **Hard ceiling:** 30 turns (override em `config.md`)  
- **No-progress:** 2 turns sem queda em `errors` nem em `goals_open`  
- **Human approval before:** push, force-push, deploy, migrate DB, editar secrets, mudar API pública, `--yolo` unattended  
- **Forbidden:**  
  - `--no-verify` / skip hooks  
  - force-push  
  - commitar secrets  
  - apagar testes para “ficar verde”  
  - `# type: ignore` / `eslint-disable` em massa sem aprovação  
  - expandir escopo além dos goals listados  
  - múltiplas features no mesmo turno  

## Memory

- **Path:** `./loop-state/` (adicione ao `.gitignore` do projeto)  
- **Files:**  
  - `config.md` — comandos de check, max_turns, goals source  
  - `status` — `continue` | `success` | `no-progress` | `blocked` | `exhausted`  
  - `turn_count`  
  - `progress` — log append-only de mudanças aceitas  
  - `last_metric` — ex. `errors=3;goals_open=2`  
  - `last_decision` — o que mudou e por quê  
  - `baseline` — métrica inicial  
  - `goals.md` — checklist se a fonte for arquivo  
  - `runner.log` — se usar Ralph  

## Skills called

- `systematic-debug` — root cause antes de patch em erro não trivial  
- `tdd` — regressão/teste falhando antes de fix de comportamento  
- `verify-done` — obrigatório no turno candidato a `success`  
- `write-plan` / plano existente — se o goal for multi-step e ainda não houver checklist  

## Sub-loops

Nenhum por padrão. Se um goal exigir sub-loop (ex.: só coverage), ceiling multiplicativo ≤ `max_turns` do pai; proibir ciclos.

## Why it works

Dois checks externos (erros **e** goals) impedem “suite verde com goal pela metade” e “goal marcado com build quebrado”. Uma mudança por turno + pior-primeiro evita thrashing. Estados nomeados impedem falso success.

## How to trigger

### Curto / médio (mesma sessão Grok)

```
/goal Read the loop at ~/.grok/loops/zero-errors-to-goals-loop.md (or project copy). Init loop-state/ if needed. Each turn: one change worst-first, run Check A, echo full output, update goals, write loop-state/. Stop only on success|no-progress|blocked|exhausted. Success = all check commands exit 0 AND goals_open=0. Or stop after 30 turns.
```

### Longo (Ralph / fresh context) — PowerShell

```powershell
# Do diretório do projeto (com loop-state/ e, se quiser, copy local do spec):
Copy-Item "$env:USERPROFILE\.grok\loops\zero-errors-to-goals-loop.md" .\loops\ -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path .\loops, .\loop-state | Out-Null
if (-not (Test-Path .\loops\zero-errors-to-goals-loop.md)) {
  Copy-Item "$env:USERPROFILE\.grok\loops\zero-errors-to-goals-loop.md" .\loops\zero-errors-to-goals-loop.md
}
& "$env:USERPROFILE\.grok\skills\loop-architect\references\ralph-runner.ps1" -Name zero-errors-to-goals -MaxTurns 30
```

### Longo — bash

```bash
mkdir -p loops loop-state
cp -n ~/.grok/loops/zero-errors-to-goals-loop.md loops/ 2>/dev/null || \
  cp ~/.grok/loops/zero-errors-to-goals-loop.md loops/zero-errors-to-goals-loop.md
# Ralph runner expects loops/<name>-loop.md — name must match file stem without -loop.md suffix issue
# File is zero-errors-to-goals-loop.md → NAME=zero-errors-to-goals
bash ~/.grok/skills/loop-architect/references/ralph-runner.sh zero-errors-to-goals 30
```

## Health metric

```
cost_per_accepted_change = tokens_or_$ / number_of_turns_where_last_metric_improved
```

Se o custo sobe e `errors` + `goals_open` não caem por 2+ turns → `no-progress` / redesenhar check.

## Status

**ready** — especificado em 2026-07-14. Não executado ainda; preencher `loop-state/config.md` no primeiro run do projeto.

# Grok Loops — Kit de Loop Engineering para Grok Build

> Adaptado de [giovani-junior-dev/loops](https://github.com/giovani-junior-dev/loops) (Claude Code) para o ecossistema **Grok Build** (skills, commands, subagents, `/goal`, headless `grok -p`).

**5 tipos de loop + 1 loop de produção pronto + loop-architect** para especificar novos loops.

## Por que loops

Prompts únicos quebram em tarefas longas. Um **loop** define:

1. o que o agente faz a cada turno  
2. o **check externo** que prova progresso  
3. quando parar (`success` / `no-progress` / `blocked` / `exhausted`)  
4. onde a memória vive (disco, não só chat)

## Estrutura

| Pasta | Loop | Quando usar |
|-------|------|-------------|
| `01-stateless-goal/` | Stateless (`/goal`) | Tarefa com verificação automática (testes, build). |
| `02-learning-loop/` | Learning | Melhorar uma skill do Grok iterativamente. |
| `03-multi-agent-review/` | Multi-agent review | Revisar código/docs com 4 críticos em paralelo. |
| `04-verification-loop/` | Verification | Implementer + scorer 0–100 (juiz read-only). |
| `05-workflow-improvement/` | Workflow | Melhora o **processo** de build, não só o produto. |
| `06-zero-errors-to-goals/` | Error drain | **Pronto:** zerar erros até completar todos os goals. |
| `loop-architect/` | Meta-skill | Especifica novos loops (`<name>-loop.md`). |
| `runners/` | Ralph runners | Fresh-context shell loops (`grok -p` por turno). |

## Install

### Windows (recomendado)

```powershell
cd grok-loops
.\scripts\install.ps1            # global: ~/.grok/
.\scripts\install.ps1 -Project   # no projeto atual: ./.grok/
```

### Manual

Copie `commands/*` → `~/.grok/commands/` (ou `./.grok/commands/`)  
Copie skills (`loop-architect`, etc.) → `~/.grok/skills/<name>/`  
Personas ficam no repo e são **lidas e injetadas** nos prompts de subagent (padrão Grok).

Reinicie a sessão do Grok (ou confie no auto-reload de skills).

## Como o Grok difere do Claude Code

| Claude Code (original) | Grok Build (este kit) |
|------------------------|------------------------|
| `.claude/commands/` | `.grok/commands/` ou skills |
| `.claude/agents/` | `personas/*.md` + `spawn_subagent` |
| `Task` tool | `spawn_subagent` |
| `claude -p` | `grok -p` |
| Tools no frontmatter do agent | Instruções de persona + capability do subagent |
| `/goal` nativo Haiku evaluator | `/goal` Grok (quando habilitado) + checks no transcript |

## Uso rápido

```
/goal …                    # loop 01 (nativo)
/skill-loop tdd            # loop 02
/orchestrate review auth   # loop 03
/review-loop 5 90          # loop 04
/iterate 3                 # loop 05
/loop-zero-errors          # loop 06 (run)
/loop-architect            # especificar loop novo
```

## Companions

| Kit | Papel |
|-----|--------|
| [grok-superpowers](https://github.com/Godz57/grok-superpowers) | Processo: design → plan → TDD → verify |
| [grok-craftsman](https://github.com/Godz57/grok-craftsman) | Polícia always-on: Clean Code, YAGNI, anti-patterns |
| [grok-pentest](https://github.com/Godz57/grok-pentest) | Pentest / OWASP em apps vibe-coded |
| [grok-strix](https://github.com/Godz57/grok-strix) | Wrapper Strix (PoC / Docker / multi-agent) |
| [grok-cyber-skills](https://github.com/Godz57/grok-cyber-skills) | Router 817 skills (mode D) |
| [grok-ai-memory](https://github.com/Godz57/grok-ai-memory) | Memória / handoff Grok+Pi |

Loops automatizam **como o agente gira**; Superpowers **como planejar/entregar**; Craftsman **o que é proibido/medido** em cada linha.

## Créditos

- Arquitetura de loops: inspirada em *Types of Agent Loops* / AI Labs e no kit [giovani-junior-dev/loops](https://github.com/giovani-junior-dev/loops)
- Spec hardening: ideias de [loop-architect](https://github.com/giovani-junior-dev/loop-architect)
- Adaptação Grok Build: este repositório

## License

MIT

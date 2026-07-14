# 03 — Multi-Agent Review Loop

Conselho de 4 críticos especializados (inspirado no LLM Council / Karpathy). Cobre pontos cegos de um único reviewer.

## Arquivos

| Arquivo | Papel |
|---------|--------|
| `commands/orchestrate.md` | Orquestrador (`/orchestrate`) |
| `personas/correctness-critic.md` | Precisão factual |
| `personas/domain-critic.md` | Escopo e convenções do projeto |
| `personas/safety-critic.md` | Segurança e conteúdo sensível |
| `personas/style-critic.md` | Clareza e legibilidade |

## Uso

```
/orchestrate review the auth module
/orchestrate revisar docs/deploy.md
```

## Arquitetura (Grok)

- Orquestrador lê as 4 personas e faz **4× `spawn_subagent`** (paralelo quando possível)
- Aplica correções CRITICAL/MAJOR
- Redespacha com “what changed” + findings cruzados
- Cap: **4 rounds**; thrash CRITICAL idêntico 2× → escala ao usuário

## Custo

Moderado–alto (4 subagents × rounds). Personalize personas por domínio (tenant, RBAC, etc.).

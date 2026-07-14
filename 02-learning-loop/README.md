# 02 — Learning Loop

Melhora uma **skill do Grok** iterativamente: exercita, observa o gap, aplica **uma** mudança, registra em `LEARNINGS.md`. Repete até convergir.

## Arquivos

| Arquivo | Destino install |
|---------|-----------------|
| `commands/skill-loop.md` | `~/.grok/commands/skill-loop.md` |
| `personas/skill-improver.md` | lido pelo orquestrador e injetado no subagent |

## Uso

```
/skill-loop tdd
/skill-loop
/skill-loop all
```

## Convergência

- 2 rounds consecutivos `CONVERGED` → skill estável  
- Cap: 6 rounds  
- Thrash (mesma mudança revertida 2×) → para e reporta  

## Custo

Cada round idealmente compara com/sem skill (duas execuções headless). Use em skills quentes, onde a melhoria se paga.

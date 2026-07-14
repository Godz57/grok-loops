# 06 — Zero Errors Until Goals Complete

Loop de **produção pronto**: drena erros verificáveis (build → type → test → lint) e completa **todos os goals** abertos.

Este é o loop padrão recomendado no Grok para “trabalhar sozinho até ficar limpo”.

## Arquivos

| Arquivo | Install |
|---------|---------|
| `loops/zero-errors-to-goals-loop.md` | `~/.grok/loops/` ou `./loops/` no projeto |
| `loop-zero-errors.md` | `~/.grok/commands/loop-zero-errors.md` |

## Uso

```
/loop-zero-errors          # prepara ou roda conforme o pedido
```

Ralph (projeto):

```powershell
mkdir loops, loop-state -Force
Copy-Item path\to\grok-loops\06-zero-errors-to-goals\loops\zero-errors-to-goals-loop.md .\loops\
.\runners\ralph-runner.ps1 -Name zero-errors-to-goals -MaxTurns 30
```

## Success

- Todos os check commands com exit 0  
- `goals_open = 0`  
- Evidência ecoada no mesmo turno  

## Relação com o kit original

Equivale ao espírito do loop **01 (stateless goal)** + memória em disco e stop states do **loop-architect**, com objetivo fixo de error-drain + goals.

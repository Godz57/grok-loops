# 05 — Workflow Improvement Loop

Melhora o **processo de construção**, não só o produto. Cada iteração: builder → scorer → process-optimizer.

Diferença do learning loop (02): aquele melhora **uma skill**; este evolui o **workflow inteiro** (`process/process.md`).

## Arquivos

| Arquivo | Destino |
|---------|---------|
| `commands/iterate.md` | `~/.grok/commands/iterate.md` |
| `personas/*.md` | lidos pelo orquestrador |
| `process/process.md` | copiar para **raiz do projeto** `process/` |
| `process/rubric.md` | idem |

## Uso

```
/iterate
/iterate 3
/iterate all
```

Pré-requisito: PRD com FRs enumerados (`docs/prd.md`).

## Arquitetura

- **builder** — 1 FR + telemetria honesta  
- **scorer** — nota /100 vs rubrica (read-only no app)  
- **process-optimizer** — UMA mudança bounded no processo + previsão falsificável  
- Sequencial; memória em `process/` no disco  

## Custo

Alto por iteração. Compensa em multi-FR onde o processo melhorado se paga nas próximas.

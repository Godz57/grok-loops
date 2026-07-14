# 04 — Verification Loop

Dois papéis: **implementor** constrói/corrige; **scorer** (read-only) pontua 0–100. Loop até score ≥ alvo, cap de iterações, ou retornos decrescentes.

## Arquivos

| Arquivo | Papel |
|---------|--------|
| `commands/review-loop.md` | Orquestrador `/review-loop` |
| `personas/implementor.md` | Build/fix |
| `personas/scorer.md` | Review adversarial + score |

## Uso

```
/review-loop
/review-loop 3 85
```

Defaults: max 5 iterações, alvo 90.

## Arquitetura

- Scorer **nunca edita** código — só checks + leitura  
- Score mecânico: gate fail → cap 40; CRITICAL −15, MAJOR −5, MINOR −1  
- Achados em `docs/scores/iter-N.json`  
- Scorer refuta próprios findings antes de reportar  

## Custo

Alto. Use em app já maduro; no início prefira `/goal` + testes (loop 01) ou `06`.

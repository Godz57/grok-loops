# 01 — Stateless Loop (`/goal`)

O loop mais simples. Sem memória entre sessões (além do transcript). O agente repete até uma **condição verificável** ser atingida.

No Grok, use o comando nativo **`/goal`** quando estiver disponível na sessão. Esta pasta documenta o **método correto** + snippet para `AGENTS.md`.

## Como funciona

1. Você define um estado final **mensurável** (testes verdes, build 0, fila vazia…).
2. A cada turno o agente age e **roda o check**, ecoando a saída no chat.
3. O avaliador de goal (ou você) decide se continua ou para.

## Método correto

1. **Escreva / fixe os testes ANTES** da feature (padrão concreto).
2. Rode algo como:

```
/goal Implement feature X until all tests in tests/foo pass. Each turn run the test command and paste full output. Or stop after 25 turns.
```

3. Agente: código → check → falha → corrige → repete.

## Snapshot de git

Adicione o snippet de `AGENTS-snippet.md` ao `AGENTS.md` do projeto. Motivo: com autonomia, o rollback é o último commit bom — não a memória do modelo.

## Quando usar

- Bug com teste que falha  
- Refactor com suíte existente  
- Transformação com output conhecido  
- Pass/fail claro  

## Quando NÃO usar

- UI/design/escrita subjetiva sem check automático → use loops 03/04  
- Trabalho adaptativo multi-sessão com memória em disco → use `06` ou `loop-architect`  

## Relacionados

- Loop pronto de produção: `06-zero-errors-to-goals`  
- Spec de loop com stop states: `loop-architect`

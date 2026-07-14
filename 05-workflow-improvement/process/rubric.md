# Rubric — quality guard rail (score /100)

> Scorer rates each delivered FR against these dimensions. Adjust weights **before** `/iterate`.

| Dimension | Weight | Points for |
|-----------|--------|------------|
| Correctness | 40 | FR matches PRD; tests pass; edges covered |
| Code quality | 25 | Readable, repo conventions, right abstraction |
| Robustness | 15 | Errors handled; boundary validation |
| Tests | 15 | Tests fail if code breaks (not just line coverage) |
| Integration | 5 | No regressions; build/lint clean |

## Scoring rules

- Every point needs **evidence** (file:line, check output). No evidence = zero.  
- Broken build = total max **40**.  
- Score is for this FR; regression on prior FRs discounts Integration.  

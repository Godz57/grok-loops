# Process — v1

> The `builder` follows this for each FR. `process-optimizer` evolves this file (v1 → v2…). Old versions in `versions/`, changes in `changelog.md`.

## Step 1 — Take a feature

- Read the PRD; identify this iteration’s FR  
- Read this `process.md` fully before starting  

## Step 2 — Plan implementation

- Locate files the FR touches (grep/glob before writing)  
- List planned changes: files, functions, tests  

## Step 3 — Implement

- Write FR code following repo conventions  
- Write/update FR tests  
- Pre-handoff checks (all must pass):  
  - project build  
  - lint  
  - tests  

## Step 4 — Verify & handoff

- Run full suite once more  
- Commit a working git snapshot  
- Emit `process/telemetry/iter-N.json`  

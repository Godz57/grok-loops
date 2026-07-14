#!/usr/bin/env bash
# Install Grok Loops kit into ~/.grok (global) or ./.grok (project)
set -euo pipefail

KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-global}"

if [[ "$MODE" == "project" ]]; then
  BASE="$(pwd)/.grok"
  echo "Install mode: PROJECT -> $BASE"
else
  BASE="${HOME}/.grok"
  echo "Install mode: GLOBAL -> $BASE"
fi

COMMANDS="$BASE/commands"
SKILLS="$BASE/skills"
LOOPS="$BASE/loops"
KIT_STORE="$BASE/skills/grok-loops-kit"

mkdir -p "$COMMANDS" "$SKILLS" "$LOOPS" "$KIT_STORE"

copy_cmd() {
  local src="$1" dst="$2"
  if [[ -f "$KIT_ROOT/$src" ]]; then
    cp -f "$KIT_ROOT/$src" "$COMMANDS/$dst"
    echo "  command: $dst"
  fi
}

copy_cmd "02-learning-loop/commands/skill-loop.md" "skill-loop.md"
copy_cmd "03-multi-agent-review/commands/orchestrate.md" "orchestrate.md"
copy_cmd "04-verification-loop/commands/review-loop.md" "review-loop.md"
copy_cmd "05-workflow-improvement/commands/iterate.md" "iterate.md"
copy_cmd "06-zero-errors-to-goals/loop-zero-errors.md" "loop-zero-errors.md"

if [[ -d "$KIT_ROOT/loop-architect" ]]; then
  mkdir -p "$SKILLS/loop-architect"
  cp -R "$KIT_ROOT/loop-architect/." "$SKILLS/loop-architect/"
  echo "  skill: loop-architect"
fi

if [[ -f "$KIT_ROOT/06-zero-errors-to-goals/loops/zero-errors-to-goals-loop.md" ]]; then
  cp -f "$KIT_ROOT/06-zero-errors-to-goals/loops/zero-errors-to-goals-loop.md" \
    "$LOOPS/zero-errors-to-goals-loop.md"
  echo "  loop: zero-errors-to-goals-loop.md"
fi

for rel in \
  "02-learning-loop/personas" \
  "03-multi-agent-review/personas" \
  "04-verification-loop/personas" \
  "05-workflow-improvement/personas" \
  "05-workflow-improvement/process" \
  "01-stateless-goal" \
  "runners"
do
  if [[ -e "$KIT_ROOT/$rel" ]]; then
    mkdir -p "$KIT_STORE/$(dirname "$rel")"
    cp -R "$KIT_ROOT/$rel" "$KIT_STORE/$rel"
    echo "  kit: $rel"
  fi
done

cp -f "$KIT_ROOT/README.md" "$KIT_STORE/README.md"

echo ""
echo "Done. Restart Grok session or wait for skill reload."
echo "Personas: $KIT_STORE"

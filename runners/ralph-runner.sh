#!/usr/bin/env bash
# Ralph-style fresh-context runner for a loop-architect spec.
# Usage: ./ralph-runner.sh <name> [max_turns]
# Expects: loops/<name>-loop.md and writes ./loop-state/

set -euo pipefail

NAME="${1:?usage: ralph-runner.sh <name> [max_turns]}"
MAX_TURNS="${2:-20}"
SPEC="loops/${NAME}-loop.md"
STATE="loop-state"

if [[ ! -f "$SPEC" ]]; then
  echo "missing spec: $SPEC" >&2
  exit 1
fi

if ! command -v grok >/dev/null 2>&1; then
  echo "grok CLI not found on PATH" >&2
  exit 1
fi

mkdir -p "$STATE"
turn=0

while (( turn < MAX_TURNS )); do
  turn=$((turn + 1))
  {
    echo ""
    echo "=== turn ${turn}/${MAX_TURNS} $(date -Iseconds 2>/dev/null || date) ==="
  } | tee -a "$STATE/runner.log"

  # Prefer bounded tools in unattended runs; tighten --tools as needed.
  grok -p "Read ${SPEC} and ./${STATE}/. You are turn ${turn}/${MAX_TURNS}. Do exactly ONE change (worst first). Run the Check commands from the spec. Echo FULL check output. Update ./${STATE}/ files: progress, last_metric, last_decision, turn_count=${turn}, and status (exactly one of: success|no-progress|blocked|exhausted|continue). Stop after updating status." \
    --cwd "$(pwd)" \
    --max-turns 40 \
    --output-format plain \
    2>&1 | tee -a "$STATE/runner.log" || true

  status="$(cat "./${STATE}/status" 2>/dev/null || echo continue)"
  echo "status=${status}" | tee -a "$STATE/runner.log"
  case "$status" in
    success|blocked|exhausted|no-progress)
      echo "terminal: $status"
      exit 0
      ;;
  esac
done

echo "exhausted: hit MAX_TURNS=${MAX_TURNS}" | tee -a "$STATE/runner.log"
echo exhausted >"$STATE/status"
exit 0

# Ralph-style fresh-context runner for a loop-architect spec (Windows PowerShell).
# Usage: .\ralph-runner.ps1 -Name <name> [-MaxTurns 20]
# Expects: loops\<name>-loop.md and writes .\loop-state\

param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [int]$MaxTurns = 20
)

$ErrorActionPreference = "Continue"
$Spec = Join-Path "loops" "$Name-loop.md"
$State = "loop-state"

if (-not (Test-Path $Spec)) {
    Write-Error "missing spec: $Spec"
    exit 1
}

if (-not (Get-Command grok -ErrorAction SilentlyContinue)) {
    Write-Error "grok CLI not found on PATH"
    exit 1
}

New-Item -ItemType Directory -Force -Path $State | Out-Null
$log = Join-Path $State "runner.log"

for ($turn = 1; $turn -le $MaxTurns; $turn++) {
    $header = "`n=== turn $turn/$MaxTurns $(Get-Date -Format o) ==="
    Add-Content -Path $log -Value $header
    Write-Host $header

    $prompt = @"
Read $Spec and ./$State/. You are turn $turn/$MaxTurns. Do exactly ONE change (worst first). Run the Check commands from the spec. Echo FULL check output. Update ./$State/ files: progress, last_metric, last_decision, turn_count=$turn, and status (exactly one of: success|no-progress|blocked|exhausted|continue). Stop after updating status.
"@

    # --yolo intentionally omitted; add only for trusted sandboxes.
    & grok -p $prompt --cwd (Get-Location).Path --max-turns 40 --output-format plain 2>&1 |
        Tee-Object -FilePath $log -Append

    $statusPath = Join-Path $State "status"
    $status = "continue"
    if (Test-Path $statusPath) {
        $status = (Get-Content $statusPath -Raw).Trim()
    }
    Add-Content -Path $log -Value "status=$status"
    Write-Host "status=$status"

    switch ($status) {
        { $_ -in @("success", "blocked", "exhausted", "no-progress") } {
            Write-Host "terminal: $status"
            exit 0
        }
    }
}

Set-Content -Path (Join-Path $State "status") -Value "exhausted"
Add-Content -Path $log -Value "exhausted: hit MaxTurns=$MaxTurns"
Write-Host "exhausted: hit MaxTurns=$MaxTurns"
exit 0
